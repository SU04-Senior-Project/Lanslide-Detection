clc
clear
close all

load('imageSource.mat','imageSource_rgb','imageSource_ndvi','imageSource_slope_blue')

% i=1;
t=1;
% length(ImageSource_700)
for i=1:length(imageSource_rgb)


   path_rgb = imageSource_rgb{i};
   img_rgb = imread(path_rgb);
    
   path_ndvi = imageSource_ndvi{i};
   img_ndvi = imread(path_ndvi);
    
   
   path_blue = imageSource_slope_blue{i};
   img_blue = imread(path_blue);
   
   
   
   comb_rgb_ndvi = imfuse(img_rgb, img_ndvi, 'montage');
   comb_rgb_ndvi_blue = imfuse(comb_rgb_ndvi,img_blue,'montage');
   
   temp_size1 = size(img_rgb,1);
   temp_size2 = (size(img_rgb,2)*3);
   I2 = imcrop(comb_rgb_ndvi_blue,[1 1 temp_size2 temp_size1]); % cut three
   

   
   sp = ['./dataset3_fused_rgb_ndvi_blue\',imageSource_rgb{i}(12:end)]; %This
   imwrite(I2,sp)
   


    
end
%save('detector_fused_images_score')