function [up_approx_matrix,weight] = Cal_upAppr(rel_mat1, rel_mat2, N, epsilon)
    up_approx_matrix = zeros(N, N);

for i = 1:N
    minMatrix = min(repmat(rel_mat1(i, :), N, 1), rel_mat2);
    
    up_approx_matrix(i, :) = max(minMatrix, [], 2)';
    
end
    entropy = -sum(up_approx_matrix(:) .* log(up_approx_matrix(:) + epsilon) + ...
        (1 - up_approx_matrix(:)) .* log(1 - up_approx_matrix(:) + epsilon));
    
    weight = 1 / (entropy + epsilon);
end

