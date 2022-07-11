#!/usr/bin/python3

import time
import socket
import struct
from os import popen, path

class PlanUtilsClient:
    """demonstration class only
      - coded for clarity, not efficiency
    """

    def __init__(self):
        self._socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self._socket.connect((socket.gethostname(), 80))

        content = ""
        f = open('demo_problem/domain.pddl', "r")
        content += f.read()
        f.close()
        self.send(content)

        content = ""
        f = open('demo_problem/problem.pddl', "r")
        content += f.read()
        f.close()
        self.send(content)

        self.send('smtplan')
        plan = self.receive()
        print(plan)

    def send(self, msg):
        msg = msg.encode()
        msg_len = len(msg)
        self._socket.send(struct.pack("I", msg_len))
        totalsent = 0
        while totalsent < msg_len:
            sent = self._socket.send(msg[totalsent:])
            if sent == 0:
                raise RuntimeError("socket connection broken")
            totalsent = totalsent + sent

    def receive(self):
        # receive the header
        bytes = self._socket.recv(4)
        if len(bytes) != 4:
            print('Empty header received!')
            return
        msg_len = struct.unpack_from("I", bytes, 0)[0]

        # receive the actual content
        chunks = []
        bytes_recd = 0
        while bytes_recd < msg_len:
            chunk = self._socket.recv(min(msg_len - bytes_recd, 1024))
            if chunk == b'':
                raise RuntimeError("socket connection broken")
            chunks.append(chunk)
            bytes_recd = bytes_recd + len(chunk)
        return b''.join(chunks).decode()
        

if __name__ == "__main__":
    planutils = PlanUtilsClient()
