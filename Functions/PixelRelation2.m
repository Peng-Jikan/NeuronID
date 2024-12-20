function [SubBlock_Location, k] = PixelRelation2(SubBlock_Signal, SubBlock_Location)

    mat = []; k = 1;
    for i = 1:1
        signal1 = SubBlock_Signal(i, :)';
        for j = i+1:size(SubBlock_Signal, 1)
            signal2 = SubBlock_Signal(j, :)';
            signal(:, 1) = signal1 + signal2;
            signal(:, 2) = abs(signal1 - signal2);

            [x, ~] = find(signal(:, 1) > 0); Total_num = size(x, 1);
            [x, ~] = find(signal(:, 1) > 0 & signal(:, 2) == 0); Same_num = size(x, 1);

            r = Same_num / Total_num;
            if r >= 0.5
                mat(k, 1) = i; mat(k, 2) = j;
                k = k + 1;
            end
        end
    end

    k = 1;
    if ~isempty(mat)
        mat = gather(mat); % 将数据传回CPU以便使用merge_similar_rows
        groups = merge_similar_rows(mat);
        if ~isempty(groups)
            for i = 1:size(groups, 1)
                A = groups{i}; A = A(:); A = unique(A);
                if size(A, 1) >= 3
                    SubBlock_Location(A, 3) = k;
                    k = k + 1;
                end
            end
        end
    end

    % 将结果传回CPU
    SubBlock_Location = gather(SubBlock_Location);
end
