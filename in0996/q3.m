%% ========================================================
% [IN0996] Visão Computacional - Projeto 1
%  Questão 3
%
% References:
% https://www.mathworks.com/help/images/examples/color-based-segmentation-using-k-means-clustering.html
%
% Aluno: Saulo Pereira (scrps@cin.ufpe.br)
% =========================================================

close all;
clear all;

%% Input data:

im = im2double(imread('./data/113044.jpg'));

%% Color space change:

cform = makecform('srgb2lab');
lab_im = applycform(im,cform);
% imshow(lab_im);

ab = double(lab_im(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

% RGB test:
% rgb = double(im);
% [nrows, ncols, ~] = size(rgb);
% rgb = reshape(rgb,nrows*ncols,3);

%% K-means segmentation
nClusters = 2;
% repeat the clustering 3 times to avoid local minima
[cluster_idx, ~] = kmeans(ab,nClusters,'Distance','sqEuclidean', ...
                          'Replicates', 5);

pixel_labels = reshape(cluster_idx, nrows, ncols);
pixel_labels = pixel_labels - 1;

imshow(pixel_labels,[]);
title('labels returned');

% figure;
% imshow((~(pixel_labels-1)).*im);

%% Post processing:

% Select the biggest region.
CC = bwconncomp(pixel_labels);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
labels = zeros(size(pixel_labels));
labels(CC.PixelIdxList{idx}) = 1;
% labels = pixel_labels - labels;
imshow(labels);

% Generate contour
b = bwboundaries(labels);
% dist(k) = length(b);
imshow(im), hold on;
for x = 1:numel(b)
if length(b{x}) > 100
  plot(b{x}(:,2), b{x}(:,1), 'r', 'Linewidth', 3)
end
end
