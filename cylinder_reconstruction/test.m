clear all; close all;

load a.mat
len_ = length(backg_idxs);

for i = 1:2
    line{i} = [contours{i} - 640; backg_idxs' - 512; K(1)*ones(1,len_)];
end

figure; scatter3(0,0,0, 'filled'); hold on;
for i = 1:2
    scatter3(line{i}(1,:), line{i}(2,:), line{i}(3,:), '.r');
end

%Least squares solution:
for i = 1:2
    M = line{i};

    % p0 = mean(M, 2);
    % Mn = M - repmat(p0, 1, len_);

    [~, ~, V] = svd(M');
    pn{i} = [V(:,end); 0];
end

pn{1}(4) = 0.2;
pn{2}(4) = -0.2;

[x y] = meshgrid(-250:10:250); % Generate x and y data
for i = 1:2
    a = pn{i}(1); b = pn{i}(2); c = pn{i}(3); d = pn{i}(4);
    z = -1/c*(a*x + b*y + d); % Solve for z data
    surf(x,y,z) %Plot the surface
end

pax = pn{1}