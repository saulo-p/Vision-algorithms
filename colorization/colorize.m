%%========================================================================
% Experiments on paper "Colorization using Optimization"
% 
% Based on the author's code available at:
% * http://www.cs.huji.ac.il/~yweiss/Colorization/
%
%
% Reminder: mex cmd
%  mex -O getVolColor.cpp fmg.cpp mg.cpp  tensor2d.cpp  tensor3d.cpp
%
% Saulo Pereira
% Created: 18/01/2018
%%========================================================================
clear all;
close all;

%>Paths
g_name= './data/example.bmp';
c_name= './data/example_marked2.bmp';
out_name= './results/example_res2.bmp';

%solver=1: multi-grid solver 
%solver=2: exact matlab "\" solver
solver=2; 

%% Input data

im_g = im2double(imread(g_name));
im_scr = im2double(imread(c_name));

%>Find scribbles mask
scr_mask = (sum(abs(im_g - im_scr), 3) > 0.01);
scr_mask = double(scr_mask);

%% Color space transformation

%>Convert images color space YUV (?).
sgI = rgb2ntsc(im_g);
scI = rgb2ntsc(im_scr);

%Preserves the luminance from the gray original image and color from the
% assigned scribbles
im_ntsc(:,:,1)=sgI(:,:,1);
im_ntsc(:,:,2)=scI(:,:,2);
im_ntsc(:,:,3)=scI(:,:,3);

%% Neighborhood mask:

max_d = floor(log(min(size(im_ntsc,1),size(im_ntsc,2)))/log(2) - 2);

iu = floor(size(im_ntsc,1)/(2^(max_d-1)))*(2^(max_d-1));
ju = floor(size(im_ntsc,2)/(2^(max_d-1)))*(2^(max_d-1));

%>Crop image (and mask) (criteria?)
scr_mask = scr_mask(1:iu,1:ju,:);
im_ntsc = im_ntsc(1:iu,1:ju,:);

%% Color Optimization

if (solver==1)
%   nI = getVolColor(scr_mask,im_ntsc,[],[],[],[],5,1);
%   nI = ntsc2rgb(nI);
else
  nI = getColorExact(scr_mask, im_ntsc);
end

figure; 
subplot(2,1,1); imshow(im_scr);
subplot(2,1,2); imshow(nI);

imwrite(nI,out_name)
