clear
clc
close all

load('final_result_box.mat', 'rgb_box')
load('final_result_box.mat', 'ndvi_box')
load('final_result_box.mat', 'blue_box')
load('happiest_result_ndvi_rgb.mat', 'groundTruthBox_rgb')
load('imgSrc_bbox_selection.mat', 'imageSource_bbox_selection')

t=1;
for num=1:70
    
    %load image
    I = imread(imageSource_bbox_selection(num));
    imsize = size(I);
    
    %gt
    gt = groundTruthBox_rgb(num);
    gt_rgb = gt{1}(1,:);%gt bbox rgb
    
    %bbox
    box_rgb = [rgb_box{num+700}];%bbox rgb
    box_ndvi = [ndvi_box{num+700}];%bbox ndvi
    box_slope = [blue_box{num+700}];%bbox slope
    
    %adjust bbox
    box_ndvi(1) = box_ndvi(1) - imsize(2);
    box_slope(1) = box_slope(1) - (2*imsize(2));
    
    %find iou
    rgb_ndvi_overlapRatio = bboxOverlapRatio(box_rgb,box_ndvi,'Union');
    rgb_slope_overlapRatio = bboxOverlapRatio(box_rgb,box_slope,'Union');
    ndvi_slope_overlapRatio = bboxOverlapRatio(box_ndvi,box_slope,'Union');
    overlapRatio = [rgb_ndvi_overlapRatio, rgb_slope_overlapRatio, ndvi_slope_overlapRatio];
    
    %find max ratio
    max_ratio = max(overlapRatio);
    max_boxes = find(overlapRatio == max_ratio);
    
    
    
    %assign bboxes
    box_a = box_rgb;
    box_b = box_ndvi;
    
    if max_boxes == 1
        
        box_a = box_rgb;
        box_b = box_ndvi;
        
    elseif max_boxes == 2
        
        box_a = box_rgb;
        box_b = box_slope;
        
    else
        
        box_a = box_ndvi;
        box_b = box_slope;
        
    end
    
    %bstar
    xmin = min(box_a(1),box_b(1));
    ymin = min(box_a(2),box_b(2));
    wstar = max(box_a(1)+box_a(3),box_b(1)+box_b(3)) - xmin;
    hstar = max(box_a(2)+box_a(4),box_b(2)+box_b(4)) - ymin;
    bstar = [xmin, ymin, wstar, hstar];
    bstar_box_a_overlapRatio = bboxOverlapRatio(bstar,box_a,'Union');
    bstar_box_b_overlapRatio = bboxOverlapRatio(bstar,box_b,'Union');
    
    %set initial result
    result_box = box_a;
    
    %set conditions
    if overlapRatio(1) <= 0.638
        
        if bstar_box_a_overlapRatio >= 0.4 || bstar_box_b_overlapRatio >= 0.4
            
            result_box = bstar;
        else
            xleft = max(box_a(1),box_b(1));
            xright = min(box_a(1)+box_a(3),box_b(1)+box_b(3));
            ytop = max(box_a(2),box_b(2));
            ybottom = min(box_a(2)+box_a(4),box_b(2)+box_b(4));
            width = xright - xleft;
            height = ybottom - ytop;
            intersected_box = [xleft, ytop, width, height];
            result_box = intersected_box;
    
        
        end
        
    else
        xleft = max(box_a(1),box_b(1));
        xright = min(box_a(1)+box_a(3),box_b(1)+box_b(3));
        ytop = max(box_a(2),box_b(2));
        ybottom = min(box_a(2)+box_a(4),box_b(2)+box_b(4));
        width = xright - xleft;
        height = ybottom - ytop;
        intersected_box = [xleft, ytop, width, height];
        result_box = intersected_box;
    
       
    end
    
    result_box = abs(result_box);

    gt_intersect_overlapRatio = bboxOverlapRatio(gt_rgb,result_box,'Union')
    RGB = insertShape(I,'Rectangle',gt_rgb);
    %RGB = insertShape(RGB,'Rectangle',box_b);
    RGB = insertShape(RGB,'FilledRectangle',result_box,'Color','green');
    imshow(RGB)
    
    %result_3_bboxes_v41{num} = result_box;
    iou_3_bboxes_ver4(t,1) = gt_intersect_overlapRatio;

    
    t = t + 1;
end
