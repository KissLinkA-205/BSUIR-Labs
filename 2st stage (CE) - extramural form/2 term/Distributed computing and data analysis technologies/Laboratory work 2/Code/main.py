import argparse
import os
import time

import cv2
import numpy as np


def load_yolo_model(yolo_model_path):
    yolo_labels_path = os.path.sep.join([yolo_model_path, "coco.names"])
    yolo_labels = open(yolo_labels_path).read().strip().split("\n")

    np.random.seed(42)
    colors = np.random.randint(0, 255, size=(len(yolo_labels), 3), dtype="uint8")

    yolo_weights_path = os.path.sep.join([yolo_model_path, "yolov3.weights"])
    yolo_config_path = os.path.sep.join([yolo_model_path, "yolov3.cfg"])

    print("[INFO] loading YOLO from disk...")
    net = cv2.dnn.readNetFromDarknet(yolo_config_path, yolo_weights_path)

    return net, yolo_labels, colors


def detect_objects(image, net, min_confidence, nms_threshold):
    (H, W) = image.shape[:2]

    ln = net.getLayerNames()
    ln = [ln[i - 1] for i in net.getUnconnectedOutLayers()]

    blob = cv2.dnn.blobFromImage(image, 1 / 255.0, (416, 416), swapRB=True, crop=False)
    net.setInput(blob)
    start = time.time()
    layer_outputs = net.forward(ln)
    end = time.time()

    print("[INFO] YOLO took {:.6f} seconds".format(end - start))

    boxes = []
    confidences = []
    class_ids = []

    for output in layer_outputs:
        for detection in output:
            scores = detection[5:]
            class_id = np.argmax(scores)
            confidence = scores[class_id]
            if confidence > min_confidence:
                box = detection[0:4] * np.array([W, H, W, H])
                (centerX, centerY, width, height) = box.astype("int")
                x = int(centerX - (width / 2))
                y = int(centerY - (height / 2))
                boxes.append([x, y, int(width), int(height)])
                confidences.append(float(confidence))
                class_ids.append(class_id)

    idxs = cv2.dnn.NMSBoxes(boxes, confidences, min_confidence, nms_threshold)

    return idxs, boxes, confidences, class_ids


def display_result_image(image, idxs, boxes, confidences, class_ids, labels, colors):
    if len(idxs) > 0:
        for i in idxs.flatten():
            (x, y, w, h) = boxes[i]
            color = [int(c) for c in colors[class_ids[i]]]
            cv2.rectangle(image, (x, y), (x + w, y + h), color, 2)
            text = "{}: {:.4f}".format(labels[class_ids[i]], confidences[i])
            cv2.putText(image, text, (x, y - 5), cv2.FONT_HERSHEY_SIMPLEX,0.5, color, 2)
    cv2.imshow("Image objects identification results", image)
    cv2.waitKey(0)


def create_result_txt(idxs, boxes, confidences, class_ids, labels, output_file):
    with open(output_file, 'w') as f:
        if len(idxs) > 0:
            for i in idxs.flatten():
                (x, y, w, h) = boxes[i]
                object_label = labels[class_ids[i]]
                object_confidence = confidences[i]
                text = f"Object: {object_label}, Confidence: {object_confidence:.4f}, Bounding Box: (x={x}, y={y}, w={w}, h={h})\n"
                f.write(text)


def main():
    parser = argparse.ArgumentParser(description='Image objects identifier')
    parser.add_argument('-i', '--image', type=str, required=True, help='Path to input image')
    parser.add_argument('-y', '--yolo', type=str, required=True, help='Path to directory with YOLO model')
    parser.add_argument('-c', '--confidence', type=float, default=0.5, help='Minimum probability to filter weak detections')
    parser.add_argument('-t', '--threshold', type=float, default=0.3, help='Threshold when applying non-maxima suppression')
    parser.add_argument('-o', '--output', type=str, default='result.txt', help='Path to output text file')
    args = parser.parse_args()

    net, LABELS, COLORS = load_yolo_model(args.yolo)
    image = cv2.imread(args.image)

    idxs, boxes, confidences, classIDs = detect_objects(image, net, args.confidence, args.threshold)

    create_result_txt(idxs, boxes, confidences, classIDs, LABELS, args.output)
    display_result_image(image, idxs, boxes, confidences, classIDs, LABELS, COLORS)


if __name__ == '__main__':
    main()
