%% ========================================================================
% The slowest local linear filter (kernel-based).
% - Image is linearized (col by col)
% - Kernel is defined (3x3 at first)
% - Kernel is expanded to toeplitz structure
% - Matrix product generates linearized output
% - Output matrix is created
% TODO:
% - Accelerate by doing the operation in blocks ( > 1 )
% - Create an optmization module for finding best filter for a given noise
%
% Author: Saulo P.
% Date Created: 23/08/17
% =========================================================================
clear all;
close all;
%% Input image

% input image load:
im = rgb2gray(imread('lena.bmp'));
im = im(200:349, 200:349);
im_float = im2double(im);
clear im;

[im_r, im_c] = size(im_float);

% linearization
f = reshape(im_float, im_r*im_c, 1);

%% Kernel

% Kernel (box)
K = 3;
h = (1/K^2)*ones(K);
h = [0 1 0;1 -4 1;0 1 0];

% Toeplitz structure
r = [h(:,1)' zeros(1, im_r - K) h(:,2)' zeros(1, im_r - K) h(:,3)' zeros(1, im_r - K) ...
     zeros(1, (im_c - 3)*im_r)];
 
%% Output image generation
% Since the required toeplitz matrix is too big to be generated (1GB/pixel)

if (max([im_r im_c]) < 200)
    'Toeplitz version'
    c = [h(1,1); zeros(im_r*im_c,1)];
    TP = toeplitz(c,r);
    TP = TP(1:end-1,:);
    
    Hf = TP*f;
else
    'Iterative version'
    Hf = zeros(im_r*im_c, 1);
    for i = 1:(im_r*im_c)
    %     i
        Hf(i) = r*f;

        r = circshift(r,1);
    end
end

%% Output image show

im_out = reshape(Hf, im_r, im_c);
imshow(im_float);
figure, imshow(im_out);