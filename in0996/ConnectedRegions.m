function [lbI, num_regions] = ConnectedRegions(bwI)
%Receives a bw image and return image with descriminated connected regions.
% For each region assigns a specific value for that region (1, 2, 3...)
% 8-connectivity is considered

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
            lbI(head(1),head(2)) = label;
            search_lifo(1,:) = [];
            
            % TEST:
%             imshow(lbI, []);
%             drawnow
            
            %add new nodes from same region
            head_n = head + [-1 1];
            if (bwI(head_n(1), head_n(2)) == bwI(head(1), head(2)) && lbI(head_n(1), head_n(2)) == 0 )
                if(~sum(ismember(search_lifo, head_n, 'rows')))
                    search_lifo = [head_n; search_lifo];
                end
            end
            head_n = head + [0 1];
            if (bwI(head_n(1), head_n(2)) == bwI(head(1), head(2)) && lbI(head_n(1), head_n(2)) == 0 )
                if(~sum(ismember(search_lifo, head_n, 'rows')))
                    search_lifo = [head_n; search_lifo];
                end
            end
            head_n = head + [1 1];
            if (bwI(head_n(1), head_n(2)) == bwI(head(1), head(2)) && lbI(head_n(1), head_n(2)) == 0)
                if(~sum(ismember(search_lifo, head_n, 'rows')))
                    search_lifo = [head_n; search_lifo];
                end
            end
            head_n = head + [1 0];
            if (bwI(head_n(1), head_n(2)) == bwI(head(1), head(2)) && lbI(head_n(1), head_n(2)) == 0)
                if( isempty(search_lifo) || ...
                    ~sum(ismember(search_lifo, head_n, 'rows')))
                    search_lifo = [head_n; search_lifo];
                end
            end
            head_n = head + [1 -1];
            if (bwI(head_n(1), head_n(2)) == bwI(head(1), head(2)) && lbI(head_n(1), head_n(2)) == 0)
                if( isempty(search_lifo) || ...
                    ~sum(ismember(search_lifo, head_n, 'rows')))
                    search_lifo = [head_n; search_lifo];
                end
            end
%             length(search_lifo)
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

num_regions = label;
end

