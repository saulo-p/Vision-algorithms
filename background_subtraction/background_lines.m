%% =======================================================================
% Detection by background model
% TODO:
% - Modularize this script
% - Criar funcao para identificar porcao vertical do padrao
%
% Created: 9/11/2017
% Author: Saulo P.
% ========================================================================
clear all;
close all;

%% Setup
% Input data
% im = im2double(rgb2gray(imread('./anteparo_pat/img_2.png')));
im = im2double(imread('./anteparo_pat/img_36.png'));
im_sz = size(im);

%>Parameters:
% LPF
gaussian_size = 7;
gaussian_sigma = 0.8;
% Binarization
bin_th = 0.25;
% Morphological operations
len = 7;
% Gap
gap_th = 10;
% Max window
window_size = 160; %pixels

%% Main code

%>Filters
L = fspecial('gaussian', gaussian_size, gaussian_sigma);
H = fspecial('sobel');

%>LPF:
% imf = imfilter(im, L);
imf = im;

% %TEST: 4 direction filters
% figure;
% subplot(2,2,1); imshow(imfilter(imf,H)); subplot(2,2,2); imshow(imfilter(imf,H'));
% subplot(2,2,3); imshow(imfilter(imf,-H)); subplot(2,2,4); imshow(imfilter(imf,-H'));

%>HPF: Combines Sobel filters in each direction and performs threshold
% binarization. TODO: binarize by bw percentage.
imb = imfilter(imf, H) > bin_th  | imfilter(imf, H') > bin_th | ...
      imfilter(imf, -H) > bin_th | imfilter(imf, -H') > bin_th;

%>Erosions
%Line erosions
% steL1 = strel('line',len,45);
% steL2 = strel('line',len,-45);
% imbe = imerode(imb,steL1) | imerode(imb,steL2);

%% Vertical Gap: (conservative approximation)

%>Find approximate vertical gap
v_ws = sum(imb, 1);
[~, gap_idx] = find(v_ws < gap_th);

%TEST: Approximate gap plot
figure; imshow(im + 0.5*imb); hold on;
plot([gap_idx(1) gap_idx(1)], [0 im_sz(1)], 'g');
plot([gap_idx(end) gap_idx(end)], [0 im_sz(1)], 'g');

%% Find frontiers

%>Separates image (left/right) based on approximate gap
gap_sz = gap_idx(end) - gap_idx(1);
imbs{1} = imb;
imbs{1}(:,gap_idx(end-floor(gap_sz/2)):end) = 0;
imbs{2} = imb;
imbs{2}(:, 1:gap_idx(1+floor(gap_sz/2))) = 0;

%>Determine frontier pixels of each image (left/right)
for i = 1:2
    front{i} = zeros(1, size(imbs{i},1));
end
for j = 1:size(imbs{1},1)
    maxim = max(find(imbs{1}(j,:)));
    if (maxim)
        front{1}(j) = maxim;
    else
        front{1}(j) = front{1}(j-1);
    end
    %     front{1}(j) = max(find(imbs{1}(j,:)));

end
for j = 1:size(imbs{2},1)
    minim = min(find(imbs{2}(j,:)));
    if (minim)
        front{2}(j) = minim;
    else
        front{2}(j) = front{2}(j-1);
    end
%     front{2}(j) = min(find(imbs{2}(j,:)));
end

%>Find baselines (based on min/max window)
baselines{1} = movmax(front{1}, window_size);
baselines{2} = movmin(front{2}, window_size);

%>Smooth baselines
for i = 1:2
    baselines{i} = conv(baselines{i}, ones(1, window_size/2)/(window_size/2), 'same');
end

%TEST: Estimated object contour
figure; imshow(im); hold on;
for i = 1:2
    scatter(front{i}, 1:length(front{i}),'b.');
end
plot(baselines{1}, 1:length(baselines{1}),'g', 'LineWidth',2);
plot(baselines{2}, 1:length(baselines{2}),'g', 'LineWidth',2);


%% Reconstruction

%> Pairs of points
 %TODO: encontrar valores utilizando a mesma janela vertical do padrao.
v1 = 490;
v2 = 750;
d1 = [baselines{1}(v1) baselines{2}(v1)];
d2 = [baselines{1}(v2) baselines{2}(v2)];

load camera

%> Reconstruction (poor version)
Z1 = 20e-2*K(1)/(d1(2) - d1(1));
Z2 = 20e-2*K(1)/(d2(2) - d2(1));
Y1 = Z1*(v1 - 512)/K(2,2);
Y2 = Z2*(v2 - 512)/K(2,2);
%> Scene

figure;
scatter3(0,0,0);
hold on;
scatter3(0, Y1, Z1, '.r');
scatter3(0, Y2, Z2, '.r');

N = 200
thetas = linspace(0, 360, N)
Xs = 20e-2*cosd(thetas);
Zs = 20e-2*sind(thetas);
scatter3(Xs, Y1*ones(1,N), Z1 + Zs, '.b');
scatter3(Xs, Y2*ones(1,N), Z2 + Zs, '.b');
set(gca, 'dataaspectratio', [1 1 1]);

% point = [0 (Y1 - Y2)/2 (Z1 - Z2)/2];
% vector = point - [0 Y1 Z1];
% scatter3(point(1), point(2), point(3), '.g');
% plot3([0 0], [(Y1 - Y2)/2  Y1], [(Z1 - Z2)/2  Z1], 'g');
%% Find baselines equations

% %>Create baselines image
%     im_fronts = zeros(im_sz);
% for i = 1:length(baselines{1})
%     im_fronts(sub2ind(im_sz, i, round(baselines{1}(i)))) = 1;
%     im_fronts(sub2ind(im_sz, i, round(baselines{2}(i)))) = 1;
% end
% % figure; imshow(im_fronts);
% 
% %>Hough line detection
% [H, tta, rho] = hough(im_fronts, 'Theta', -15:1:15);
% % figure;
% % imshow(H,[],'XData',tta,'YData',rho,...
% %             'InitialMagnification','fit');
% % xlabel('\theta'), ylabel('\rho');
% % axis on, axis normal, hold on;
% peaks = houghpeaks(H, 2);
% x = tta(peaks(:,2)); y = rho(peaks(:,1));
% % plot(x,y,'s','color','white');
% 
% %>Line equations (Hough coordinates)
% lines{1} = tta(peaks(:,2));
% lines{2} = rho(peaks(:,1));
% %TEST: Plot hough lines (converting to cartesian)
% figure;imshow(im);hold on;
% for i = 1:2
%     A = [y(i)/cosd(x(i))  y(i)/cosd(x(i)) - im_sz(1)*(sind(x(i))/cosd(x(i)))];
%     B = [1 im_sz(1)];
%     plot(A, B, 'g');
% end



