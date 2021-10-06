import calendar
import os
import time

from PIL import Image
from keras.applications.vgg16 import preprocess_input
import base64
from io import BytesIO
import json
import random
import cv2
from keras.models import load_model
import numpy as np

from config import MODEL_PATH, VIDEO_UPLOADS, DATASET_TRAIN_PATH
from recognizer.collect_images import extract_face


def list_paths(path):
    directories = [x[1] for x in os.walk(path)]
    non_empty_dirs = [x for x in directories if x]  # filter out empty lists
    return [item for sub_item in non_empty_dirs for item in sub_item]  # flatten the list


def recognizer(frame):
    face = extract_face(frame)
    model = load_model(MODEL_PATH + "model.h5")
    if type(face) is np.ndarray:
        face = cv2.resize(face, (224, 224))
        im = Image.fromarray(face, 'RGB')
        # Resizing into 128x128 because we trained the model with this image size.
        img_array = np.array(im)
        # changing dimension 128x128x3 into 1x128x128x3
        img_array = np.expand_dims(img_array, axis=0)
        pred = model.predict(img_array)
        index = 0
        for temp in pred[0]:
            if pred[0][index] > 0.5:
                name = list_paths(DATASET_TRAIN_PATH)[index]
                return name
            index = index + 1
        return None


def facial_recognize(path, user_id):
    # video_capture = cv2.VideoCapture(VIDEO_UPLOADS +"/" + video_name)
    image = cv2.imread(path)
    rotated = cv2.rotate(image, cv2.ROTATE_90_COUNTERCLOCKWISE)
    result = recognizer(rotated)
    if os.path.exists(path):
        os.remove(path)
    if result == user_id and result is not None:
        return True
    return False
    # while video_capture.isOpened():
    #     _, frame = video_capture.read()
    #     result = recognizer(frame)
    #     cv2.putText(frame, result, (50, 50), cv2.FONT_HERSHEY_COMPLEX, 1, (0, 255, 0), 2)
    #     if result == user_id and result is not None:
    #         return True
    #     cv2.imshow('Video', frame)
    #     if cv2.waitKey(1) & 0xFF == ord('q'):
    #         break
    # video_capture.release()
    # cv2.destroyAllWindows()
    # return False
