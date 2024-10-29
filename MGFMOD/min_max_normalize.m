function normalized_data = min_max_normalize(data)
    data_to_normalize = data(data ~= 1); 
    min_val = min(data_to_normalize);
    max_val = max(data_to_normalize);
    
    normalized_data = zeros(size(data));
    normalized_data(data ~= 1) = (data_to_normalize - min_val) / (max_val - min_val);
    normalized_data(data == 1) = 1;
end

