function [lbI, num_regions] = ConnectedRegions(bwI)
%Receives a bw image and returns image with connected regions specified.
% For each region assigns a specific value for the pixels that belong to 
% that region. *Values that are equal to background (black)
% are not considered.
% 8-connectivity is used.
% TODO: Acelerar o processo de busca.

bw_sz = size(bwI);
lbI = zeros(bw_sz);

% Search loop:
label = 1;
search_idx = [2 2];
% search_lifo = [];
while (search_idx ~= bw_sz)
    if( lbI(search_idx(1), search_idx(2)) == 0 && bwI(search_idx(1), search_idx(2)) ~= 0 )
        search_lifo = search_idx;
        
        while(~isempty(search_lifo))
            %remove head
            head = search_lifo(1,:);
            search_lifo(1,:) = [];

            if ( lbI(head(1),head(2)) ~= 0)
                continue
            end
            lbI(head(1),head(2)) = label;
            
            % Debug por padrão de busca:
%             imshow(lbI, []);
%             drawnow
            
            %add new nodes from same region
            neighborhood_8 = [-1 1;0 1;1 1;1 0;1 -1;0 -1;-1 -1];
            for i = 1:length(neighborhood_8)
                head_n = head + neighborhood_8(i,:);
                
                if (bwI(head_n(1), head_n(2)) == bwI(head(1), head(2)))
                %if the pixels are part of same region
%                  if( isempty(search_lifo) || ...
%                      ~sum(ismember(search_lifo, head_n, 'rows')))
                    search_lifo = [head_n; search_lifo];
%                  end
                end
            end

        end
        label = label + 1;
    end
    % Proceeds image coverage
    search_idx = search_idx + [1 0];
    if (search_idx(1) >= bw_sz(1))
        search_idx = [2 search_idx(2) + 1];
    end

%     search_idx
end

num_regions = label - 1;
end

