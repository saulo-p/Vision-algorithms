%% =======================================================================
% Cylinder detection over known background
%  Determine the contour pixels of a cylinder (or any object with straigth
%  lines) using a specific background.
%
% Created: 9/11/2017
% Author: Saulo P.
% ========================================================================
clear all;
close all;

%% Setup
% Input data
im = im2double(imread('./anteparo_pat/img_36.png'));
im_sz = size(im);

%>Parameters:
% LPF
gaussian_size = 7;
gaussian_sigma = 0.8;
% Binarization
bin_th = 0.25;
% Morphological operations
len = 7;
% Gap
gap_th = 10;
% Max window
window_size = 100; %pixels

%% Main code

%>Pre processing and binarization
imb = PatternBinarization(im, gaussian_size, gaussian_sigma, bin_th);

%> Find ROI (background pattern and cylinder)
[backg_idxs, gap_idxs] = FindCylinderROI(imb, gap_th);

%Remove undesired information (that might harm following steps).
imb(1:backg_idxs,:) = 0;
imb(backg_idxs(end):end,:) = 0;
imb(:, gap_idxs) = 0;

% % TEST: ROI
% figure; imshow(im + 0.5*imb); hold on;
% plot([gap_idxs(1) gap_idxs(1)], [0 im_sz(1)], 'g');
% plot([gap_idxs(end) gap_idxs(end)], [0 im_sz(1)], 'g');
% plot([0 im_sz(2)], [backg_idxs(1) backg_idxs(1)] , 'g');
% plot([0 im_sz(2)], [backg_idxs(end) backg_idxs(end)], 'g');

%% Find frontiers

%>Separates image (left/right) based on approximate gap
gap_sz = gap_idxs(end) - gap_idxs(1);
imbs{1} = imb;
imbs{1}(:,gap_idxs(end-floor(gap_sz/2)):end) = 0;
imbs{2} = imb;
imbs{2}(:, 1:gap_idxs(1+floor(gap_sz/2))) = 0;

%>Find cylinder contours
[front, contours] = FindContours(imbs, backg_idxs, window_size);

%TEST: Estimated object contour
figure; imshow(im); hold on;
for i = 1:2
    scatter(front{i}, backg_idxs,'b.');
end
plot(contours{1}, backg_idxs, 'g', 'LineWidth',2);
plot(contours{2}, backg_idxs, 'g', 'LineWidth',2);

save ('contours.mat', 'contours', 'backg_idxs', 'im_sz');



