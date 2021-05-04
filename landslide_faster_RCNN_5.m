clc
clear
close all


load('net50.mat','lgraph') %lgraph
load('ImageSource_700.mat','ImageSource_700') %gTruth.LabelData
load('labeled_700.mat','labeled_700') %gTruth.LabelData

% load('imageSource_final_700.mat','imageSource_final')
% load('labeled_final_700.mat')

% labeled_final_700.Properties.VariableNames{'Var1'} = 'landslide';

imds = imageDatastore(ImageSource_700);


blds = boxLabelDatastore(labeled_700);
ds = combine(imds, blds);

options = trainingOptions('sgdm', ...
      'MiniBatchSize', 1, ...
      'InitialLearnRate', 1e-3, ...
      'MaxEpochs', 7, ...
      'VerboseFrequency', 200);

detector = trainFasterRCNNObjectDetector(ds, lgraph, options);
    
% img = imread('uu.jpg');
% [bbox, score, label] = detect(detector,img);
% detectedImg = insertShape(img,'Rectangle',bbox);
% figure
% imshow(detectedImg)
save('detector_rgb')


