function [fronts, contours] = FindContours(im_bw_lr, background_idx, window_size)
%TODO:
back_len = length(background_idx);

for i = 1:2
    fronts{i} = zeros(1, length(background_idx));
end

%>Determine frontier pixels of each image (left/right)
for j = 1:back_len
    aux = 0;
    maxim = max(find(im_bw_lr{1}(background_idx(j),:)));
    if (maxim)
        fronts{1}(j) = maxim;
        aux = maxim;
    else
        fronts{1}(j) = aux;
    end
end
for j = 1:back_len
    aux = size(im_bw_lr{1}, 2);
    minim = min(find(im_bw_lr{2}(background_idx(j),:)));
    if (minim)
        fronts{2}(j) = minim;
        aux = minim;
    else
        fronts{2}(j) = aux;
    end
end

%>Find baselines (based on min/max window)
contours{1} = movmax(fronts{1}, window_size);
contours{2} = movmin(fronts{2}, window_size);

% %>Smooth baselines
% for i = 1:2
%     contours{i} = conv(contours{i}, ones(1, 20)/20, 'same');
% end


end

