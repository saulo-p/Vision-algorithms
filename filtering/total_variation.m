%% ========================================================================
% Total variation of image (experiments)
%
% Author: Saulo P.
% Date Created: 23/08/17
% =========================================================================
clear all;
close all;
%% 
im = rgb2gray(imread('lena.bmp'));
im_d = im2double(im)*255;

imshow(im_d, []);

dx = [-1 1];
dy = dx';

im_x = filter2(dx, im_d);
im_y = filter2(dy, im_d);

im_f = abs(im_x) + abs(im_y);
figure, imshow(im_d + im_f, []); %emphasize the details