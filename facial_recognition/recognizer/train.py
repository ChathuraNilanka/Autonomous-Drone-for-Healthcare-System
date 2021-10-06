import datetime
import shutil

from keras.layers import Input, Lambda, Dense, Flatten
from keras.models import Model
from keras.applications.vgg16 import VGG16
from glob import glob
import matplotlib.pyplot as plt
from keras.preprocessing.image import ImageDataGenerator

from config import DATASET_TRAIN_PATH, DATASET_TEST_PATH, GRAPH_PATH, MODEL_PATH

IMAGE_SIZE = [224, 224]


def train(user_id):
    start_at = datetime.datetime.now().timestamp() * 1000
    print("started", start_at)
    # add a pre proccessing layer to the VGG
    vgg = VGG16(input_shape=IMAGE_SIZE + [3], weights='imagenet', include_top=False)
    data_set_path = DATASET_TRAIN_PATH
    data_set_test_path = DATASET_TEST_PATH
    # skip the existing weights
    for layer in vgg.layers:
        layer.trainable = False

    folders = glob(data_set_path)
    temp = Flatten()(vgg.output)

    # temp = Dense(1000, activation='relu')(temp)
    prediction = Dense(len(folders), activation='softmax')(temp)

    model = Model(inputs=vgg.input, outputs=prediction)
    model.summary()
    model.compile(
        loss='categorical_crossentropy',
        optimizer='adam',
        metrics=['accuracy']
    )

    train_data_generator = ImageDataGenerator(rescale=1. / 255,
                                              shear_range=0.2,
                                              zoom_range=0.2,
                                              horizontal_flip=True)
    test_data_generator = ImageDataGenerator(rescale=1. / 255)

    training_data_set = train_data_generator.flow_from_directory(
        data_set_path,
        target_size=(224, 224),
        batch_size=32,
        class_mode='categorical',
    )

    test_data_set = test_data_generator.flow_from_directory(
        data_set_test_path,
        target_size=(224, 224),
        batch_size=32,
        class_mode='categorical'
    )
    fitted_model = model.fit(
            training_data_set,
            validation_data=test_data_set,
            epochs=5,
            steps_per_epoch=len(training_data_set),
            validation_steps=len(test_data_set))
    plt.plot(fitted_model.history['loss'], label='train loss')
    plt.plot(fitted_model.history['accuracy'], label='Accuracy')
    plt.legend()
    now = datetime.datetime.now()
    graph_path = GRAPH_PATH + str(now) + ".png"
    plt.savefig(graph_path)
    model_path = MODEL_PATH + str(now) + ".h5"
    model.save(model_path)

    shutil.copyfile(model_path, MODEL_PATH + "model.h5")
    end_at = datetime.datetime.now().timestamp() * 1000
    print("ended", end_at)
    return end_at - start_at


