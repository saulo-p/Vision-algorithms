%% Feature Detector:
% Basic auto-correlation-based keypoint detector (Szeliski's Algorithm 4.1)
% Implementted for study purposes.
%
% Author:   Saulo Pereira
% Date:     03/04/17
clear all;

%TODO:
% * Entender o papel dos eigenvalues na computação da feature.

%% Code:
I = rgb2gray(imread('pessoa_09685178461.jpg'));

% Harris detector (1988)
Ix = imfilter(I, -[-2 -1 0 1 2]);
Iy = imfilter(I, -[-2 -1 0 1 2]');
figure;
subplot(3,1,1)
imshow(Ix)
subplot(3,1,2)
imshow(Iy)
subplot(3,1,3)
imshow(Ix + Iy)

% Reason about the gauss thing
% Normalization for the eigen computation
Ix2 = double(imgaussfilt(Ix.*Ix,5))/255;
IxIy = double(imgaussfilt(Ix.*Iy,5))/255;
Iy2 = double(imgaussfilt(Iy.*Iy,5))/255;

% Iterate over each element to compute A
F = zeros(size(I));
for i = 1:size(I,1)
    for j = 1:size(I,2)
        A = [Ix2(i,j) IxIy(i,j);
             IxIy(i,j) Iy2(i,j)];
         
        e = eig(A);
        % Triggs (2004)
        F(i,j) = e(1) - 0.05*e(2);
    end 
end

%% Find the local maxima
hlm = vision.LocalMaximaFinder(500,[15 15]);
set(hlm,'Threshold',0.5*max(max(F)));
coord = step(hlm,F);

%% Results
figure;
imshow(I)
hold on;
scatter(coord(:,1),coord(:,2))

figure;
surf(F)

%% Comparisons:
points = detectSURFFeatures(I);    
[features, points] = extractFeatures(I, points);

figure;
imshow(I)
hold on;
scatter(points.Location(:,1), points.Location(:,2));

%% Resultados interessantes: 
% 1. Os pontos escolhidos são similares quando se alteram as direções dos
%    gradientes.
% 2. Vale testar qual o efeito da ordem do gradiente.
% 3. SURF retorna resultados bem diferentes do extrator implementado acima.


%% Compute auto-correlation (patch 5) over all the image to show surface
% This provides a visual metric of the correctness of the result above.
