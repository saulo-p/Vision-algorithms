function [p_ax, v_ax] = ReconstructCylinderExact(contours, backg_idxs, K, im_sz)
% Monocular reconstruction of cylinder of known radius.

len_ = length(backg_idxs);

%Generate 3D points from each image contour.
for i = 1:2
    line{i} = [contours{i} - im_sz(2)/2; backg_idxs' - im_sz(1)/2; K(1)*ones(1,len_)];
end

%Least squares solution:
for i = 1:2
    M = line{i};

    % p0 = mean(M, 2);
    % Mn = M - repmat(p0, 1, len_);

    [~, ~, V] = svd(M');
    pn{i} = [V(:,end); 0];
end
%Correct signal
pn{1} = pn{1}*sign(pn{1}(1));
pn{2} = pn{2}*sign(pn{2}(1))*-1;

%Shift by cylinder radius
pn{1}(4) = -0.1;
pn{2}(4) = -0.1;

%% Axis computation
%http://mathworld.wolfram.com/Plane-PlaneIntersection.html
M = [pn{1}(1:3)'; pn{2}(1:3)'];
bs = [-pn{1}(4); -pn{2}(4)];

p_ax = M \ bs;

[~, ~, V] = svd(M);
v_ax = V(:,end);

%% Results

% figure; scatter3(0,0,0, 'filled'); hold on;
% for i = 1:2
%     scatter3(line{i}(1,:), line{i}(2,:), line{i}(3,:), '.r');
% end
% 
% [x y] = meshgrid(-250:10:250); % Generate x and y data
% for i = 1:2
%     a = pn{i}(1); b = pn{i}(2); c = pn{i}(3); d = pn{i}(4);
%     z = -1/c*(a*x + b*y + d); % Solve for z data
%     surf(x,y,z) %Plot the surface
% end
% 
% scatter3(p_ax(1), p_ax(2), p_ax(3), 'r', 'filled');
% t = [-250 250]';
% vecs = [t(1)*v_ax t(2)*v_ax];
% A = p_ax + vecs;
% plot3(A(1,:), A(2,:), A(3,:), 'r', 'LineWidth', 5);
% xlabel('x'); ylabel('y'); zlabel('z');

end

