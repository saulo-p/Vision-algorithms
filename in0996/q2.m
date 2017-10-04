%% ========================================================
% [IN0996] Visão Computacional - Projeto 1
%  Questão 2
%
% References:
% https://www.mathworks.com/help/images/examples/detecting-a-cell-using-image-segmentation.html
%
% Aluno: Saulo Pereira (scrps@cin.ufpe.br)
% =========================================================
clear all;
close all;

im = imread('./data/35008.jpg');
im_g = im2double(rgb2gray(im));

% Focused regions tend to have more details, therefore the variance should
% return higher values (be aware of textureless regions).
im_var = ImageLocalVariance(im_g, [3 3]);
figure;
subplot(1,2,1);
imshow(im_var, []);
title ('Variance original image');
subplot(1,2,2);
imhist(im_var);


%%

%laplacian filter
h_lap = [0 1 0;1 -4 1;0 1 0];
im_lap = conv2(im_g, h_lap, 'valid');
im_lap = NormalizeImage(im_lap);
% mu = mean(mean(im_lapn));
figure;
subplot(1,2,1);
imshow(im_lap, []);
title ('Laplacianl original image');
subplot(1,2,2);
imhist(im_lap);

im_vol = ImageLocalVariance(im_lap, [3 3]);
figure;
subplot(1,2,1);
imshow(im_vol, []);
title ('Variance of Laplacian');
subplot(1,2,2);
imhist(im_vol);

vol_bw = im_vol > 0.025;
seD = strel('diamond', 1);
vol_bw = imerode(vol_bw, seD);
im_mask = imfill(vol_bw, 'holes');
im_mask = AddFrame(im_mask, [1 1]);
figure;
imshow(im_mask.*im_g);

im_mask = uint8(im_mask);
for i = 1:3
    im_final(:,:,i) = im(:,:,i).*im_mask;
end

figure;
imshow(im_final);