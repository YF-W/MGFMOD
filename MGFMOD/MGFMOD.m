function outlier_score = MGFMOD(XS,G)

M = numel(XS);
N = size(XS{1}, 2);
fuzz_sim = cell(1, length(G)); 
appr_ind = cell(M, 1);
we_mat = cell(M, 2);
epsilon = 1e-9;
ne_probs = cell(M, 1);
ne_prob = cell(M, 3);
AOS = zeros(N,M);
    
for i = 1:M
   fuzz_sim{i} = Cal_Sim(XS{i}, G);
   matrices = fuzz_sim{i}; 
   we_sm = zeros(N, N);
   tota_we = 0;
        
   num_g = length(G);
   for j = num_g:-1:2
      for k = j-1:-1:1
          [up_appr, we] = Cal_upAppr(matrices{j}, matrices{k}, N, epsilon);
          we_sm = we_sm + we * up_appr;
          tota_we = tota_we + we;
      end
   end
   we_mat{i, 1} = we_sm / tota_we;
end

s_up_appr = zeros(N, M);

for i = 1:M
    s_up_appr(:, i) = sum(we_mat{i,1}, 2);
end

for col = 1:size(s_up_appr, 2)
    column_data = s_up_appr(:, col);
    normalized_data = (column_data - min(column_data)) / (max(column_data) - min(column_data));
    
    processed_data = 1 - normalized_data;
    AOS(:, col) = processed_data;
end
logic_matrix = zeros(size(AOS));
if any(s_up_appr == 1, 'all')
    [rowIdx, colIdx] = find(s_up_appr == 1);
    re = unique(rowIdx);
    for idx = 1:length(rowIdx)
        logic_matrix(rowIdx(idx), colIdx(idx)) = 1;
    end
else
    threshold = 0.95;
    [rowIdx, colIdx] = find(AOS > threshold);
    
    if ~isempty(rowIdx)
        re = unique(rowIdx);
        for idx = 1:length(rowIdx)
            logic_matrix(rowIdx(idx), colIdx(idx)) = 1;
        end
    end
end

for view_idx = 1:size(logic_matrix, 2)
    cur_mat = we_mat{view_idx};
    for instance_idx = 1:size(logic_matrix, 1)
        if logic_matrix(instance_idx, view_idx) == 1
            if instance_idx <= size(cur_mat, 1)
                cur_mat(instance_idx, :) = 0;
            end
        end
    end
    we_mat{view_idx} = cur_mat;
                
end                
for i = 1:length(we_mat)
    cur_mat = we_mat{i}; 
    
    for k = 1:min(size(cur_mat))
        cur_mat(k, k) = 0;
    end
    we_mat{i} = cur_mat;
end                

for v = 1:M
    cur_mat = we_mat{v};
    [rows, cols] = size(cur_mat);
    prob_1 = zeros(rows, cols);
    prob_2 = zeros(rows, cols);
    prob_3 = zeros(rows, cols);

    for i = 1:rows
        thresh_95 = prctile(cur_mat(i, :), 95);
        thresh_90 = prctile(cur_mat(i, :), 90);
        thresh_85 = prctile(cur_mat(i, :), 85); 

         if all(cur_mat(i, :) == 0)
                prob_1(i, :) = 0;
                prob_2(i, :) = 0;
                prob_3(i, :) = 0;
                continue;
         end 

        for j = 1:cols
            if cur_mat(i, j) >= thresh_95
                prob_1(i, j) = 1 / (N *(1 - 0.95));
            end
            if cur_mat(i, j) >= thresh_90
                prob_2(i, j) = 1 / (N*(1 - 0.90));
            end
            if cur_mat(i, j) >= thresh_85
                prob_3(i, j) = 1 /( N*(1 - 0.85));
            end
        end
    end
    ne_prob{v, 1} = prob_1;
    ne_prob{v, 2} = prob_2;
    ne_prob{v, 3} = prob_3;

    ne_probs{v} = prob_1 + prob_2 + prob_3;
end
jss = JS(N, M, ne_probs);
    
 for i = 1:M
    cur = we_mat{i,1};
    appr_ind_a = cell(size(cur, 1), 1);
    for row = 1:size(cur, 1)
        threshold = prctile(cur(row, :), 60);
        cur_ind = [];
        for col = 1:size(cur, 2)
            if cur(row, col) > threshold
                cur_ind = [cur_ind, col];
            end
        end
        appr_ind_a{row} = unique(cur_ind);
    end
    appr_ind{i} = appr_ind_a;  
end
jd = jaccard(appr_ind);
outlier_score = jd + log(1 + jss);
outlier_score = min_max_normalize(outlier_score);
outlier_score(re) = 1; 
end 




