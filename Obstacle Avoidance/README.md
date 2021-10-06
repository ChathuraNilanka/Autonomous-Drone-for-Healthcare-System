# 2020-037

## Introduction

This project is created to maintain the Research Project work done by the members of group 2020-037 under the title **E-Medic - Autonomous Drone for Healthcare System** which is an online platform to deliver medicine via an autonomous drone.



## Main objective

- Avoid obstacles using a camera



## Individual Research Questions

-   How does the drone manage to avoid obstacles in flight?



## Individual Objectives

-   Detect obstacles and alter the flight path for a successful flight.



## Install Dependencies

```python
pip install -r requirements.txt
```



## How to Run

The Python script can be executed for Videos, Images, PC Webcam and PiCamera. Videos and images must be added into `assets/videos` and `assets/images` respectively.

Run using existing files in `assets/` folder.

- **Videos** 

```python
python detect.py video city_ariel.mp4
```

- **Images**

```python
python detect.py image sliit.png
```

- **Webcam**

```python
python detect.py cam
```

- **PiCamera**

```python
python detect.py picam
```
