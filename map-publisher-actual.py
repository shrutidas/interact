import paho.mqtt.client as mqtt
import MPR121
from gpiozero import RGBLED
import subprocess
import pygame
from pygame.mixer import Sound
from glob import glob
from time import sleep
# This is the Publisher

client = mqtt.Client()
client.connect("adapi",1883,60)
client.publish("topic/test", "Hello world!");
#client.disconnect();

sensor = MPR121.begin()
sensor.set_touch_threshold(40)
sensor.set_release_threshold(20)

led = RGBLED(6, 5, 26, active_high=False)

num_electrodes = 12

"""
# convert mp3s to wavs with picap-samples-to-wav
led.blue = 1
subprocess.call("picap-samples-to-wav tracks", shell=True)
led.off()
"""

# initialize mixer and pygame
pygame.mixer.pre_init(frequency=44100, channels=64, buffer=1024)
pygame.init()

def send_message_when_touched():
    if sensor.touch_status_changed():
        sensor.update_touch_data()
        
        is_any_touch_registered = False
        
        for i in range(num_electrodes):
            if sensor.get_touch_data(i):
                # check if touch is registered to set the led status
                is_any_touch_registered = True
            if sensor.is_new_touch(i):
                # play sound associated with that touch
                #print ("playing sound: " + str(i))
                if i == 0:
                    location = "North America"
                    led.blue = 1
                elif i == 2:
                    location = "Oceania"
                elif i == 3:
                    location = "South America"
                elif i == 5:
                    location = "Asia"
                elif i == 7:
                    location = "Africa"
                elif i == 9:
                    location = "Middle East"
                elif i == 11:
                    location = "Europe"
                else:
                    print("*** UNKONWN PRESS ***")
                    location = "Parts Unknown"
                print(location)
                client.publish("topic/test", location)

    
#        if is_any_touch_registered:
#            led.red = 1
#        else:
#            led.off()

running = True
while running:
    try:
        send_message_when_touched()
    except KeyboardInterrupt:
        led.off()
        running = False
    sleep(0.01)
