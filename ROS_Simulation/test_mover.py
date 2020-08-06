#!/usr/bin/env python

#ros imports
import rospy
import math
from geometry_msgs.msg import Twist
from rospy.core import is_shutdown

#websoket imports
from websocket import create_connection
import json

PI = 3.14159265

def robotController():
    rospy.init_node('test_mover', anonymous=True)
    pubToTopic = rospy.Publisher("p3dx/cmd_vel", Twist, queue_size=10)
    vel_msg = Twist()

    #inputs, controller values, consts
    speed = 0.5
    angle = 20

    #conversion to degrees from radian 
    angular_speed = angle * PI/180 

    print("Move Joystick, to control the Robot.")
    print("Conncecting to server...")
    ws = create_connection("")
    print("Conncection established.")

    while not is_shutdown():

        print("Receiving...")

        while True:
            
            msgReceived =  ws.recv()
            print("Received '%s'" % msgReceived)
            stringToJson = json.loads(msgReceived)
            direction = stringToJson['direction']
            robotID = stringToJson['robotID']

            #Initial value is none.
            print('INITIAL')
            vel_msg.angular.z = 0
            vel_msg.linear.x = 0
            pubToTopic.publish(vel_msg)
            
            if(robotID == 'kakaroto'):

                if((direction == 'UP' or direction == 'up') ):
                    vel_msg.linear.x = abs(speed)
                    vel_msg.angular.z = 0
                    print("Going forward, current speed :" ,speed)

                elif((direction == 'UP RIGHT' or direction == 'up right') ):
                    vel_msg.linear.x = abs(speed)
                    vel_msg.angular.z = abs(angular_speed)
                    pubToTopic.publish(vel_msg)
                    print("Going UP-RIGHT, current speed :" ,speed)                
                
                elif((direction == 'RIGHT' or direction == 'right') ):
                    vel_msg.linear.x = 0
                    vel_msg.angular.z = abs(angular_speed)
                    print("Turning right")

                elif((direction == 'DOWN RIGHT' or direction == 'down right') ):
                    vel_msg.linear.x = -abs(speed)
                    vel_msg.angular.z = -abs(angular_speed)
                    print("Going DOWN-RIGHT, current speed :" ,speed)

                elif((direction == 'DOWN' or direction == 'down') ):
                    vel_msg.linear.x = -abs(speed)
                    vel_msg.angular.z = 0
                    print("Going backwards, current speed :" ,speed)

                elif((direction == 'DOWN LEFT' or direction == 'down left') ):
                    vel_msg.linear.x = -abs(speed)
                    vel_msg.angular.z = abs(angular_speed)
                    print("Going DOWN-LEFT, current speed :" ,speed)                

                elif((direction == 'LEFT' or direction == 'left') ):
                    vel_msg.linear.x = 0
                    vel_msg.angular.z = -abs(angular_speed)
                    print("Turning left")

                elif((direction == 'UP LEFT' or direction == 'up left') ):
                    vel_msg.linear.x = abs(speed)
                    vel_msg.angular.z = -abs(angular_speed)
                    print("Going UP-LEFT, current speed :" ,speed)
                
                elif((direction == 'STOPPED' or direction == 'stopped') ):
                    vel_msg.linear.x = 0
                    vel_msg.angular.z = 0
                    print("Stopped")
            
                #Publishing velocities (vel_msg) to Topic
                pubToTopic.publish(vel_msg)

            #Stop robot if we receive no direction or another user wants to take control.
            else: 
                vel_msg.angular.z = 0
                vel_msg.linear.x = 0
                print("robotID not corresponding, stopping robot.")  

        
        #To stop the robot when CTRL+C is perfomrmed
        print("CTRL+C to go back to terminal.")
        rospy.spin()       
        ws.close()

if __name__ == '__main__':
    try:

        robotController()

    except rospy.ROSInterruptException: pass        