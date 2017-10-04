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
%% Script (Algorithm 1)
clear all;
close all; 

%% Initial setup 
%Input data (image and blur kernel):
im = im2double(rgb2gray(imread('./data/lena.bmp')));
im = im(250:349, 250:349);
im_sz = size(im);

% im = im2double(imread('./data/hor_lines.bmp'));
% im = im(1:4, 1:4);
% im_sz = size(im);
% im_sz_pad = im_sz;

% blur kernel
h = fspecial('gaussian',9, 1);
% forward difference kernels 
dx = [-1 1];
dy = dx'; %talvez invertido.

% Input parameters (algorithm):
mu = 1;
beta = [1 1];
ro_r = 2;
alpha_0 = 0.7;

%% Pre-processing

% Create synthetic observation (blur + noise)
G = conv2(im, h, 'same');
G = imnoise(G, 'salt & pepper', 0.01);
% imshow(G);

% Image linearizations
f_truth = reshape(im, im_sz(1)*im_sz(2), 1);
g = reshape(G, im_sz(1)*im_sz(2), 1);

% Pre-computed matrices
H = sparse(OperatorFromKernel(h, im_sz, 0));
Dx = sparse(OperatorFromKernel(dx, im_sz, 0));
Dy = sparse(OperatorFromKernel(dy, im_sz, 0));
D = Dx + Dy;

% subplot(3,1,1);
% imshow(im);
% subplot(3,1,2);
% o = H*f_truth;
% O = reshape(o, im_sz(1), im_sz(2));
% imshow(O);
% subplot(3,1,3);
% C = conv2(im,h,'same');
% imshow(C);

%% Algorithm initializations:
f = g;
u = D*f; 
if (false)
    subplot(2,1,1);
    imshow(G);
    subplot(2,1,2);
    imshow(reshape(u, im_sz(1), im_sz(2)));
end
y = zeros(size(f));

FH = fft2(full(H));
FD = fft2(full(D));

% Expensive computation.
if (false)
    nFH = norm(FH);
    nFD = norm(FD);
    save ('precomp', 'H', 'Dx', 'Dy', 'D', 'nFH', 'nFD');
end
    
% SAVE DATA

converge = false;
while (true)
    
    f2 = fSubproblem(mu, ro_r, g, y, u, H, D, nFH, nFD);
    
    converge = true;
    if (converge)
        break
    end
end
