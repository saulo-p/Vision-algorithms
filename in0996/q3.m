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

im = im2double(imread('./data/69020.jpg'));



%% Teste da versão tutorial:

cform = makecform('srgb2lab');
lab_im = applycform(im,cform);
% imshow(lab_im);

ab = double(lab_im(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

nColors = 2;
% repeat the clustering 3 times to avoid local minima
[cluster_idx, ~] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                          'Replicates',3);

pixel_labels = reshape(cluster_idx, nrows, ncols);
imshow(pixel_labels,[]), title('image labeled by cluster index');
imshow((~(pixel_labels-1)).*im);

%% Post processing:

% for i = 1:3
%     [cluster_idx, ~] = kmeans(im(:,:,i), 2);
%     
% end


% Espera-se formato de contorno simples para um animal. 
% podemos usar essa informação para excluir contorno complexo.
%  Extrai contorno
%  Calcula direção do gradiente no contorno
%  Descarta mudanças abruptas