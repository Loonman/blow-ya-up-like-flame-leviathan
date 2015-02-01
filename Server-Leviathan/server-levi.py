# Echo server program
import socket
import sys
from BrickPi import *
import threading
import time
import json

HOST = "192.168.1.100"
PORT = 50007
s = None

# Motor Ports (Referenced when view bot from behind)
# Left Drive Wheel  PORT_A
# Right Drive Wheel PORT_D
# Steering Motor    PORT_C [-20, 20] deg
# Hammer Motor      PORT_B

# Drive motors are geared in revers (ie -speed is forwards)
# {"speed":200, "steer": 20, "aux":true}


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
        BrickPi.MotorEnable[left] = TYPE_MOTOR_SPEED
        BrickPi.MotorEnable[right] = TYPE_MOTOR_SPEED
        BrickPi.MotorEnable[aux] = TYPE_MOTOR_SPEED
        BrickPi.MotorEnable[steer] = TYPE_MOTOR_POSITION
        BrickPi.SensorType[PORT_2] = TYPE_SENSOR_LIGHT_ON
        BrickPi.SensorType[PORT_3] = TYPE_SENSOR_ULTRASONIC_CONT
        BrickPi.SensorType[PORT_4] = TYPE_SENSOR_LIGHT_ON
        BrickPiSetupSensors()
        BrickPi.Timeout = 300
        BrickPiSetTimeout()

    def set_steering(self, percent):
        if percent > 30:
            percent = 30
        if percent < -30:
            percent = -30
        motorRotateDegree([150], [percent - self.steer_deg], [PORT_C], timeout=0.5)
        self.steer_deg = percent
        BrickPiUpdateValues()

    def set_speed(self, percent):
        if percent > 255:
            percent = 255
        if percent < -255:
            percent = -255
        if percent > 0 or percent < 0:
            BrickPi.MotorSpeed[self.left] = -percent
            BrickPi.MotorSpeed[self.right] = -percent
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

car = Car(PORT_A, PORT_D, PORT_C, PORT_B)
while True:
    try:
        soc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    except socket.error as msg:
        soc = None
        print "Cannot make socket"
        continue
    try:
        soc.bind((HOST, PORT))
        soc.listen(1)
    except socket.error as msg:
        soc.close()
        soc = None
        print msg
        continue
    if soc is None:
        print 'could not open socket'
        sys.exit(1)
    conn, addr = soc.accept()
    print 'Connected by', addr
    while 1:
        data = conn.recv(1024)
        if not data:
            break
        data = data.strip().decode("utf-8").split("\r\n")
        for s in data:
            try:
                s = json.loads(s)
                print s

            except (ValueError, TypeError):
                print "Bad Parse"
                continue
            if "speed" in s and int(s["speed"]) != 0:
                print s["speed"]
                car.set_speed(s["speed"])
            if "steer" in s:
                car.set_steering(s["steer"])
            if "aux" in s and s["aux"]:
                car.aux_motor()
    conn.close()
    soc.close()
    time.sleep(0.5)
