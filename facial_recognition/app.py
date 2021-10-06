import calendar
import os
import random
import time

from flask import Flask, request, flash, redirect, url_for, jsonify

from config import VIDEO_UPLOADS, IMAGE_UPLOADS
from recognizer.collect_images import collect_images
from recognizer.facial_recognizer import facial_recognize
from recognizer.train import train

app = Flask(__name__)
DATASET_TRAIN = ''
app.config['VIDEO_UPLOADS'] = VIDEO_UPLOADS
app.config['IMAGE_UPLOADS'] = IMAGE_UPLOADS


@app.route("/")
def hello():
    return "Hello World!"

# upload video
@app.route('/videos', methods=['POST', 'DELETE'])
def upload_file():
    if request.method == 'POST':
        if request.files:
            video = request.files["video"]
            random_name = str(random.randint(100000, 100000000)) + str(calendar.timegm(time.gmtime()))
            extension = video.filename.rsplit(".")[-1]
            name = random_name + "." + extension
            upload_path = os.path.join(app.config["VIDEO_UPLOADS"], name)
            video.save(upload_path)
            return jsonify(
                success=1,
                message="Successfully uploaded",
                name=name
            ), 201
        else:
            return jsonify(
                error='You must need to provide a video',
                success=0
            ), 422
    if request.method == 'DELETE':
        if 'name' in request.form:
            name = request.form['name'].strip()
            if name is None or name == '':
                return jsonify(
                    error='You must need to provide a video name',
                    success=0
                ), 422
            else:
                #         delete file
                path = VIDEO_UPLOADS + "/" + name
                print(path)
                if os.path.exists(path):
                    os.remove(path)
                    return jsonify(
                        message='Successfully deleted',
                        success=1
                    ), 200
                else:
                    return jsonify(
                        error='Video Not found',
                        success=0
                    ), 422

        else:
            return jsonify(
                error='You must need to provide a video name',
                success=0
            ), 422

# collect immages from uploaded vidoe
@app.route('/collect_images', methods=['POST'])
def capture_images():
    if request.method == 'POST':
        if 'video_name' in request.form and 'id' in request.form:
            video_name = request.form['video_name'].strip()
            id = request.form['id'].strip()
            if (video_name is None or video_name == '') and (id is None or id == ''):

                return jsonify(
                    error='You must need to provide a video name and user id',
                    success=0
                ), 422
            else:
                path = VIDEO_UPLOADS + "/" + video_name
                if os.path.exists(path):
                    image_count = collect_images(id, path)
                    # call a function
                    return jsonify(
                        message="{} image(s) successfully Collected".format(image_count),
                        success=1
                    ), 200
                else:
                    return jsonify(
                        error='Video Not found',
                        success=0
                    ), 422

        else:
            return jsonify(
                error='You must need to provide a video name and user id',
                success=0
            ), 422

# train the model
@app.route('/train_model', methods=['POST'])
def train_model():
    if request.method == 'POST':
        if 'id' in request.form:
            id = request.form['id'].strip()
            if id is None or id == '':

                return jsonify(
                    error='You must need to provide a user id',
                    success=0
                ), 422
            else:
                time_taken = train(id)
                return jsonify(
                    message="Successfully trained",
                    time_taken=time_taken,
                    success=1
                ), 200
        else:
            return jsonify(
                error='You must need to provide a user id',
                success=0
            ), 422

#recognize the face
@app.route('/recognize', methods=['POST'])
def recognize_face():
    if request.method == 'POST':
        if 'id' in request.form:
            id = request.form['id'].strip()
            if request.files and (id is None or id == ''):

                return jsonify(
                    error='You must need to provide a image and user id',
                    success=0
                ), 422
            else:
                image = request.files["image"]
                random_name = str(random.randint(100000, 100000000)) + str(calendar.timegm(time.gmtime()))
                extension = image.filename.rsplit(".")[-1]
                name = random_name + "." + extension
                upload_path = os.path.join(app.config["IMAGE_UPLOADS"], name)
                image.save(upload_path)
                result = facial_recognize(upload_path,id)
                if result:
                    return jsonify(
                        message="validated",
                        success=1
                    ), 200
                else:
                    return jsonify(
                        message="can not identify the person",
                        success=0
                    ), 401
        else:
            return jsonify(
                error='You must need to provide a video name and user id',
                success=0
            ), 422


if __name__ == "__main__":
    # app.run()
    app.run(host='192.168.8.107')
