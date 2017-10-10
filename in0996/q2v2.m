%% ========================================================
% [IN0996] Visão Computacional - Projeto 1
%  Questão 2 v2
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

%% Filtering 
h = fspecial('log', 3);
imf = imfilter(im_g, h);
% imf = NormalizeImage(imf);

% Binarization
imb = imf > 0.05;
imshow(imb);

%% Morphological operations
dil_elem = strel('disk', 6);
er_elem = strel('disk', 7);

mask = imb;
% Closure
mask = imdilate(mask, dil_elem);
mask = imerode(mask, er_elem);
% Fill gaps
% mask = imfill(mask, 'holes');
% imshow(mask);

% Apply mask to each channel
mask = uint8(mask);
for i = 1:3
    im_final(:,:,i) = im(:,:,i).*mask;
end

imshow(im_final);