function [backg_idxs, gap_idxs] = FindCylinderROI(im_bw, gap_th)
%TODO: change to FindROI
im_sz = size(im_bw);

%>Find background pattern horizontal region.
hor_sums = sum(im_bw, 2);
hor_sums_mm = movmedian(hor_sums, floor(length(hor_sums)/10));
% plot(hor_sums); hold on;
% plot(median(hor_sums)*ones(1, length(hor_sums)));
% plot(hor_sums_mm);
[backg_idxs, ~] = find(hor_sums_mm > median(hor_sums));

%>Find vertical gap (cylinder location)
vert_sums = sum(im_bw(backg_idxs,:), 1);
vert_sums_mm = movmedian(vert_sums, floor(length(vert_sums)/10));
% figure; imshow(im_bw); hold on; plot(vert_sums_mm);
[~, gap_idxs] = find(vert_sums_mm < gap_th);

end

