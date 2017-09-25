%% ========================================================
% [IN0996] Visão Computacional - Projeto 1
%  Questão 1
%
% References:
% https://www.mathworks.com/help/images/ref/normxcorr2.html
% https://www.mathworks.com/help/images/ref/bwconncomp.html
%
%
% Aluno: Saulo Pereira (scrps@cin.ufpe.br)
% =========================================================
close all;
% clear all;

%% Input data
im_temp = imread('./data/parafuso_porca.bmp');
im_target = imread('./data/objetos.bmp');

%% Template Segmentation
% uniform background allows for trivial binarization.
th = median(median(im_temp)) - 10;

bw_temp = ThresholdBinarization(im_temp, th);
% imshow(bw_temp);

templates = ProjectionSegmentation(bw_temp, 2);

clear im_temp;
%% Target binarization
th = median(median(im_target)) - 15;
bw_target = ThresholdBinarization(im_target, th);

% clear im_target;
%% Correlation-based Template Matching

scales = [0.8 0.9 1 1.1 1.2];
rotations = [-30 -20 -10 0 10 20 30];

% Generate rotated and scaled versions of the templates (FUNCTION!)
for t = 1:length(templates)
    temp_idx = 1;
    im = cell2mat(templates(t));
    for s = scales
        for r = rotations
            ims = imresize(im, s);
            imsr = imrotate(ims, r);
            imsr = ROICropIntensity(imsr, 1);
%             imshow(imsr);
            
            inv_templates{t,temp_idx} = imsr;
            temp_idx = temp_idx + 1;
        end
    end
end
% clear im ims imsr temp_idx scales rotations;

centers{1} = []; centers{2} = [];
for i = 1:size(inv_templates, 1)
    for j = 1:size(inv_templates, 2)
        im = cell2mat(inv_templates(i, j));
        C = normxcorr2(im, bw_target);

%         subplot(2,1,1); imshow(im); subplot(2,1,2); mesh(C);

        if (max(max(C)) >= 0.8)
    %         maxima = FindLocalMaxima(C, 10);
            hlm = vision.LocalMaximaFinder(10,[9 9]);
            set(hlm,'Threshold',0.8);
            coord = step(hlm,C);
            
            coord = coord - uint32(repmat([size(im, 2) size(im, 1)]/2, size(coord, 1), 1));
            centers{i} = [coord; centers{i}];
        end
    end
end

num_porcas = CountClusters(centers{1}', 10)
num_parafusos = CountClusters(centers{2}', 30)


imshow(im_target);
hold on;
% there is an implicit double inversion 
loci1 = centers{1};
loci2 = centers{2};
scatter(loci1(:,1), loci1(:,2));
scatter(loci2(:,1), loci2(:,2));

%% Target image segmentation
% th = median(median(im_target)) - 15;
% bw_target = ThresholdBinarization(im_target, th);
% % imshow(bw_target);
% 
% % Warning: Call to ConnectedRegions takes a couple of minutes to run.
% % [crI, num_regions] = ConnectedRegions(bw_target);
% load crI;
% 
% % remove regions that are not relevant
% for i = unique(crI)'
%     roi = (crI == i);
%     if ( sum(sum(roi)) < 500 )
%         crI = crI - i*roi;
%         unique(crI)
%     end
% end
% figure;
% imshow(crI, []);
% 
% lvls = unique(crI)';
% lvls = lvls(lvls ~= 0);
% 
% seg_idx = 1;
% for i = lvls
%     segs{seg_idx} = ROICropIntensity(crI, i);
%     seg_idx = seg_idx + 1;
% end
% 
% clear im_target;

