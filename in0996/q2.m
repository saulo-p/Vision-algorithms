%% ========================================================
% [IN0996] Visão Computacional - Projeto 1
%  Questão 2
%
% Aluno: Saulo Pereira (scrps@cin.ufpe.br)
% =========================================================
clear all;
close all;

im = imread('./data/35008.jpg');
im_g = im2double(rgb2gray(im));

% h_box = [1 1 1;1 1 1;1 1 1]*(1/9);
% im_mu = conv2(im_g, h_box, 'same');
% im_mu = imboxfilt(im_g,9);

im_var = ImageLocalVariance(im_g, [5 5]);
figure;
imshow(im_var, []);
title ('Variance original image');

%%

%laplacian filter
h_lap = [0 1 0;1 -4 1;0 1 0];
im_lap = conv2(im_g, h_lap, 'valid');
im_lap = NormalizeImage(im_lap);
% mu = mean(mean(im_lapn));
figure;
imshow(im_lap, []);
title ('Laplacianl original image');

im_var2 = ImageLocalVariance(im_lap, [3 3]);
figure;
imshow(im_var2, []);
title ('Variance of Laplacian');