# Echo server program
import socket
import sys
from BrickPi import *

HOST = 192.168.1.
PORT = 50007
s = None
BrickPiSetup()
motor1 = PORT_B
motor2 = PORT_C
BrickPi.MotorEnable[motor1] = 1
BrickPi.MotorEnable[motor2] = 1
BrickPiSetupSensors()
BrickPi.Timeout = 10000
BrickPiSetTimeout()

# while True:
#     try:
#         s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#     except socket.error as msg:
#         s = None
#         print "Cannot make socket"
#         continue
#     try:
#         s.bind((HOST, PORT))
#         s.listen(1)
#     except socket.error as msg:
#         s.close()
#         s = None
#         continue
#     if s is None:
#         print 'could not open socket'
#         sys.exit(1)
#     conn, addr = s.accept()
#     print 'Connected by', addr
#     while 1:
#         data = conn.recv(1024)
#         if not data:
#             break
#         conn.send(data)
#     conn.close()

if __name__ == "__main__":
    t = threading.Thread()
    t.daemon = True
    t.start()

    while True:
        inp = str(raw_input())  # Take input from the terminal
        # Move the bot
        if inp == 'w':
            fwd()
        elif inp == 'a':
            left()
        elif inp == 'd':
            right()
        elif inp == 's':
            back()
        elif inp == 'x':
            stop()
        elif inp == 'p':
            poll()

        BrickPiUpdateValues()   # Update the motor values

        time.sleep(.01)         # sleep for 10 ms
