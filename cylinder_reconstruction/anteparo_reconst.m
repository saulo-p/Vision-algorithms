clear all;
close all;

path = 'C:\Users\Saulo\Documents\GitHub\Vision-algorithms\cylinder_reconstruction\2017_11_29\'
vars = load('cameraParams');
cameraParams = vars.camera_params;
K = cameraParams.IntrinsicMatrix';

imgs = [29 30 33 35 36];
% imgs = 30;

vds = [];
ps = [];
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
    [p0, vd] = ReconstructCylinderExact(contours, backg_idxs, K, im_sz);
    
    ps = [ps p0];
    vds = [vds vd];

end


figure;
% scatter3(0,0,0, 'b', 'filled');
hold on;

Dmtr = 20e-2;
for i = 1:length(imgs)
    vd = vds(:,i);
    p0 = ps(:,i);
    
    %>Fitted line
    line = [p0 - 0.2*vd p0 + 0.2*vd];
    plot3(line(1,:), line(2,:), line(3,:), 'g');

    [Xc, Yc, Zc] = cylinder2(Dmtr*[1 1], vd);
    Xc = Xc + p0(1);
    Yc = Yc + p0(2);
    Zc = Zc + p0(3);
    surf(Xc, Yc, Zc);
    [Xc, Yc, Zc] = cylinder2(Dmtr*[1 1], -vd);
    Xc = Xc + p0(1);
    Yc = Yc + p0(2);
    Zc = Zc + p0(3);
    surf(Xc, Yc, Zc);
    colormap([0  0  1]); 
end
set(gca, 'dataaspectratio', [1 1 1]);
