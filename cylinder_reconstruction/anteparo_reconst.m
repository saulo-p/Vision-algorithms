clear all;
close all;

% path = 'C:\Users\Saulo\Documents\GitHub\Vision-algorithms\cylinder_reconstruction\2017_11_29\'
% vars = load('cameraParams');
% cameraParams = vars.camera_params;
% imgs = [29 30 33 35 36];

path = 'C:\Users\Saulo\Documents\GitHub\Vision-algorithms\cylinder_reconstruction\data\'
vars = load('.\data\cam_params');
cameraParams = vars.cam_params;
imgs = 1:120;

K = cameraParams.IntrinsicMatrix';


vds = zeros(3, length(imgs)); ps = zeros(3, length(imgs));
vds_ex = zeros(3, length(imgs)); ps_ex = zeros(3, length(imgs));
for i = 1:length(imgs)
    img = imread([path 'img_' num2str(imgs(i)) '.png']);
    img = im2double(img);
    im_sz = size(img);
    
    [img, ~] = undistortImage(img,cameraParams);
%     figure;
%     imshow(img);
    
    %Image processing:
    [contours, backg_idxs] = FindCylinderContour(img, true);
    drawnow;
    
    %Object reconstruction
    [p0, vd] = ReconstructCylinder(contours, backg_idxs, K, im_sz);
    [p0_ex, vd_ex] = ReconstructCylinderExact(contours, backg_idxs, K, im_sz);
    
    ps(:,i) = p0;
    vds(:,i) = vd;
    ps_ex(:,i) = p0_ex;
    vds_ex(:,i) = vd_ex;
end


figure;
scatter3(0,0,0, 'b', 'filled');
hold on;
set(gca, 'dataaspectratio', [1 1 1]);

Dmtr = 20e-2;
for i = 1:length(imgs)
    vd = vds_ex(:,i);
    p0 = ps_ex(:,i);
    
    %>Fitted line
    line = [p0 - 0.2*vd p0 + 0.2*vd];
    plot3(line(1,:), line(2,:), line(3,:), 'g');

    [Xc, Yc, Zc] = cylinder2(Dmtr*[1 1], vd);
    Xc = Xc + p0(1);
    Yc = Yc + p0(2);
    Zc = Zc + p0(3);
    C = 0.3*ones(size(Xc));
    surf(Xc, Yc, Zc, C);
    [Xc, Yc, Zc] = cylinder2(Dmtr*[1 1], -vd);
    Xc = Xc + p0(1);
    Yc = Yc + p0(2);
    Zc = Zc + p0(3);
    surf(Xc, Yc, Zc, C);
end
for i = 1:length(imgs)
    vd = vds(:,i);
    p0 = ps(:,i);
    
    %>Fitted line
    line = [p0 - 0.2*vd p0 + 0.2*vd];
    plot3(line(1,:), line(2,:), line(3,:), 'r');

    [Xc, Yc, Zc] = cylinder2(Dmtr*[1 1], vd);
    Xc = Xc + p0(1);
    Yc = Yc + p0(2);
    Zc = Zc + p0(3);
    C = 0.8*ones(size(Xc));
    surf(Xc, Yc, Zc, C);
    [Xc, Yc, Zc] = cylinder2(Dmtr*[1 1], -vd);
    Xc = Xc + p0(1);
    Yc = Yc + p0(2);
    Zc = Zc + p0(3);
    surf(Xc, Yc, Zc, C);
end

%%
hand = fopen('./results/points_ex.txt', 'w');
fprintf(hand, '%f\n', ps_ex);
fclose(hand);
hand = fopen('./results/vectors_ex.txt', 'w');
fprintf(hand, '%f %f %f\n', vds_ex);
fclose(hand);

hand = fopen('./results/points.txt', 'w');
fprintf(hand, '%f\n', ps);
fclose(hand);
hand = fopen('./results/vectors.txt', 'w');
fprintf(hand, '%f %f %f\n', vds);
fclose(hand);