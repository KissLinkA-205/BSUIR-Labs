import random

import cv2
import numpy as np


class VideoThumbnailsGenerator:
    VIDEO_FORMATS = ['.WEBM', '.MPG', '.MP2', '.MPEG', '.MPE', '.MPV', '.OGG', '.MP4', '.M4P', '.M4V',
                     '.AVI', '.WMV', '.MOV', '.QT', '.FLV', '.SWF', '.AVCHD']

    def __init__(self, video_path: str, thumbnail_width=640, thumbnail_height=640, num_thumbnails=5):
        self.video_path = video_path
        self.thumbnail_width = thumbnail_width
        self.thumbnail_height = thumbnail_height
        self.num_thumbnails = num_thumbnails

    def generate(self):
        video_frames_number = self.get_video_frames_number(self.video_path)
        video_thumbnails_frames_indexes = self.select_random_video_frames(video_frames_number)
        video_thumbnails_frames = self.get_frames_from_video(self.video_path, video_thumbnails_frames_indexes)

        return self.convert_frames_to_thumbnails(video_thumbnails_frames)

    def select_random_video_frames(self, video_frames_number: int):
        frames_number_to_select = self.num_thumbnails

        if frames_number_to_select >= video_frames_number:
            frames_number_to_select = video_frames_number

        return random.sample(range(video_frames_number), frames_number_to_select)

    def convert_frames_to_thumbnails(self, frames: list[np.ndarray]):
        thumbnails = []
        for frame in frames:
            frame_hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
            thumbnail = cv2.resize(frame_hsv, (self.thumbnail_width, self.thumbnail_height))
            result_thumbnail = cv2.cvtColor(thumbnail, cv2.COLOR_HSV2BGR)

            thumbnails.append(np.array(result_thumbnail))

        return thumbnails

    @staticmethod
    def get_frames_from_video(video_path: str, frame_indexes: list[int]):
        cap = cv2.VideoCapture(video_path)
        if not cap.isOpened():
            raise ValueError("Unable to open video file '{}'".format(video_path))

        frames = []
        for index in frame_indexes:
            cap.set(cv2.CAP_PROP_POS_FRAMES, index)

            ret, frame = cap.read()
            if not ret:
                raise ValueError("Failed to read frame from video file '{}'".format(video_path))

            frames.append(frame)

        cap.release()

        return frames

    @staticmethod
    def get_video_frames_number(video_path: str):
        cap = cv2.VideoCapture(video_path)
        if not cap.isOpened():
            raise ValueError("Unable to open video file '{}'".format(video_path))

        video_frames_number = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))

        cap.release()
        return video_frames_number
