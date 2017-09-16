%% ========================================================
% [IN0996] Visão Computacional - Projeto 1
%  Questão 1
% Aluno: Saulo Pereira (scrps@cin.ufpe.br)
% =========================================================
close all;
% clear all;

%% Input data
im_temp = imread('./data/parafuso_porca.bmp');

%% Template segmentation

% background uniforme
% TODO: substituir por versao baseada em histograma.
th = median(median(im_temp)) - 10;

bw_temp = ThresholdBinarization(im_temp, th);
imshow(bw_temp);

ProjectionSegmentation(bw_temp, 2);
