import cv2 as cv
import numpy as np
from imutils.video import VideoStream
import time
import sys
import os


def process(image):
    original_image = image.copy()

    height = image.shape[0]
    width = image.shape[1]

    top_left = [round(height * 0.2), round(width * 0.2)]
    bottom_right = [round(height * 0.8), round(width * 0.8)]

    gray_image = cv.cvtColor(image, cv.COLOR_RGB2GRAY)

    blur_image = cv.GaussianBlur(gray_image, (5, 5), 0)

    v = np.median(image)
    sigma = 0.33

    # Threshold values for canny detection
    lower = int(max(0, (1.0 - sigma) * v))
    upper = int(min(255, (1.0 + sigma) * v))

    canny_image = cv.Canny(blur_image, lower, upper)
    # canny_image = cv.Canny(blur_image, 100, 300)
    cv.imshow("Canny Image", canny_image)

    contours, hierarchy = cv.findContours(canny_image, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE)

    # Find the position (pixel) to the nearest contour from the bottom
    edge_pixels = []  # array to set detected pixels positions
    for r in range(0, width, 5):
        current_pixel = (r, 0)
        for c in range(height - 5, 0, -1):
            if canny_image.item(c, r) == 255:
                current_pixel = (r, c)
                break

        edge_pixels.append(current_pixel)  # insert all positions to array

    gray_image = cv.cvtColor(gray_image, cv.COLOR_GRAY2BGR)

    if len(contours) != 0:
        # c = max(contours, key=cv.contourArea)
        # x, y, w, h = cv.boundingRect(c)
        contour_image = cv.drawContours(gray_image, contours, contourIdx=-1, color=(0, 255, 0), thickness=-1)

        # Loop over the contours
        # for c in contours:
        #     M = cv.moments(c)

        #     if M["m00"] != 0:
        #         cX = int(M["m10"] / M["m00"])
        #         cY = int(M["m01"] / M["m00"])

        roi = blur_image[top_left[0]:bottom_right[0], top_left[1]:bottom_right[1]]  # selecting roi
        new_corners = cv.goodFeaturesToTrack(roi, 50, 0.01, 10)  # find corners

        new_corners[:, 0, 0] = new_corners[:, 0, 0] + top_left[1]
        new_corners[:, 0, 1] = new_corners[:, 0, 1] + top_left[0]

        contour_image = draw_rois(contour_image)

        return [contour_image, edge_pixels]

    else:
        print("No contours found")
        original_image = draw_rois(original_image)
        return [original_image, edge_pixels]


# Divide frame into a [3x3] grid
def draw_rois(frame):
    height = frame.shape[0]
    width = frame.shape[1]

    cv.line(frame, (0, round(height * 0.33)), (round(width), round(height * 0.33)), (255, 0, 0), 1)  # Horizontal line
    cv.line(frame, (0, round(height * 0.66)), (round(width), round(height * 0.66)), (255, 0, 0), 1)  # Horizontal line

    cv.line(frame, (round(width * 0.33), 0), (round(width * 0.33), height), (255, 0, 0), 1)  # Vertical line
    cv.line(frame, (round(width * 0.66), 0), (round(width * 0.66), height), (255, 0, 0), 1)  # Vertical line

    return frame  # Divided frame


# Run detection algorithm
def run_detection(frame, pixel_edges):
    is_text_visible = False

    height = frame.shape[0]
    width = frame.shape[1]

    # 3x3 blocks for detection
    roi_blocks = [
        # Row 1
        [
            [[0, 0], [width * 0.33, height * 0.33]],
            [[width * 0.33, 0], [width * 0.66, height * 0.33]],
            [[width * 0.66, 0], [width, height * 0.33]]
        ],
        # Row 2
        [
            [[0, height * 0.33], [width * 0.33, height * 0.66]],
            [[width * 0.33, height * 0.33], [width * 0.66, height * 0.66]],
            [[width * 0.66, height * 0.33], [width, height * 0.66]]
        ],
        # Row 3
        [
            [[0, height * 0.66], [width * 0.33, height]],
            [[width * 0.33, height * 0.66], [width * 0.66, height]],
            [[width * 0.66, height * 0.66], [width, height]]
        ],
    ]

    checks = [[0 for i in range(3)] for j in range(3)]  # Create a new 3x3 array representing the blocks check counter

    # Add detection count for each block
    for row in range(0, 3):
        for col in range(0, 3):
            for edge in pixel_edges:
                if not edge[1] == 0:

                    # Draw red lines to each point
                    cv.line(frame, (edge[0], height), (edge[0], edge[1]), (0, 0, 255), 1)

                    # Increment check counter based on detected points
                    if edge[1] < calc_avg(roi_blocks[row][col][0][1], roi_blocks[row][col][1][1]):
                        checks[row][col] = checks[row][col] + 1

    print(checks)

    # Draw a rectangle in each free block based on ckeck counter
    for row in range(0, 3):
        for col in range(0, 3):
            if checks[row][col] < 5:
                cv.rectangle(frame, (round(roi_blocks[row][col][0][0] + 20), round(roi_blocks[row][col][0][1] + 20)),
                             (round(roi_blocks[row][col][1][0] - 20), round(roi_blocks[row][col][1][1] - 20)),
                             (255, 255, 255), 3)
    # print(roi_blocks)

    # Histogram like line
    for edge in range(len(pixel_edges) - 1):
        if not (pixel_edges[edge][1] == 0 or pixel_edges[edge + 1][1] == 0):
            cv.line(frame, pixel_edges[edge], pixel_edges[edge + 1], (255, 255, 0), 1)

    if is_text_visible:
        show_text("Set command", frame)


def calc_avg(num1, num2):
    return (num1 + num2) / 2


def show_text(text, frame):
    font = cv.FONT_HERSHEY_SIMPLEX

    # Get boundary for the text
    text_size = cv.getTextSize(text, font, 1, 2)[0]

    # Get text coordinates
    text_x = (frame.shape[1] - text_size[0]) / 2
    text_y = (frame.shape[0] + text_size[1]) / 2

    # Add text centered on image
    cv.putText(frame, text, (round(text_x), round(text_y)), font, 1, (221, 0, 255), 2)


# Main function that runs the script
def main(input_type, input_filename):
    # Variables used in the script
    detections_dir = './assets/detections'
    show_frame = True
    write_original = True
    write_detection = True
    is_flipped = True

    # Create the detections directory if not exists
    if not os.path.isdir(detections_dir):
        os.mkdir(detections_dir)

    # Selection for web cam input
    if input_type == "cam":

        # Capture variables and properties for webcam
        width = 640
        height = 480
        capture = cv.VideoCapture(0, cv.CAP_DSHOW)
        capture.set(3, width)  # 3 - PROPERTY index for WIDTH
        capture.set(4, height)  # 4 - PROPERTY index for HEIGHT
        print("Web cam started..")

        # Declare properties required for writing the detections
        if write_detection:
            fourcc = cv.VideoWriter_fourcc(*'MP4V')
            FPS = 20
            out = cv.VideoWriter(detections_dir + '/detection_' + str(time.time()) + '.mp4', fourcc, FPS, (640, 480))

        # Declare properties required for writing the original capture
        if write_original:
            fourcc = cv.VideoWriter_fourcc(*'MP4V')
            FPS = 20
            out_original = cv.VideoWriter(detections_dir + '/original_' + str(time.time()) + '.mp4', fourcc, FPS,
                                          (width, height))

        try:
            # Loop to read each frame
            while True:

                _, frame = capture.read()

                if write_original:
                    out_original.write(frame)  # Write each original frame

                frame = process(frame)  # Process each original frame
                run_detection(frame[0], frame[1])  # Run detection function for each frame

                if write_detection:
                    out.write(frame[0])  # Write each detection frame

                if show_frame:
                    cv.imshow('Video', frame[0])  # Write each detection frame

                if cv.waitKey(40) == 27:  # Loop breaks for Esc key
                    break

        finally:
            cv.destroyAllWindows()
            capture.release()

            if write_detection:
                out.release()

            if write_original:
                out_original.release()

            print('Webcam stopped')

    # Selection for Pi cam input
    elif input_type == "picam":

        usingPiCamera = True

        # Set initial frame size.
        width = 640
        height = 480
        frameSize = (width, height)

        # Initialize the video stream.
        FPS = 32
        capture = VideoStream(src=0, usePiCamera=usingPiCamera, resolution=frameSize, framerate=FPS).start()
        fourcc = cv.VideoWriter_fourcc(*'FMP4')
        print("Picam started..")

        if write_detection:
            FPS = 24
            out = cv.VideoWriter(detections_dir + '/detection_' + str(time.time()) + '.mp4', fourcc, FPS, (640, 480))

        if write_original:
            out_original = cv.VideoWriter(detections_dir + '/original_' + str(time.time()) + '.mp4', fourcc, FPS,
                                          (width, height))

        # Camera warming up
        time.sleep(1.0)

        try:
            while True:

                frame = capture.read()

                if is_flipped:
                    frame = cv.flip(frame, flipCode=-1)

                if write_original:
                    out_original.write(frame)

                frame = process(frame)
                run_detection(frame[0], frame[1])

                if write_detection:
                    out.write(frame[0])

                if show_frame:
                    cv.imshow('Video', frame[0])

                if cv.waitKey(40) == 27:
                    break

        finally:
            cv.destroyAllWindows()
            capture.stop()

            if write_detection:
                out.release()

            if write_original:
                out_original.release()

            print('Picam stopped')

    # Selection for video input from disk
    elif input_type == "video":
        input_path = "./assets/videos/" + input_filename[0]

        capture = cv.VideoCapture(input_path)
        capture.set(3, 1280)  # 3 - PROPERTY index for WIDTH
        capture.set(4, 720)  # 4 - PROPERTY index for HEIGHT
        print("Video started..")

        FPS = capture.get(cv.CAP_PROP_FPS)
        print(FPS, "->", round(FPS))

        if write_detection:
            fourcc = cv.VideoWriter_fourcc(*'MP4V')
            out = cv.VideoWriter(detections_dir + '/detection_' + str(time.time()) + '.mp4', fourcc, 20, (640, 480))

        try:
            while True:

                ret, frame = capture.read()
                if not ret:
                    break

                frame = process(frame)
                run_detection(frame[0], frame[1])

                if write_detection:
                    out.write(frame[0])

                if show_frame:
                    cv.imshow('Video', frame[0])

                key = cv.waitKey(round(FPS)) & 0xFF

                if key == 27:
                    break

        finally:
            cv.destroyAllWindows()
            capture.release()
            if write_detection:
                out.release()
            print('Video stopped')

    # Selection for image input from disk
    elif input_type == "image":
        input_path = "./assets/images/" + input_filename[0]

        image = cv.imread(input_path)
        print("Image reading..")

        frame = process(image)
        run_detection(frame[0], frame[1])

        if write_detection:
            cv.imwrite(detections_dir + '/detection_' + str(time.time()) + '.jpg', frame[0])

        if show_frame:
            cv.imshow('Image', frame[0])

        if cv.waitKey(0) & 0xFF:
            cv.destroyAllWindows()
            print("Image stopped")

    # Error message for invalid arguments
    else:
        raise ValueError("Invalid input argument. Please choose 'picam' 'cam', 'image' or 'video'")


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2:])
# # main('cam', None)
