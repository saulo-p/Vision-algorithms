%% =============================================
%
% Created: 7/11/2017
% Author: Saulo P.
% ==============================================
clear all;
close all;

%% Setup
% Input data
im = im2double(rgb2gray(imread('./anteparo_pat/img_3.png')));
im_sz = size(im);

% Parameters
gaussian_size = 7;
gaussian_sigma = 1.0;
block_size = 5;
tol = 0.25;

%% Main code

%>Pre processing
L = fspecial('gaussian', gaussian_size, gaussian_sigma);
iml = imfilter(im, L);

%>Corner based filtering
C = [-1*ones(block_size) ones(block_size);
     ones(block_size) -1*ones(block_size)];
iml = imrotate(iml, 45);
imf = imfilter(iml, C);
imf = imrotate(imf, -45);
% crop back to original size
rot_sz = size(imf);
imc = imcrop(imf, [(rot_sz(2)-im_sz(2))/2 (rot_sz(1)-im_sz(1))/2 ... 
                    im_sz(2)-1 im_sz(1)-1]);
imf = NormalizeImage(imc);

%>Binarization 
imb = imf > 1 - tol | imf < tol;
% imshow(imb);

% TEST: Scatter regions over image
[cfx, cfy] = find(imb);
cf = [cfy cfx];
imshow(im); hold on; scatter(cf(:,1), cf(:,2), 'r*');

%>Connected regions centroids computation
cc = bwconncomp(imb);
centroids = zeros(2, length(cc.PixelIdxList));
for i = 1:length(cc.PixelIdxList)
    [cs, rs] = ind2sub(im_sz, cc.PixelIdxList{i});
    
    centroids(:,i) = [mean(rs) mean(cs)]';
end
scatter(centroids(1,:), centroids(2,:), 'b.');

