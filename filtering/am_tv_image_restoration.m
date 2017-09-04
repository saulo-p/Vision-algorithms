%% ========================================================================
% An Augmented Lagrangian Method for Total Variation Video Restoration
%
% TODO:
%   * Make use of sparse matrix
%   * Less memory use during execution 
% Author (code): Saulo P.
% Date Created: 01/09/17
% =========================================================================
clear all;
close all; 
%% Script (Algorithm 1)

%% Initial setup 

%Input data (image and blur kernel):
im = im2double(rgb2gray(imread('lena.bmp')));
h = fspecial('gaussian');

% image size
im = im(200:349, 200:349);
im_sz = size(im);

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
g = conv2(im, h, 'same');
g = imnoise(g, 'salt & pepper', 0.01);
% imshow(g);

% Image linearizations
f_truth = reshape(im, im_sz(1)*im_sz(2), 1);
g = reshape(g, size(g, 1)*size(g, 2), 1);

% Pre-computed matrices
Dx = OperatorFromKernel(dx, im_sz, 0);
Dy = OperatorFromKernel(dy, im_sz, 0);
FDx = fft2(Dx);
FDy = fft2(Dy);
FH = fft2(OperatorFromKernel(h, im_sz, 0));

%% Algorithm initializations:
f = g;
u = (Dx + Dy)*f_truth; 

imshow(reshape(u, im_sz(1), im_sz(2)));
