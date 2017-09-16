function [Is, error] = ProjectionSegmentation(I, num_blocks)
%Receives image and number of expected separations on first step and
%returns the set of segmented images.

%TODO: generalizar para mais objetos

proj_v = sum(I, 1);
proj_h = sum(I, 2);

%TODO: robustificar com filtro passa-baixa nos sinais 1D (imagens com
%ruido)
find_v = find(proj_v);
find_h = find(proj_h);

dv = find_v(2:end) - find_v(1:end-1) - 1;
dh = find_h(2:end) - find_h(1:end-1) - 1;

%
if ( xor(sum(dv), sum(dh)) )
    if (sum(dv))
        [~, idx_v] = find(dv);
        
        ob1_l = find_v(1);
        ob1_r = find_v(idx_v);
        
        ob2_l = find_v(idx_v) + dv(idx_v);
        ob2_r = find_v(end);
    else
        [~, idx_h] = find(dh);

    end
else
    error = true;
    Is = [];
end

figure;
imshow(I);
hold on
plot([ob1_l ob1_l], [0 size(I, 1)]);
plot([ob1_r ob1_r], [0 size(I, 1)]);
plot([ob2_l ob2_l], [0 size(I, 1)]);
plot([ob2_r ob2_r], [0 size(I, 1)]);


    end

