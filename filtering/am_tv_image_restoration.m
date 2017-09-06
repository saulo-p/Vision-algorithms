%% ========================================================================
% An Augmented Lagrangian Method for Total Variation Video Restoration
%
% * Memory use grows exponentially(?) with image size.
%
% TODO:
%   - Padding of the original image with zeros (depending on the size of
%   the desired blur kernel)
%       - This forces the toeplitz to generate a circulant Matrix which can
%       be solved by equation 15.
%       * Be aware of the case of even sized filters (D)
%   - Less memory use during execution (?) 
%
% References:
% https://www.mathworks.com/help/matlab/ref/sparse.html
% https://www.mathworks.com/help/matlab/ref/full.html
%
% Author (code): Saulo P.
% Date Created: 01/09/17
% =========================================================================
clear all;
close all; 
%% Script (Algorithm 1)

%% Initial setup 

%Input data (image and blur kernel):
im = im2double(rgb2gray(imread('lena.bmp')));

% blur kernel
h = fspecial('gaussian');
% forward difference kernels 
dx = [-1 1];
dy = dx'; %talvez invertido.

% image limitation (computational complexity) and padding (correctness)
% im = im(250:349, 250:349);
im = im(250:279, 250:279);
im_sz = size(im);
im = ImagePadding(im, size(h));
    %talvez substituir chamada da função por troca do 'same' na conv2.
    % atual deteriora bordas da imagem com o filtro local
im_sz_pad = size(im);

% Input parameters (algorithm):
mu = 1;
beta = [1 1];
ro_r = 2;
alpha_0 = 0.7;

%% Pre-processing

% Create synthetic observation (blur + noise)
G = conv2(im, h, 'same');
G = imnoise(G, 'salt & pepper', 0.01);
% imshow(g);

% Image linearizations
f_truth = reshape(im, im_sz_pad(1)*im_sz_pad(2), 1);
g = reshape(G, im_sz_pad(1)*im_sz_pad(2), 1);

% Pre-computed matrices
Dx = sparse(OperatorFromKernel(dx, im_sz, im_sz_pad, 0));
Dy = sparse(OperatorFromKernel(dy, im_sz, im_sz_pad, 0));
H = sparse(OperatorFromKernel(h, im_sz, im_sz_pad, 0));
D = Dx + Dy;

%% Algorithm initializations:
f = g;
u = D*f; 
if (true)
% imshow(reshape(u, im_sz(1), im_sz(2)));
subplot(2,1,1);
imshow(G);
Dyf = full(Dy);
subplot(2,1,2);
imshow(abs(Dyf));
end
y = zeros(size(f));

converge = false;
while (true)
    fSubproblem(mu, ro_r, g, y, u, H, D);
    
    converge = true;
    if (converge)
        break
    end
end
