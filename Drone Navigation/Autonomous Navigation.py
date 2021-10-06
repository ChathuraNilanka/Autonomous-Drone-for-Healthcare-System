import threading
import flask
import time
import json
from flask_cors import CORS
import RPi.GPIO as GPIO
from flask import request, jsonify
from dronekit import connect, VehicleMode, LocationGlobalRelative
from pymavlink import mavutil
import time
import argparse

# Initialize the necessary variables
serial_arg = "/dev/serial0"

target_lon = 0
target_lat = 0
target_alt = 12
status = 1
takeoffStatus = 0
reached = 0
releasePackage = 0
success = {
        "success": "ok"
    }


# Initialize the flask app and enable the CORS
app = flask.Flask(__name__)
app.config["DEBUG"] = False
CORS(app)



# Establish the connection between flight controller
print ("Connecting to vehicle on: %s" % serial_arg )
vehicle = connect(serial_arg, baud=57600, wait_ready=True)



# Setlocation endpoint for set the delivery location
@app.route('/drone/setlocation', methods=['POST'])
def setLocation():
    global target_lon, target_lat, target_alt

    if not request.json or not 'lat' in request.json:
        abort(400)
    
    target_lat = request.json["lat"]
    target_lon = request.json["lon"]
    target_alt = request.json["alt"]

    if target_lon == 0 or target_lat == 0 or target_alt == 0 :
        return jsonify({
            "status": False,
            "error": "Invalid inputs"}), 201
    print("lon", target_lon)
    print("lat", target_lat)
    print("Alt", target_alt)
    location = {
        "status": True,
        "lon": target_lon,
        "lat": target_lat,
        "alt": target_alt
    }
    return jsonify({"location": location}), 201



# Drone takeoff command endpoint
@app.route('/drone/takeoff', methods=['GET'])
def takeoff_cmd():
    global takeoffStatus, success
    takeoffStatus = 1
    return jsonify(success)



# Endpoint for get the drone informations
@app.route('/drone/getinfo', methods=['GET'])
def getlocation():
    currentLocation = {
        "lon": vehicle.location.global_frame.lon,
        "lat": vehicle.location.global_frame.lat,
        "alt": vehicle.location.global_frame.alt,
        "battery": vehicle.battery.voltage,
        "velocity": vehicle.velocity,
        "isArmed": bool(vehicle.armed),
        "status": str(vehicle.system_status)
     
    }
    return json.dumps(currentLocation)



# Package release endpoint for box opening machanism
@app.route('/drone/releasePackage', methods=['GET'])
def packageRelease():
    message = {
        "message": "Package Released successfully",
        "status": True
    }
    release_package()
    return jsonify(message)



# Drone takeoff function
def arm_and_takeoff(aTargetAltitude):
  print ("Basic pre-arm checks")
  while not vehicle.is_armable:
    print (" Waiting for vehicle to initialise...")
    time.sleep(1)
        
  print ("Arming motors")
  vehicle.mode    = VehicleMode("GUIDED")
  vehicle.armed   = True

  while not vehicle.armed:
    print (" Waiting for arming...")
    time.sleep(1)

  print ("Taking off!")
  vehicle.simple_takeoff(aTargetAltitude) 

  while True:
    print (" Altitude: ", vehicle.location.global_relative_frame.alt)         
    if vehicle.location.global_relative_frame.alt>=aTargetAltitude*0.95: 
      print ("Reached target altitude")
      break
    time.sleep(1)



# Waypoint navigation function
def goto_location(waypoint):
  global reached
  vehicle.airspeed=3
  vehicle.simple_goto(waypoint)
  time.sleep(2)
  while(not reached):
    time.sleep(1)
    a = vehicle.velocity
    if (abs(a[1])< 0.2 and abs(a[2])< 0.2 and abs(a[0])< 0.2):
      reached = 1
  print("Waypoint reached!")



# Drone landing function    
def Land():
  print("Landing")
  time.sleep(1)
  vehicle.mode = VehicleMode("LAND")
  while vehicle.armed:
    time.sleep(1)



# Package release function
def release_package():
    global releasePackage
    
    GPIO.setmode(GPIO.BOARD)
    GPIO.setup(11,GPIO.OUT)
    GPIO.setup(13,GPIO.OUT)

    servo1 = GPIO.PWM(13,50) 
    servo2 = GPIO.PWM(11,50)

    servo1.start(0)
    servo2.start(0)
    time.sleep(2)
    print("1")
    servo1.ChangeDutyCycle(2)
    servo2.ChangeDutyCycle(2)
    print("2")
    releasePackage = 1
    time.sleep(10)
    servo1.ChangeDutyCycle(7.3)
    time.sleep(1)
    servo2.ChangeDutyCycle(7.8)
    time.sleep(0.5)
    print("3")

    servo1.stop()
    
    GPIO.cleanup()
    
    return

# Autonomous navigation function
def navigation():
    global target_lon, target_lat, target_alt, reached, releasePackage
    print("nav lon", target_lon)
    print("nav lat", target_lat)
    print("nav Alt", target_alt)
    homeLocation_lat = vehicle.location.global_frame.lat
    homeLocation_lon = vehicle.location.global_frame.lon

    print("home_lon :", homeLocation_lon)
    print("home_lat :", homeLocation_lat)

    homeLocation = LocationGlobalRelative(homeLocation_lat, homeLocation_lon, target_alt)
    arm_and_takeoff(target_alt) 
    time.sleep(1)
    point1 = LocationGlobalRelative(target_lat, target_lon, target_alt)

    goto_location(point1)

    while not reached:
        time.sleep(1)

    Land()

    reached = 0

    while not releasePackage:
        time.sleep(1)

    time.sleep(5)
    arm_and_takeoff(target_alt) 
    goto_location(homeLocation)
    while not reached:
        time.sleep(1)
    Land()
    vehicle.close()

# Tread function for drone navigation
def main():

    global takeoffStatus, status, releasePackage

    while status:
        if takeoffStatus:
            print("In takeoffStatus")
            navigation()
            status = 0

# Tread function for API server
def apiserver():
    app.run(debug=False, port=8000, host='0.0.0.0')


if __name__ == '__main__':
    # Initialize the threads
    threadMain = threading.Thread(target=main)
    threadApi = threading.Thread(target=apiserver)

    # Start the threads
    threadMain.start()
    threadApi.start()

    # Waits and end the threads
    threadMain.join()
    threadApi.join()
    
    print("Done!")