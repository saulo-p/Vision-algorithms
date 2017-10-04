%% ========================================================
% [IN0996] Visão Computacional - Projeto 1
%  Questão 4
%
% References:
%
% Aluno: Saulo Pereira (scrps@cin.ufpe.br)
% =========================================================
close all;
clear all;

%% Input data
im = im2double(rgb2gray(imread('./data/predio.bmp')));

%% Pre-processing (filtering and binarization)

% h2 = fspecial('log', 9);
% imf = conv2(im, h2);
% imf = imf.*(imf > 0);
% imf = NormalizeImage(imf);
% 
% imshow(imf);
% figure;
% imb = imshow(imf > 0.1);


h1 = fspecial('average', 5);

imf = conv2(im, h1);
imb = edge(imf, 'canny');
% canny is used for better performance of hough line detector (fewer active
% pixesl).

%% Line detection
[H, tta, rho] = hough(imb);

subplot(2,1,1);
imshow(im);

subplot(2,1,2);
imshow(imadjust(mat2gray(H)), 'XData', tta, 'YData', rho, ...
       'InitialMagnification', 'fit');
title('Hough transform');
xlabel('\theta'), ylabel('\rho');
colormap(gca,hot);


%% Information processing