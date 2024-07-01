# Importing Libraries
import argparse
import imutils
import cv2 as cv
import paho.mqtt.client as mqtt
import base64
import time

CAMERA_ID                   = 0

parser = argparse.ArgumentParser(
    prog='mcapture',
    description='mqtt video capture example')
parser.add_argument('-e', '--connect', type=str, metavar='ENDPOINT', action='append',
                    help='mqtt broker to connect to.')
parser.add_argument('-w', '--width', type=int, default=500,
                    help='width of the published frames')
parser.add_argument('-d', '--delay', type=float, default=0.05,
                    help='delay between each frame in seconds')
parser.add_argument('-i', '--ping-topic', type=str, default='demo/mcam/ping',
                    help='topic to ping (publish)')

args = parser.parse_args()

# MQTT Broker
if args.connect is not None:
    MQTT_BROKER = args.connect
else:
    MQTT_BROKER = "127.0.0.1"
# Topic on which frame will be published
if args.ping_topic is not None:
    MQTT_SEND = args.ping_topic
# Phao-MQTT Clinet
client = mqtt.Client()
# Establishing Connection with the Broker
client.connect(MQTT_BROKER)

# Object to capture the frames
from imutils.video import VideoStream
vs = VideoStream(src=CAMERA_ID).start()

time.sleep(0.1)

while True:
    # Read Frame
    raw = vs.read()
    frame = imutils.resize(raw, width=args.width)
    # Encoding the Frame
    _, frame = cv.imencode('.jpg', frame)
    # Converting into encoded bytes
    jpg_as_text = base64.b64encode(frame)
    # Publishig the Frame on the Topic home/server
    client.publish(MQTT_SEND, jpg_as_text)

    time.sleep(args.delay)
