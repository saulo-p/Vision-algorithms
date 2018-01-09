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

%>Pre processing and binarization
imb = PatternBinarization(im, gaussian_size, gaussian_sigma, bin_th);

%> Find ROI (pattern and cylinder)
[backg_idxs, gap_idxs] = FindCylinderROI(imb, gap_th);

%Remove undesired information.
imb(1:backg_idxs,:) = 0;
imb(backg_idxs(end):end,:) = 0;
imb(:, gap_idxs) = 0;

% % TEST: ROI
% figure; imshow(im + 0.5*imb); hold on;
% plot([gap_idxs(1) gap_idxs(1)], [0 im_sz(1)], 'g');
% plot([gap_idxs(end) gap_idxs(end)], [0 im_sz(1)], 'g');
% plot([0 im_sz(2)], [backg_idxs(1) backg_idxs(1)] , 'g');
% plot([0 im_sz(2)], [backg_idxs(end) backg_idxs(end)], 'g');


%% Find frontiers

%>Separates image (left/right) based on approximate gap
gap_sz = gap_idxs(end) - gap_idxs(1);
imbs{1} = imb;
imbs{1}(:,gap_idxs(end-floor(gap_sz/2)):end) = 0;
imbs{2} = imb;
imbs{2}(:, 1:gap_idxs(1+floor(gap_sz/2))) = 0;

%>Determine frontier pixels of each image (left/right)
for i = 1:2
    front{i} = zeros(1, size(imbs{i},1));
end
for j = 1:size(imbs{1},1)
    aux = 0;
    maxim = max(find(imbs{1}(j,:)));
    if (maxim)
        front{1}(j) = maxim;
        aux = maxim;
    else
        front{1}(j) = aux;
    end
    %     front{1}(j) = max(find(imbs{1}(j,:)));
end
for j = 1:size(imbs{2},1)
    aux = 1280;
    minim = min(find(imbs{2}(j,:)));
    if (minim)
        front{2}(j) = minim;
        aux = minim;
    else
        front{2}(j) = aux;
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



