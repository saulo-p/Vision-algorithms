%% ========================================================
% [IN0996] Visão Computacional - Projeto 1
%  Questão 1
%
% References:
% https://www.mathworks.com/help/images/ref/normxcorr2.html
% https://www.mathworks.com/help/images/ref/bwconncomp.html
%
%
% Aluno: Saulo Pereira (scrps@cin.ufpe.br)
% =========================================================
close all;
% clear all;

%% Input data
im_temp = imread('./data/parafuso_porca.bmp');
im_target = imread('./data/objetos.bmp');

%% Template segmentation
% background uniforme
% TODO: substituir por versao baseada em histograma.
th = median(median(im_temp)) - 10;

bw_temp = ThresholdBinarization(im_temp, th);
clear im_temp;
% imshow(bw_temp);

templates = ProjectionSegmentation(bw_temp, 2);

%% Target image segmentation
th = median(median(im_target)) - 15;
bw_target = ThresholdBinarization(im_target, th);
clear im_target;
% imshow(bw_target);

[crI, num_regions] = ConnectedRegions(bw_target);
figure;
imshow(crI, []);
