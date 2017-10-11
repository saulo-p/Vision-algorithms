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

im = im2double(imread('./data/42049.jpg'));

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
nReps = 5;
% repeat the clustering nReps times to avoid local minima
[cluster_idx, ~] = kmeans(ab,nClusters,'Distance','sqEuclidean', ...
                          'Replicates', nReps);

pixel_labels = reshape(cluster_idx, nrows, ncols);
pixel_labels = pixel_labels - 1;

% Assumes that corner pixel is background.
if (pixel_labels(end) == 1)
    pixel_labels = ~pixel_labels;
end

imshow(pixel_labels,[]);
title('labels returned');

%% Post processing:

% Select the biggest region.
crs = bwconncomp(pixel_labels);
numPixels = cellfun(@numel,crs.PixelIdxList);
[~,idx] = max(numPixels);

labels = zeros(size(pixel_labels));
labels(crs.PixelIdxList{idx}) = 1;
% imshow(labels);

% Generate contour
contour = bwboundaries(labels);

% Plot contour over image
imshow(im), hold on;
for x = 1:numel(contour)
    if length(contour{x}) > 100
      plot(contour{x}(:,2), contour{x}(:,1), 'r', 'Linewidth', 3)
    end
end
