function js_div_sum = JS(N, M, prob_sum)
    
    col_idx = 1;
    js_div_matrix = zeros(N, M*(M-1)/2);  

    for i = 1:M
        for j = i+1:M
            for obj = 1:N
                P = prob_sum{i}(obj, :);
                Q = prob_sum{j}(obj, :);
                avg_PQ = 0.5 * (P + Q); 
                Dkl_P = sum(P .* log2(P ./ avg_PQ), 'omitnan'); 
                Dkl_Q = sum(Q .* log2(Q ./ avg_PQ), 'omitnan'); 
                Djs = 0.5 * Dkl_P + 0.5 * Dkl_Q;  
                js_div_matrix(obj, col_idx) = Djs; 
            end
            col_idx = col_idx + 1;
        end
    end

    js_div_sum = sum(js_div_matrix, 2);
end


