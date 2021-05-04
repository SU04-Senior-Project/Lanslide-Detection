clc
clear
close all

load('imageSource_final.mat')
load('labeled_rgb_ndvi_blue.mat')
load('detector_final.mat','detector')
load('imageSource.mat','imageSource_rgb')

t=1;
for i = 1:length(imageSource_rgb)
    path_rgb = imageSource_rgb{i};
    img_rgb = imread(path_rgb);
    [heigth,width,color] = size(img_rgb); %Checking width of img
    
    dummy = labeled_rgb_ndvi_blue{i};
    rgb_gt_labeled{i} = dummy{1}(1,:);  %Storing Value of GroundTruth of RGB
    ndvi_gt_labeled{i} = dummy{1}(2,:); %Storing Value of GroundTruth of NDVI
    blue_gt_labeled{i} = dummy{1}(3,:); %Storing Value of GroundTruth of Solope Blue
    
    
    path = imageSource_final{i};
    img = imread(path);
    
    [bbox, score, label] = detect(detector,img);
    rgb_box{i} = [1,1,1,1];
    ndvi_box{i} = [1,1,1,1];
    blue_box{i} = [1,1,1,1];
    for j = 1:size(bbox,1)
        if ~(isempty(bbox))
            if (bbox(j,1) <= width)
                rgb_box{i} = bbox(j,:);
                rgb_score{i} = score(j,:);
            elseif (bbox(j,1) >= width) && (bbox(j,1) <= width*2)
                ndvi_box{i} = bbox(j,:);
                ndvi_score{i} = score(j,:);
            elseif (bbox(j,1) >= width*2) && (bbox(j,1) <= width*3)
                blue_box{i} = bbox(j,:);
                blue_score{i} = score(j,:);
            else
                error_condition{i} = bbox(j,:);
                error_score{i} = score(j,:);
                error_case{i} = bbox;
                error_img{i} = path;

            end
        else
             rgb_box{i} = [1,1,1,];
             rgb_score{i} = 0;
             ndvi_box{i} = [1,1,1,];
             ndvi_score{i} = 0;
             blue_box{i} = [1,1,1,];
             blue_score{i} = 0;
        end
        
    end
    
    
    Box{i}=bbox;
    Score{i}=score;
    
   
    
    
    
    
  detectedImg = insertShape(img,'Rectangle',rgb_box{i},'Color','red');
  detectedImg2 = insertShape(detectedImg,'Rectangle',ndvi_box{i},'Color','blue');
  detectedImg3 = insertShape(detectedImg2,'Rectangle',blue_box{i},'Color','green');
  
  detectedImg4 = insertShape(detectedImg3,'Rectangle',rgb_gt_labeled{i},'Color','white');
  detectedImg5 = insertShape(detectedImg4,'Rectangle',ndvi_gt_labeled{i},'Color','white');
  detectedImg6 = insertShape(detectedImg5,'Rectangle',blue_gt_labeled{i},'Color','white');
  
  sp = ['./final_result\',imageSource_rgb{i}(12:end)];
  imwrite(detectedImg6,sp)
   
    
    x{t} = imageSource_final{i};
    
    
    t=t+1;
end