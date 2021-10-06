import calendar
import os
import time
from pathlib import Path

import cv2

from config import DATASET_TRAIN_PATH

classifier = cv2.CascadeClassifier('recognizer/haarcascade_frontalface_default.xml')


def collect_images(user_id, video_path):
    cap = cv2.VideoCapture(video_path)
    count = 0
    path = DATASET_TRAIN_PATH + user_id + "/"
    Path(path).mkdir(parents=True, exist_ok=True)
    while cap.isOpened():
        ret, frame = cap.read()
        frame = cv2.rotate(frame, cv2.ROTATE_90_COUNTERCLOCKWISE)
        if extract_face(frame) is not None:
            count += 1
            face = cv2.resize(extract_face(frame), (400, 400))
            file_name = path + str(calendar.timegm(time.gmtime())) + "-" + str(count) + '.jpg'
            print("Saved: ", file_name)
            cv2.imwrite(file_name, face)
            if count == 100:
                break
        else:
            print("Not found")
            pass
    return count


def extract_face(image):
    faces = classifier.detectMultiScale(image, scaleFactor=1.32, minNeighbors=5)
    if faces is None:
        return None


    cropped_face = None
    # crop the faces
    for (x, y, w, h) in faces:
        x = x - 10
        y = y - 10
        cropped_face = image[y:y + h + 50, x:x + w + 50]
    return cropped_face
