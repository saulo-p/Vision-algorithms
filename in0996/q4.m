%% ========================================================
% [IN0996] Visão Computacional - Projeto 1
%  Questão 4
%
% References:
% https://www.mathworks.com/help/images/ref/houghlines.html
%
% Aluno: Saulo Pereira (scrps@cin.ufpe.br)
% =========================================================
close all;
clear all;

%% Input data
im = im2double(rgb2gray(imread('./data/predio.bmp')));

%% Pre-processing (filtering and binarization)

%low pass to remove details and texture
h1 = fspecial('average', 5);
imf = conv2(im, h1);

% Hough detector is based on voting. Non-maximum supression from Canny
% makes it suitable to work with the voting scheme.
imb = edge(imf, 'canny');

% Erode to remove vertical features (optional: rough will remove already)
% st_elem = [1 1];
% imb = imerode(imb, st_elem);

%% Line detection

[H, tta, rho] = hough(imb, 'Theta', 40:0.5:89);
peaks = houghpeaks(H, 10);
lines = houghlines(imb, tta, rho, peaks);

figure;
imshow(imb);
hold on;
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
end

%% Information processing (heuristics and contextual information)

% Floors are expected to have the same heigth, so we want rho values
% that are evenly spaced (main filter).
% Also, due to the projective aspect of the image, the angles are expected 
% to monotonically increase/decrease with the distances.
%  *For increased robustness, this could be considered.

ttas = zeros(1, length(lines));
rhos = zeros(1, length(lines));
for i = 1:length(lines)
    ttas(i) = lines(i).theta;
    rhos(i) = lines(i).rho;
end

[s_tta, idx_tta] = sort(ttas);
[s_rho, idx_rho] = sort(rhos);
d = s_rho(2:end) - s_rho(1:end-1);
median_d = median(d);

% Pairs that are close are expected to represent the same line
d = d( abs(d - median_d) < 0.1*median_d );

% Filter lines that do not follow the above logic
disp('Numero de andares =')
disp(length(d) + 1)

