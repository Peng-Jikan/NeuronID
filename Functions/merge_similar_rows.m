function groups = merge_similar_rows(matrix)
    % Get the number of rows
    nRows = size(matrix, 1);

    % Initialize sparse adjacency matrix
    adjMatrix = sparse(nRows, nRows);

    % Build the adjacency matrix using sparse matrix
    h=waitbar(0,'please wait');
    for i = 1:nRows-1
        for j = i+1:nRows
            if ~isempty(intersect(matrix(i,:), matrix(j,:)))
                adjMatrix(i,j) = 1;
                adjMatrix(j,i) = 1;
            end
        end
        str=['分析进度……',num2str(i/nRows*100),'%'];
        waitbar(i/nRows,h,str);
    end
    delete(h);
    

    % Create a graph from the sparse adjacency matrix
    G = graph(adjMatrix);

    % Find the connected components
    bins = conncomp(G);

    % Group rows based on connected components
    uniqueBins = unique(bins);
    groups = cell(length(uniqueBins), 1);
    for i = 1:length(uniqueBins)
        groups{i} = matrix(bins == uniqueBins(i), :);
    end
end
