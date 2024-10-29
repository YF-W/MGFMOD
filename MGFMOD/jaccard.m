function jaccard_averages = jaccard(approx_obj_indices)
    M = numel(approx_obj_indices); 
    n = size(approx_obj_indices{1}, 1); 
    jaccard_averages = zeros(n, 1); 


    for i = 1:n
        distances = [];
       
        for j = 1:M-1
            for k = j+1:M
                neighbors_view_j = approx_obj_indices{j}{i};
                neighbors_view_k = approx_obj_indices{k}{i};
                
                union_set = union(neighbors_view_j, neighbors_view_k);
                intersect_set = intersect(neighbors_view_j, neighbors_view_k);
                
                if ~isempty(union_set) 
                    jaccard_distance = 1 - length(intersect_set) / length(union_set);
                    distances = [distances, jaccard_distance]; 
                end
            end
        end

        if ~isempty(distances)
            jaccard_averages(i) = mean(distances, 'omitnan');
        else
            jaccard_averages(i) = NaN; 
        end
    end
end

