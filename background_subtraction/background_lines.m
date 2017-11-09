%% =============================================
%
% Created: 9/11/2017
% Author: Saulo P.
% ==============================================
clear all;
close all;

im = im2double(rgb2gray(imread('./anteparo_pat/img_2.png')));
im_sz = size(im);

% % STEPS
% rotate image
% find horizontal lines
% find end points of lines
% connect end points to form polygon


%% HPF approach (talvez complementar a anterior)

% L = fspecial('gaussian', 7, 1);
% H = fspecial('sobel');
% 
% imf = imfilter(im, L);
% imf = imfilter(imf, H) + imfilter(imf, H') + imfilter(imf, -H) + imfilter(imf, -H');
% 
% imshow(imf, []);
% imb = imbinarize(imf);
% 
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