%% =======================================================================
% Reconstruction of cylinder from structured background
%
% Created: 9/11/2017
% Author: Saulo P.
% ========================================================================
clear all;
close all;

%% Reconstruction

load contours
load camera

Npoints = length(backg_idxs);

% Real world data
D = 20e-2;

%> 2D data
ys = backg_idxs';
ds = [contours{1};
      contours{2}];
xs = (ds(2,:) - ds(1,:))/2;

%>Reconstruction of cylinder central axis (diameter approximation)
Zs = D*K(1)./(ds(2,:) - ds(1,:));
Cs = [Zs.*(xs - im_sz(1)/2)/K(2,2);
      Zs.*(ys - im_sz(2)/2)/K(2,2);
      Zs];

centr = mean(Cs, 2);
Csn = Cs - repmat(centr, 1, Npoints);

%>Least Squares solution
[U, S, V] = svd(Csn');
normal = V(:,end);

sqrt(sum(((Csn'*normal).^2)/Npoints))

% Zs = D*K(1)./(ds(2,:) - ds(1,:));
% Ys = Zs.*(ys - 512)/K(2,2);
% Xs = zeros(1, Npoints); %considers that cylinder is vertical on image


%% Reconstructed scene synthesis
figure;
scatter3(0,0,0);
hold on;
scatter3(Xs, Ys, Zs, '.r');

N = 100;
thetas = linspace(0, 360, N);
Xcyl = 20e-2*cosd(thetas);
Zcyl = 20e-2*sind(thetas);
for i = 1:Npoints
    scatter3(Xcyl, Ys(i)*ones(1,N), Zs(i) + Zcyl, '.b');
end
set(gca, 'dataaspectratio', [1 1 1]);

%> Versao atual esta incorreta, considera X fixo. O correto e reconstruir a
%nuvem de pontos 