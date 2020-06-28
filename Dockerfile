# Define base images
ARG app_image="ultralytics/yolov3:v0"

# App image:
FROM ${app_image}

WORKDIR /usr/src/app

# Install api requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Get weights
RUN wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v3_optimal/yolov4.weights

# Convert to Pytorch
RUN python3  -c "from models import *;convert('cfg/yolov4.cfg', 'yolov4.weights');"; mv yolov4.pt ./weights/;


# Model to use (defaults to yolov5):
ARG weights_file="weights/yolov4.pt"
ARG config_file="cfg/yolov4.cfg"
ARG meta_file="cfg/coco.data"
ARG img_size=640

ENV weights_file=${weights_file}
ENV config_file=${config_file}
ENV meta_file=${meta_file}
ENV img_size=${img_size}
ENV optimized_memory=${optimized_memory}
ENV augment=False
ENV agnostic_nms=False
ENV device=
ENV half=False
ENV iou_thres=0.5
ENV classify=False


COPY app.py .
COPY swagger.yaml .

CMD ["python3", "app.py"]