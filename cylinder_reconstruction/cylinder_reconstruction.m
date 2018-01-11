%% =======================================================================
% Monocular reconstruction of cylinder of known radius.
%  INPUTS:
%   *Camera intrinsics
%   *Cylinder contours 
%   *Cylinder radius
%
%  OUTPUTS:
%   *Cylinder axis parametric equation
%
% Created: 09/01/2018
% Author: Saulo P.
% ========================================================================
clear all;
close all;

%% Input data

load contours
load camera

Npoints = length(backg_idxs);

% Real world data
Dmtr = 20e-2;

%> 2D data
ys = backg_idxs';
ds = [contours{1};
      contours{2}];
xs = (ds(2,:) - ds(1,:))/2;

%% Reconstruction

%>Reconstruction of cylinder central axis (diameter approximation)
Z = Dmtr*K(1)./(ds(2,:) - ds(1,:));
Cs = [Z.*(xs - im_sz(1)/2)/K(2,2);
      Z.*(ys - im_sz(2)/2)/K(2,2);
      Z];

centr = mean(Cs, 2);
Csn = Cs - repmat(centr, 1, Npoints);

%>Least Squares solution
[~, ~, V] = svd(Csn');
direct = V(:,1);

RMS = sqrt(sum(((Csn'*direct).^2)/Npoints))

%% Reconstructed scene synthesis
figure;
scatter3(0,0,0, 'filled');
hold on;
scatter3(Cs(1,:), Cs(2,:), Cs(3,:), '.r');

%>Fitted line
line = [centr - 0.2*direct centr + 0.2*direct];
plot3(line(1,:), line(2,:), line(3,:), 'g');

[Xc, Yc, Zc] = cylinder2(Dmtr*[1 1], direct);
Xc = Xc + centr(1);
Yc = Yc + centr(2);
Zc = Zc + centr(3);
surf(Xc, Yc, Zc);
[Xc, Yc, Zc] = cylinder2(Dmtr*[1 1], -direct);
Xc = Xc + centr(1);
Yc = Yc + centr(2);
Zc = Zc + centr(3);
surf(Xc, Yc, Zc);
colormap([0  0  1]);
set(gca, 'dataaspectratio', [1 1 1]);