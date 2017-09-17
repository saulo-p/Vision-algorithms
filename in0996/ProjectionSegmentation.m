function [subIs, error] = ProjectionSegmentation(I, num_blocks)
%Receives image and number of expected separations on first step and
%returns the set of segmented images.
%TODO: generalizar para mais objetos
im_sz = size(I);

proj_v = sum(I, 1);
proj_h = sum(I, 2);

%TODO: robustificar com filtro passa-baixa nos sinais 1D (imagens com
%ruido)
find_v = find(proj_v);
find_h = find(proj_h);

dv = find_v(2:end) - find_v(1:end-1) - 1;
dh = find_h(2:end) - find_h(1:end-1) - 1;

% TODO: Generalizar
objs = zeros(4, 2);
if ( xor(sum(dv), sum(dh)) )
    if (sum(dv))
        [~, idx_v] = find(dv);
        
        % Vetorizar o tratamento
        objs(1,1) = find_v(1);
        objs(2,1) = find_v(idx_v);
        objs(1,2) = find_v(idx_v) + dv(idx_v);
        objs(2,2) = find_v(end);

        % Lembrar: orientacao (x,y) difere de (linhas, colunas)
        subIs = {I(1:im_sz(1),objs(1,1):objs(2,1)),
                 I(1:im_sz(1),objs(1,2):objs(2,2))};
        
        for i = 1:length(subIs)
            subI = cell2mat(subIs(i));
            sub_sz = size(subI);
            
            proj_h = sum(subI, 2);
            find_h = find(proj_h);
            %subIs recebe os templates dos objetos
            subIs{i} = subI(find_h, 1:sub_sz(2));
        end        
        
%         figure;
%         subplot(1,2,1);
%         imshow(cell2mat(subIs(1)));
%         subplot(1,2,2);
%         imshow(cell2mat(subIs(2)));
    else
    %TODO        
%         [~, idx_h] = find(dh);
    end
else
    error = true;
    subIs = {};
end

end

