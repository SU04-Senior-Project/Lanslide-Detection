# Lanslide-Detection
## Steps
##### Dataset: (https://drive.google.com/drive/folders/1O45vwQX1YfoF3KYBgeWwaph03P8vV9op?usp=sharing)
##### Join 3 images (rgb, ndvi, slope): genjoin_3.m
##### Faster RCNN ResNet 50 weights: (https://drive.google.com/file/d/1Liur-DE4LuU9JwQgXarGYsWf3l0freUF/view?usp=sharing)
##### Faster RCNN training code (use 3 joined images and ResNet50 weights to: landslide_faster_RCNN_5.m
##### Detection: loopdetectbox.m
##### bounding box selection for 2 boxes: bbox_selection_21.m
##### bounding box selection for 3 boxes: bbox_selection_final_31.m
##### score evaluation (accuracy, sensitivity, F-score, precision, recall, IOU): evaluate_score.m
