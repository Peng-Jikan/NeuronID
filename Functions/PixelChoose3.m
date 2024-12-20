function [SubBlock_Signal, SubBlock_Location] = PixelChoose3(TSNEProjection, i, Potential_Location, memMap, Diff_Projection, dataSize)

    % 计算距离
    target = TSNEProjection(i, :);
    distance = pdist2(TSNEProjection, target);
    distance(:, 2) = (1:1:size(distance, 1))';
    distance = sortrows(distance, 1);
    distance = distance(1:2000, :);

    Location = Potential_Location(distance(:, 2), 1:2);

    % 初始化区域
    region = Diff_Projection .* 0;
    for ii = 1:size(Location, 1)
        region(Location(ii, 1), Location(ii, 2)) = 1;
    end

    % 标记区域
    [LabelImage, numRegions] = bwlabel(gather(region));
    LabelImage = gpuArray(LabelImage); % 将结果重新传回GPU

    if numRegions > 1
        A = LabelImage(Potential_Location(i, 1), Potential_Location(i, 2));
        LabelImage(LabelImage > A) = 0;
        LabelImage(LabelImage < A) = 0;
        LabelImage(LabelImage == A) = 1;
    end

    [rows, cols] = size(LabelImage);
    [colIdx, rowIdx] = meshgrid(1:cols, 1:rows);
    rowIdx = rowIdx(:);
    colIdx = colIdx(:);
    values = LabelImage(:);
    newMatrix = [rowIdx, colIdx, values];

    [x, ~] = find(newMatrix(:, 3) == 1);
    SubBlock_Location_Raw = newMatrix(x, 1:2);
    Raw_Location = Potential_Location(i, 1:2);
    [x, ~] = find(SubBlock_Location_Raw(:, 1) == Potential_Location(i, 1) & SubBlock_Location_Raw(:, 2) == Potential_Location(i, 2));
    SubBlock_Location_Raw(x, :) = [];
    SubBlock_Location_Raw = [Raw_Location; SubBlock_Location_Raw];

    positions = find_row_positions(gather(Potential_Location(:, 1:2)), gather(SubBlock_Location_Raw));
    positions = gpuArray(positions); % 将结果重新传回GPU

    SubBlock_Location = Potential_Location(positions, 1:4);
    SubBlock_Signal = memMap.Data.Feature(positions, 1:dataSize(1, 2));

    [x, ~] = find(SubBlock_Location(:, 4) == 0);
    SubBlock_Signal = SubBlock_Signal(x, :);
    SubBlock_Location = SubBlock_Location(x, 1:2);
end


