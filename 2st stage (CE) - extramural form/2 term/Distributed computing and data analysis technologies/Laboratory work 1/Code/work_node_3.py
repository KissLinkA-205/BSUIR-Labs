import os
import tempfile

from flask import Flask, request, jsonify

from video_thumbnails_generator import VideoThumbnailsGenerator

app = Flask(__name__)


@app.route('/process_video', methods=['POST'])
def process_video():
    video_file = request.files['video']
    thumbnail_width = int(request.form['thumbnail_width'])
    thumbnail_height = int(request.form['thumbnail_height'])
    num_thumbnails = int(request.form['num_thumbnails'])

    with tempfile.TemporaryDirectory() as temp_dir:
        try:
            video_path = os.path.join(temp_dir, video_file.filename)
            video_file.save(video_path)

            generator = VideoThumbnailsGenerator(video_path, thumbnail_width, thumbnail_height, num_thumbnails)
            generated_thumbnails = generator.generate()

            thumbnails_data = [thumbnail.tolist() for thumbnail in generated_thumbnails]
            return jsonify({'thumbnails': thumbnails_data})
        except Exception as e:
            print(e)
            return 'ISomething went wrong... {}'.format(e), 500


if __name__ == '__main__':
    app.run(debug=True, port=8082)
