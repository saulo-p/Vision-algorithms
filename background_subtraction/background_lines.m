%% =======================================================================
%
% TODO: 
% - Wrap corners extraction as function
% - Use median corner distance as baseline for max_window size;
%
% Created: 9/11/2017
% Author: Saulo P.
% ========================================================================
clear all;
close all;

%% Setup
% Input data
im = im2double(rgb2gray(imread('./anteparo_pat/IMG_20171108_125823143.jpg')));
im_sz = size(im);

%>Parameters:
% LPF
gaussian_size = 7;
gaussian_sigma = 0.8;
% Binarization
bin_th = 0.4;
% Morphological operations
len = 7;

% Max window
window_size = 150; %pixels

%% Main code

%>Filters
L = fspecial('gaussian', gaussian_size, gaussian_sigma);
H = fspecial('sobel');

imf = imfilter(im, L);
% figure;
% subplot(2,2,1); imshow(imfilter(imf,H)); subplot(2,2,2); imshow(imfilter(imf,H'));
% subplot(2,2,3); imshow(imfilter(imf,-H)); subplot(2,2,4); imshow(imfilter(imf,-H'));

% Combines Sobel filters in each direction and performs threshold
% binarization. TODO: binarize by bw percentage.
imb = imfilter(imf, H) > bin_th  | imfilter(imf, H') > bin_th | ...
      imfilter(imf, -H) > bin_th | imfilter(imf, -H') > bin_th;

%>Erosions
%Line erosions
steL1 = strel('line',len,45);
steL2 = strel('line',len,-45);
imbe = imerode(imb,steL1) | imerode(imb,steL2);

% subplot(1,2,1); imshow(im + 0.5*imb);
% subplot(1,2,2); imshow(im + 0.5*imbe);

%% Vertical Gap:
v_ws = sum(imb, 1);
[~, gap_idx] = find(v_ws < 10);

%>Find vertical gap
% [gap, gap_idx] = max(v_sums(2:end) - v_sums(1:end-1));
figure; imshow(im + 0.5*imb); hold on;
plot([gap_idx(1) gap_idx(1)], [0 im_sz(1)], 'g');
plot([gap_idx(end) gap_idx(end)], [0 im_sz(1)], 'g');

%% Find frontiers
%>Separates images
imbs{1} = imb;
imbs{1}(:,gap_idx(end-1):end) = 0;
imbs{2} = imb;
imbs{2}(:, 1:gap_idx(2)) = 0;

%>Determine frontier pixels
for i = 1:2
    front{i} = zeros(1, size(imbs{i},1));
end
for j = 1:size(imbs{1},1)
    front{1}(j) = max(find(imbs{1}(j,:)));
end
for j = 1:size(imbs{2},1)
    front{2}(j) = min(find(imbs{2}(j,:)));
end

%TEST: 
for i = 1:2
    subplot(2,1,i); imshow(imbs{i}'); hold on; scatter(1:length(front{i}),front{i},'.');
end

%>Find baselines 
baselines{1} = movmax(front{1}, window_size);
baselines{2} = movmin(front{2}, window_size);

figure; imshow(im); hold on;
plot(baselines{1}, 1:length(baselines{1}),'g', 'LineWidth',2);
plot(baselines{2}, 1:length(baselines{2}),'g', 'LineWidth',2);