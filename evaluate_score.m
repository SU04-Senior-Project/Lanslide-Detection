clear
clc
close all


%load('imageSource_fused_2_70.mat','imageSource_fused')
load('imageSource.mat','imageSource_rgb')
load('result_2_bboxes_ndvi_slope.mat','result_2_bboxes_ndvi_slope')
load('result_2_bboxes_rgb_ndvi.mat','result_2_bboxes_rgb_ndvi')
load('result_2_bboxes_rgb_slope.mat','result_2_bboxes_rgb_slope')

load('result_21_bboxes_ndvi_slope.mat','result_21_bboxes_ndvi_slope')

load('result_3_bboxes.mat','result_3_bboxes')





load('result_2_bboxes_ndvi_slope_v4.mat','result_2_bboxes_ndvi_slope_v4')
load('result_2_bboxes_rgb_ndvi_v4.mat','result_2_bboxes_rgb_ndvi_v4')
load('result_2_bboxes_rgb_slope_v4.mat','result_2_bboxes_rgb_slope_v4')
load('result_3_bboxes_v4.mat','result_3_bboxes_v4')


load('result_2_bboxes_ndvi_slope_v41.mat','result_2_bboxes_ndvi_slope_v41')
load('result_2_bboxes_rgb_ndvi_v41.mat','result_2_bboxes_rgb_ndvi_v41')
load('result_2_bboxes_rgb_slope_v41.mat','result_2_bboxes_rgb_slope_v41')
load('result_3_bboxes_v41.mat','result_3_bboxes_v41')



load('b_rgb.mat','b_rgb')
%load('predicted_slope_grayscale_score_70.mat','Box')
load('labeled_770.mat')  

t = 701;
Box = result_3_bboxes_v41;
% Box{2} = [1,1,1,1];
% Box{5} = [1,1,1,1];
for i=1:length(Box)
    box_rgb = Box{i}(1,:);
    boxes_rgb{i,1} = Box{i}(1);
    boxes_rgb{i,2} = Box{i}(2);
    boxes_rgb{i,3} = Box{i}(3);
    boxes_rgb{i,4} = Box{i}(4);
    
    box_groundTruth = labeled_770{t}(1,:);
    boxes_groundTruth{i,1} =labeled_770{t}(1,1);
    boxes_groundTruth{i,2} = labeled_770{t}(1,2);
    boxes_groundTruth{i,3} = labeled_770{t}(1,3);
    boxes_groundTruth{i,4} = labeled_770{t}(1,4);

   img = imread(imageSource_rgb{t});
   img_white_rgb = zeros(size(img));
   img_white_gt = zeros(size(img));
   img_white_gt(boxes_groundTruth{i,1}:(boxes_groundTruth{i,1}+boxes_groundTruth{i,4}),boxes_groundTruth{i,2}:(boxes_groundTruth{i,2}+boxes_groundTruth{i,3})) =1;
   img_white_rgb(boxes_rgb{i,1}:(boxes_rgb{i,1}+boxes_rgb{i,4}),boxes_rgb{i,2}:(boxes_rgb{i,2}+boxes_rgb{i,3})) =1;
   
   eval_rgb = Evaluate_pre_recall_R2(img_white_gt,img_white_rgb);

   mea_acc_rgb{i,1} = eval_rgb(1);
   mea_sen_rgb{i,1} = eval_rgb(2);
   mea_pre_rgb{i,1} = eval_rgb(4);
   mea_recall_rgb{i,1} = eval_rgb(5);
   mea_f_rgb{i,1} = eval_rgb(6);
   IOU_rgb{i,1} = bboxOverlapRatio(box_rgb,box_groundTruth);

   t = t+1;
end



tt_rgb = cell2mat(mea_f_rgb);
test_rgb= isnan(tt_rgb);
test2_rgb = find(test_rgb);

for(i=1:length(test2_rgb))
    mea_f_rgb(test2_rgb(i)) = {0};
end




M_accuracy_rgb = mean(cell2mat(mea_acc_rgb));
M_sen_rgb = mean(cell2mat(mea_sen_rgb));
M_precision_rgb = mean(cell2mat(mea_pre_rgb));
M_recall_rgb = mean(cell2mat(mea_recall_rgb));
M_f_rgb = mean(cell2mat(mea_f_rgb));


M_IoU_rgb = mean(cell2mat(IOU_rgb));


result_rgb = [M_accuracy_rgb,M_sen_rgb,M_precision_rgb,M_recall_rgb,M_f_rgb,M_IoU_rgb]


%save('happiest_result_ndvi_rgb')


