%%========================================================================
% Frequency domain image filtering experiments:
% - Frequency domain is different from the spatial domain (based on
% kernels) because it is not a local filtering process.
% - Works directly with 

% Author : Saulo P.
%=========================================================================
%% Transform template
clear all;
close all;

% Input image
im = rgb2gray(imread('lena.bmp'));
figure, imshow(im);

% Transform and 
F = fft2(im);
F = fftshift(F);
mF = abs(F);
pF = angle(F);

% Show the transform results
 %log provides better scaling for the image exhibition
subplot(2, 1, 1);
fftshow(mF, 'log');
subplot(2, 1, 2);
fftshow(pF, 'abs');

% Inverse transform
imI = ifft2(mF.*exp(1i*pF));
figure, imshow(abs(imI), []);

% Attention to the conversions involved in this procedure.
 %to avoid problems work with the [0, 1] scale.
norm(im2double(im) - abs(imI)/255)

%% Filtering example
clear all;
close all;

% Input image
im = rgb2gray(imread('lena.bmp'));

% LPF:
butterworthbpf(im, 1, 50, 4);

% HPF:
butterworthbpf(im, 100, Inf, 4);