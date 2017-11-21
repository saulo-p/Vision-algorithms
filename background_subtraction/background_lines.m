%% =============================================
%
% Created: 9/11/2017
% Author: Saulo P.
% ==============================================
clear all;
close all;

%% Setup
% Input data
im = im2double(rgb2gray(imread('./anteparo_pat/img_3.png')));
im_sz = size(im);

gaussian_size = 7;
gaussian_sigma = 0.8;

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
imb = imfilter(imf, H) > 0.4  | imfilter(imf, H') > 0.4 | ...
      imfilter(imf, -H) > 0.4 | imfilter(imf, -H') > 0.4;

%>Erosions
len = 7;
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
%     subplot(2,1,i); plot(front{i});
end
    
%% OLD
% [H, tta, rho] = hough(imb, 'Theta', -10:10);
% % figure; imshow(H, []); axis normal;
% peaks = houghpeaks(H, 15);
% lines = houghlines(imb, tta, rho, peaks);
% disp('hello');
% 
% figure;
% imshow(imb);
% hold on;
% max_len = 0;
% for k = 1:length(lines)
%    xy = [lines(k).point1; lines(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% end