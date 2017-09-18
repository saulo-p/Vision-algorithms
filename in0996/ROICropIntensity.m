function Iroi = ROICropIntensity(I, lvl)
%Receives image and target intensity level, returns smallest image that
%contains the whole region.
Roi = I == lvl;
f = find(Roi);

%MATLAB is column major
% xs = floor(f/size(I, 1));
% ys = mod(f, size(I, 1));
[xs, ys] = ind2sub(size(I), f);

Iroi = Roi(min(xs):max(xs), min(ys):max(ys));
% imshow(Iroi);

end

