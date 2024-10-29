function simMatrices = Cal_Sim(data, granularities)
    % input:
    % data
    % granularities

    simMatrices = cell(1, length(granularities));

    for gIndex = 1:length(granularities)
        g = granularities(gIndex);
        data_transposed = data.';

        simMatrix = FuzzySimilarityMatrix(data_transposed, g);
        simMatrices{gIndex} = simMatrix;
    end
end

function simMatrix = FuzzySimilarityMatrix(data, granularity)
    
    
    standardizedData = zscore(data);
    
    D = pdist2(standardizedData, standardizedData);
    
    simMatrix = exp(-granularity * D);
    simMatrix(1:size(data, 1)+1:end) = 1; 
end
