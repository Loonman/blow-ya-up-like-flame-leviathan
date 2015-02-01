# Echo server program
import socket
import sys
from BrickPi import *
import threading
import time

HOST = "192.168.1.100"
PORT = 50007
s = None

# Motor Ports (Referenced when view bot from behind)
# Left Drive Wheel  PORT_A
# Right Drive Wheel PORT_D
# Steering Motor    PORT_C [-20, 20] deg
# Hammer Motor      PORT_B

# Drive motors are geared in revers (ie -speed is forwards)
car = new Car(PORT_A, PORT_D, PORT_C, PORT_B)
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

        data = json.loads(str(data.strip().decode("utf-8")))
        # Move the bot
        if data == 'w':
            car.set_speed(255)
        elif data == 'a':
            left()
        elif data == 'd':
            right()
        elif data == 's':
            back()
        time.sleep(.01)         # sleep for 10 ms
        conn.send("")
    conn.close()


class Car(object):
    """docstring for Car"""
    def __init__(self, left, right, steer, aux):
        super(Car, self).__init__()
        self.left = left
        self.right = right
        self.steer = steer
        self.aux = aux
        self.steer_deg = 0

        BrickPiSetup()

        # Setup Motors
        BrickPi.MotorEnable[left] = 1
        BrickPi.MotorEnable[right] = 1
        BrickPi.MotorEnable[aux] = 1
        BrickPi.MotorEnable[steer] = 1

        BrickPiSetupSensors()
        BrickPi.Timeout = 100
        BrickPiSetTimeout()

    def set_steering(self, percent):
        if percent > 30:
            percent = 30
        if percent < -30:
            percent = -30
        motorRotateDegree([150], [percent - self.steer_deg], [PORT_C])
        self.steer_deg = percent
        BrickPiUpdateValues()

    def set_speed(self, percent):
        if percent > 255:
            percent = 255
        if percent < -255:
            percent = -255
        BrickPi.MotorSpeed[self.left] = percent
        BrickPi.MotorSpeed[self.right] = percent
        BrickPiUpdateValues()

    def get_sensors(self, percent):
        pass

    def aux_motor(self):
        BrickPi.MotorSpeed[self.aux] = 255
        BrickPiUpdateValues()
        time.sleep(0.3)
        BrickPi.MotorSpeed[self.aux] = -255
        BrickPiUpdateValues()
        time.sleep(0.3)
        BrickPi.MotorSpeed[self.aux] = 0
        BrickPiUpdateValues()
        time.sleep(0.3)
