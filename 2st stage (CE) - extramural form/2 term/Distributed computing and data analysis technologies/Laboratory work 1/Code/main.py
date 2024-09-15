import argparse
import os
import shutil
from concurrent.futures.thread import ThreadPoolExecutor

import cv2
import numpy as np
import requests

VIDEO_FORMATS = ['.WEBM', '.MPG', '.MP2', '.MPEG', '.MPE', '.MPV', '.OGG', '.MP4', '.M4P', '.M4V',
                 '.AVI', '.WMV', '.MOV', '.QT', '.FLV', '.SWF', '.AVCHD']

WORKER_NODES = [
    "http://localhost:8080",
    "http://localhost:8081",
    "http://localhost:8082"
]


def get_videos_from_directory(video_directory_path: str):
    directory_video_files = []
    directories_to_process = [video_directory_path]

    while directories_to_process:
        current_directory = directories_to_process.pop(0)
        directory_entries = os.listdir(current_directory)

        for entry in directory_entries:
            full_entry_path = os.path.join(current_directory, entry)

            if os.path.isdir(full_entry_path):
                directories_to_process.append(full_entry_path)
            else:
                _, file_extension = os.path.splitext(full_entry_path)
                if file_extension.upper() in VIDEO_FORMATS:
                    directory_video_files.append(full_entry_path)

    return directory_video_files


def save_video_thumbnails(video_path: str, thumbnails: list[np.ndarray]):
    video_thumbnails_directory = os.path.join(
        os.path.dirname(video_path), "%s_thumbnails" % (os.path.splitext(os.path.basename(video_path))[0])
    )

    if os.path.exists(video_thumbnails_directory):
        shutil.rmtree(video_thumbnails_directory)

    os.mkdir(video_thumbnails_directory)

    for i, thumbnail in enumerate(thumbnails):
        cv2.imwrite('%s/%d_thumbnail.png' % (video_thumbnails_directory, i + 1), thumbnail)


def process_videos_parallel(videos: list[str], thumbnail_width: int, thumbnail_height: int, num_thumbnails: int):
    with ThreadPoolExecutor(max_workers=len(WORKER_NODES)) as executor:
        futures = []
        for video_path in videos:
            worker_url = WORKER_NODES[len(futures) % len(WORKER_NODES)]
            print(worker_url)

            futures.append(executor.submit(process_video, video_path, thumbnail_width, thumbnail_height, num_thumbnails, worker_url))

        for future in futures:
            future.result()


def process_video(video_path: str, thumbnail_width: int, thumbnail_height: int, num_thumbnails: int, worker_url: str):
    with open(video_path, 'rb') as file:
        files = {'video': file}
        params = {
            'thumbnail_width': thumbnail_width,
            'thumbnail_height': thumbnail_height,
            'num_thumbnails': num_thumbnails
        }

        response = requests.post(worker_url + '/process_video', files=files, data=params)
        response.raise_for_status()

        response_data = response.json()

        thumbnails_json = response_data['thumbnails']
        thumbnails = [np.array(thumbnail) for thumbnail in thumbnails_json]

        save_video_thumbnails(video_path, thumbnails)


def main():
    parser = argparse.ArgumentParser(description='Video thumbnails generator')
    parser.add_argument('-i', '--input_dir', type=str, nargs='+', required=True, help='Path to video directories')
    parser.add_argument('-ws', '--w_size', type=int, default=640, help='Thumbnail width size (pixels).')
    parser.add_argument('-hs', '--h_size', type=int, default=640, help='Thumbnail height size (pixels).')
    parser.add_argument('-q', '--quantity', type=int, default=5, help='Number of thumbnails for video')
    args = parser.parse_args()

    try:
        input_directories = args.input_dir
        thumbnail_width = args.w_size
        thumbnail_height = args.h_size
        num_thumbnails = args.quantity

        for video_directory_path in input_directories:
            directory_videos = get_videos_from_directory(video_directory_path)

            for i in range(0, len(directory_videos), len(WORKER_NODES)):
                group = directory_videos[i:i + len(WORKER_NODES)]
                process_videos_parallel(group, thumbnail_width, thumbnail_height, num_thumbnails)

        print("Thumbnails successfully generated.")
    except Exception as e:
        print("Oops! Something went wrong... :( \n{}".format(e))


if __name__ == '__main__':
    main()
