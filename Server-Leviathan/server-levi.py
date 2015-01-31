# Echo server program
import socket
import sys
from BrickPi import *
import threading
import time

HOST = "192.168.1.100"
PORT = 50007
s = None
BrickPiSetup()
motor1 = PORT_A
motor2 = PORT_D
BrickPi.MotorEnable[motor1] = 1
BrickPi.MotorEnable[motor2] = 1
BrickPiSetupSensors()
BrickPi.Timeout = 10000
BrickPiSetTimeout()

# Motor Ports (Referenced when view bot from behind)
# Left Drive Wheel PORT_A
# Right Drive Wheel PORT_D
# Steering Motor PORT_C [-20, 20] deg
# Hammer Motor PORT_B

# Drive motors are geared in revers (ie -speed is forwards)

while True:
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    except socket.error as msg:
        s = None
        print "Cannot make socket"
        continue
    try:
        s.bind((HOST, PORT))
        s.listen(1)
    except socket.error as msg:
        s.close()
        s = None
        continue
    if s is None:
        print 'could not open socket'
        sys.exit(1)
    conn, addr = s.accept()
    print 'Connected by', addr
    while 1:
        data = conn.recv(1024)
        if not data:
            break
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
        conn.send(data)
    conn.close()
speed = 255

def fwd():
    BrickPi.MotorSpeed[motor1] = speed  
    BrickPi.MotorSpeed[motor2] = speed  
#Move Left
def left():
    motorRotateDegree([255], [20], [PORT_C])
    BrickPi.MotorSpeed[motor1] = speed  
    BrickPi.MotorSpeed[motor2] = -speed 
    time.sleep(2)
    motorRotateDegree([255], [-20], [PORT_C])
#Move Right
def right():
    BrickPi.MotorSpeed[motor1] = -speed  
    BrickPi.MotorSpeed[motor2] = speed
#Move backward
def back():
    BrickPi.MotorSpeed[motor1] = -speed  
    BrickPi.MotorSpeed[motor2] = -speed
#Stop
def stop():
    BrickPi.MotorSpeed[motor1] = 0  
    BrickPi.MotorSpeed[motor2] = 0
