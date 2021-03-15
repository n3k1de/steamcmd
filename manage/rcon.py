#!/usr/bin/python3
import socket, sys, time, logging

import select
import socket
import struct

SERVERDATA_AUTH = 3
SERVERDATA_AUTH_RESPONSE = 2

SERVERDATA_EXECCOMMAND = 2
SERVERDATA_RESPONSE_VALUE = 0

MAX_COMMAND_LENGTH=510 # found by trial & error

MIN_MESSAGE_LENGTH=4+4+1+1 # command (4), id (4), string1 (1), string2 (1)
MAX_MESSAGE_LENGTH=4+4+4096+1 # command (4), id (4), string (4096), string2 (1)

# there is no indication if a packet was split, and they are split by lines
# instead of bytes, so even the size of split packets is somewhat random.
# Allowing for a line length of up to 400 characters, risk waiting for an
# extra packet that may never come if the previous packet was this large.
PROBABLY_SPLIT_IF_LARGER_THAN = MAX_MESSAGE_LENGTH - 400

class SourceRconError(Exception):
	pass

def main(argv):
	rcon = SourceRcon( str(argv[1]), int(argv[2]), str(argv[3]) )
	rcon.connect()
	resp = rcon.rcon( str(argv[4]) )
	rcon.disconnect()
	return resp

class SourceRcon(object):
	"""Example usage:
	import srcds
	server = srcds.SourceRcon('127.0.0.1', 27015, 'gerbouille')
	print(server.rcon('cvarlist'))
	"""
	login_max_retry = 10

	def __init__(self, host, port=27015, password='', timeout=5.0):
		self.host = host
		self.port = port
		self.password = password
		self.timeout = timeout
		self.tcp = None
		self.reqid = 0
	
	def disconnect(self):
		"""Disconnect from the server."""
		if self.tcp:
			self.tcp.close()

	def connect(self):
		"""Connect to the server. Should only be used internally."""
		try:
			self.tcp = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
			self.tcp.settimeout(self.timeout)
			# self.tcp.setblocking(1)
			self.tcp.connect((self.host, self.port))
		except socket.error as msg:
			raise SourceRconError('Disconnected from RCON, please restart program to continue. ({})'.format(msg))

	def send(self, cmd, message):
		"""Send command and message to the server. Should only be used internally."""
		if len(message) > MAX_COMMAND_LENGTH:
			raise SourceRconError('RCON message too large to send')

		self.reqid += 1
		data = struct.pack('<l', self.reqid) + struct.pack('<l', cmd) + bytearray(message, 'ascii') + b'\x00\x00'
		self.tcp.send(struct.pack('<l', len(data)) + data)

	def receive(self):
		"""Receive a reply from the server. Should only be used internally."""
		packetsize = False
		requestid = False
		response = False
		message = b''
		message2 = b''

		# response may be split into multiple packets, we don't know how many
		# so we loop until we decide to finish
		while 1:
			# read the size of this packet
			buf = b''

			while len(buf) < 4:
				try:
					recv = self.tcp.recv(4 - len(buf))
					if not len(recv):
						raise SourceRconError('RCON connection unexpectedly closed by remote host')
					buf += recv
				except SourceRconError:
					raise
				except:
					break

			if len(buf) != 4:
				# we waited for a packet but there isn't anything
				break

			packetsize = struct.unpack('<l', buf)[0]

			if packetsize < MIN_MESSAGE_LENGTH or packetsize > MAX_MESSAGE_LENGTH:
				raise SourceRconError('RCON packet claims to have illegal size: %d bytes' % (packetsize,))

			# read the whole packet
			buf = b''

			while len(buf) < packetsize:
				try:
					recv = self.tcp.recv(packetsize - len(buf))
					if not len(recv):
						raise SourceRconError('RCON connection unexpectedly closed by remote host')
					buf += recv
				except SourceRconError:
					raise
				except:
					break

			if len(buf) != packetsize:
				raise SourceRconError('Received RCON packet with bad length (%d of %d bytes)' % (len(buf),packetsize,))

			# parse the packet
			requestid = struct.unpack('<l', buf[:4])[0]

			if requestid == -1:
				self.disconnect()
				raise SourceRconError('Bad RCON password')

			elif requestid != self.reqid:
				raise SourceRconError('RCON request id error: %d, expected %d' % (requestid,self.reqid,))

			response = struct.unpack('<l', buf[4:8])[0]

			if response == SERVERDATA_AUTH_RESPONSE:
				# This response says we're successfully authed.
				return True

			elif response != SERVERDATA_RESPONSE_VALUE:
				raise SourceRconError('Invalid RCON command response: %d' % (response,))

			# extract the two strings using index magic
			str1 = buf[8:]
			pos1 = str1.index(b'\x00')
			str2 = str1[pos1+1:]
			pos2 = str2.index(b'\x00')
			crap = str2[pos2+1:]

			if crap:
				raise SourceRconError('RCON response contains %d superfluous bytes' % (len(crap),))

			# add the strings to the full message result
			message += str1[:pos1]
			message2 += str2[:pos2]

			# unconditionally poll for more packets
			poll = select.select([self.tcp], [], [], 0)

			if not len(poll[0]) and packetsize < PROBABLY_SPLIT_IF_LARGER_THAN:
				# no packets waiting, previous packet wasn't large: let's stop here.
				break

		if response is False:
			raise SourceRconError('Timed out while waiting for reply')

		elif message2:
			raise SourceRconError('Invalid response message: %s' % (repr(message2),))

		return message

	def auth(self):
		self.send(SERVERDATA_AUTH, self.password)
		auth = b''
		retry = 0
		# wait for response
		while auth == b'' and retry < SourceRcon.login_max_retry:
			retry = retry + 1
			auth = self.receive()

		if not auth:
			self.disconnect()
			raise SourceRconError('RCON authentication failure: {}'.format( repr(auth) ))
		else:
			return True

	def rcon(self, command):
		if '\n' in command:
			values = []
			commands = command.split('\n')
			for command in commands:
				values.append( self.rcon(command) )
			return values

		# send a single command. connect and auth if necessary.
		try:
			self.connect()
			data = False
			if self.auth():
				self.send(SERVERDATA_EXECCOMMAND, command)
				data = b''
				retry = 0
				
				while data == b'' and retry < 10:
					retry = retry + 1
					data = self.receive()
				data = data.decode('utf-8')
				data = data.split('\n')
				for i in range(len(data)):
					data[i] = data[i][:-1]
					if len(data[i]) == 0:
						del data[i]
			self.disconnect()
			return data
		except Exception as e:
			print('Exception: {}'.format(e))
			self.disconnect()
			self.connect()
			if self.auth():
				self.send(SERVERDATA_EXECCOMMAND, command)
				return self.receive()
			else:
				self.disconnect()
				raise SourceRconError('RCON authentication failure')

if __name__ == "__main__":

	logging.basicConfig(filename='rcon.log', format="%(asctime)s|%(levelname)s:\t%(message)s", datefmt='%Y-%d-%m %H:%M:%S',  level=logging.DEBUG)
	try:
		logging.info( main(sys.argv) )
	except SourceRconError as e:
		logging.error( 'SourceRconError: {}'.format(e) )
	except IndexError as e:
		logging.error( 'IndexError: {}'.format(e) )
