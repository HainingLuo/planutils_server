#!/usr/bin/python3

import time
import socket
import struct
import subprocess  
from os import path, walk
from pathlib import Path

from planutils import settings
from planutils.package_installation import check_installed, install

class PlanUtilSocket:
    def __init__(self):
        # create an INET, STREAMing socket
        self._socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self._socket.bind((socket.gethostname(), 80))
        # self._socket.bind(('localhost', 80))
        self._socket.listen(5)
        print("PlanUtils socket server ready.")
        # start the server
        while True:
            try:
                self.client_socket, client_addr = self._socket.accept()
                print ('Got connection from', client_addr)
                domain = self.receive()
                problem = self.receive()
                solver = self.receive()
                plan = self.plan(domain, problem, solver)
                self.send(plan)
            except:
                print('Interruption received. Terminating program.')
                self._socket.close()
                exit()

    """ receive problem and domain files from the websocket """
    def receive(self):
        # receive the header
        bytes = self.client_socket.recv(4)
        if len(bytes) != 4:
            print('Empty header received!')
            return
        msg_len = struct.unpack_from("I", bytes, 0)[0]

        # receive the actual content
        chunks = []
        bytes_recd = 0
        while bytes_recd < msg_len:
            chunk = self.client_socket.recv(min(msg_len - bytes_recd, 1024))
            if chunk == b'':
                raise RuntimeError("socket connection broken")
            chunks.append(chunk)
            bytes_recd = bytes_recd + len(chunk)
        return b''.join(chunks).decode()
    
    """ send plan through the websocket """
    def send(self, msg):
        msg = msg.encode()
        msg_len = len(msg)
        self.client_socket.send(struct.pack("I", msg_len))
        totalsent = 0
        while totalsent < msg_len:
            sent = self.client_socket.send(msg[totalsent:])
            if sent == 0:
                raise RuntimeError("socket connection broken")
            totalsent = totalsent + sent

    """ find plans with planutils """
    def plan(self, domain, problem, solver):

        # save the contents to files
        f = open('/pddl/domain.pddl', "w")
        f.write(domain)
        f.close()

        f = open('/pddl/problem.pddl', "w")
        f.write(problem)
        f.close()

        # start planning
        print('Planning with {}'.format(solver))
        if not check_installed(solver):
            print('Installing {}'.format(solver))
            success = install([solver], forced=True, always_yes=True)
            print(success)
        start = time.time()
        result = subprocess.run([Path(settings.PLANUTILS_PREFIX) / "packages" / solver / "run"] + ['domain.pddl','problem.pddl'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT).stdout.decode()
        end = time.time()
        if solver=='smtplan':
            if '0.0' in result:
                print('Solution found in {:.2f}s'.format(end-start))
                return result
            else:
                print('Received following error from the solver! \n{}'.format(result))
                return result
        elif solver=='lama':
            fns = []
            plans = ''
            for root, dirs, files in walk("/pddl"):
                for file in files:
                    if file.startswith("sas_plan."):
                        fns.append(path.join(root, file))
            for fn in fns:
                f = open(fn, "r")
                plans+=f.read()+'\n'
            return plans
        else:
            return result

if __name__ == "__main__":
    # start = time.time()
    # result = subprocess.run([Path(settings.PLANUTILS_PREFIX) / "packages" / "smtplan" / "run"] + ['domain.pddl','problem.pddl'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT).stdout.decode()
    # end = time.time()
    # result = popen('PLANUTILS_PREFIX="~/.planutils" PATH="$PATH:$PLANUTILS_PREFIX/bin" smtplan domain.pddl problem.pddl').read()
    # print(result)
    
    
    # print(mystdout.getvalue())

    planutils = PlanUtilSocket()
