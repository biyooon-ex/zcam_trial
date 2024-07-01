import argparse
import base64
import cv2 as cv
import numpy as np
import paho.mqtt.client as mqtt

parser = argparse.ArgumentParser(
    prog='mdisplay',
    description='mqtt video display example')
parser.add_argument('-e', '--connect', type=str, metavar='ENDPOINT', action='append',
                    help='mqtt broker to listen on.')
parser.add_argument('-o', '--pong-topic', type=str, default='demo/mcam/pong',
                    help='topic to pong (subscribe)')

args = parser.parse_args()

# MQTT Broker
if args.connect is not None:
    MQTT_BROKER = args.connect[0]
else:
    MQTT_BROKER = "127.0.0.1"
# Topic on which frame will be published
if args.pong_topic is not None:
    MQTT_RECEIVE = args.pong_topic

frame = np.zeros((240, 320, 3), np.uint8)


# The callback for when the client receives a CONNACK response from the server.
def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))

    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe(MQTT_RECEIVE)

# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, msg):
    global frame
    # Decoding the message
    img = base64.b64decode(msg.payload)
    # converting into numpy array from buffer
    npimg = np.frombuffer(img, dtype=np.uint8)
    # Decode to Original Frame
    frame = cv.imdecode(npimg, 1)


client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect(MQTT_BROKER)

# Starting thread which will receive the frames
client.loop_start()

while True:
    cv.imshow("Stream", frame)
    if cv.waitKey(1) & 0xFF == ord('q'):
        break

# Stop the Thread
client.loop_stop()
