function num_clusters = CountClusters(data, distance)
%TODO
data = cast(data, 'double');

num_clusters = 0;
while(true)
    cluster = data(:,1);
    data = data(:,2:end);
    
    i = 1;
    while (i <= length(cluster))
        reference = cluster(:,i);
        
        dists = data - repmat(reference,1,size(data, 2));
        dists = sum(dists.^2); 
        
        cluster = [cluster data(:, dists <= distance)];
        data = data(:, dists > distance);
        i = i + 1;
    end
    
    num_clusters = num_clusters + 1;

    if (isempty(data))
        break;
        
end

end

