%% =============================================
%
% Created: 7/11/2017
% Author: Saulo P.
% ==============================================
clear all;
close all;

im = im2double(rgb2gray(imread('./anteparo_pat/img_2.png')));
im_sz = size(im);

%% Corner approach

% Parameters
gaussian_size = 7;
gaussian_sigma = 1.0;
block_size = 5;
tol = 0.25;


% Pre processing
L = fspecial('gaussian', gaussian_size, gaussian_sigma);
iml = imfilter(im, L);

% Corner based filtering
C = [-1*ones(block_size) ones(block_size);
     ones(block_size) -1*ones(block_size)];
iml = imrotate(iml, 45);
imf = imfilter(iml, C);
imf = imrotate(imf, -45);
 %crop back to original size
rot_sz = size(imf);
imc = imcrop(imf, [(rot_sz(2)-im_sz(2))/2 (rot_sz(1)-im_sz(1))/2 ... 
                    im_sz(2)-1 im_sz(1)-1]);
% imshow(imc);
% figure;
% imshow(im);
imf = NormalizeImage(imc);

imb = imf > 1 - tol | imf < tol;
imshow(imb);

[cfx, cfy] = find(imb);
cf = [cfy cfx];

imshow(im);
hold on
scatter(cf(:,1), cf(:,2), 'r*');

% %  VERTICAL GAP APPROACH (WIP)
% % sort on x coordinate
% [~, idx] = sort(cf(:,1));
% cf = [cf(idx,1) cf(idx,2)];
% scatter(cf(:,1), cf(:,2), 'b');
% 
% % find vertical gap
% [gap, gap_idx] = max(cf(2:end,1) - cf(1:end-1,1));
% plot([cf(gap_idx,1) cf(gap_idx,1)], [0 im_sz(1)], 'g');
% plot([cf(gap_idx+1,1) cf(gap_idx+1,1)], [0 im_sz(1)], 'g');
