clear all;
close all;

path = 'C:\Users\Saulo\Documents\GitHub\Vision-algorithms\cylinder_reconstruction\2017_11_29\'
vars = load('cameraParams');
cameraParams = vars.camera_params;
K = cameraParams.IntrinsicMatrix';

imgs = [29 30 33 35 36];

vds = [];
for i = 1:length(imgs)
    img = imread([path 'img_' num2str(imgs(i)) '.png']);
    img = im2double(img);
    im_sz = size(img);
    
    [img, ~] = undistortImage(img,cameraParams);
%     figure;
%     imshow(img);
    
    %Image processing:
    [contours, backg_idxs] = FindCylinderContour(img);
    
    %Object reconstruction
    [p0, vd] = ReconstructCylinder(contours, backg_idxs, K, im_sz);
    
    vds = [vds vd];

end
