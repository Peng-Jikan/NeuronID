function [Sort_ROI] = Density_Projection(TSNEProjection)
    % 将数据转换为gpuArray
    TSNEProjection = gpuArray(TSNEProjection);

    Sort_ROI = [];
    h = waitbar(0, 'please wait');

    for i = 1:size(TSNEProjection, 1)
        Target_i = TSNEProjection(i, 1);
        Target_j = TSNEProjection(i, 2);

        % 在GPU上进行查找操作
        x = find(TSNEProjection(:, 1) >= (Target_i - 0.5) & TSNEProjection(:, 1) <= (Target_i + 0.5) & TSNEProjection(:, 2) >= (Target_j - 0.5) & TSNEProjection(:, 2) <= (Target_j + 0.5));

        Sort_ROI(i, 1) = size(x, 1);

        str = ['分析进度……', num2str(i / size(TSNEProjection, 1) * 100), '%'];
        waitbar(i / size(TSNEProjection, 1), h, str);
    end

    delete(h);

    % 计算到目标点的距离，并将数据传回CPU
    target = gpuArray([0 0]);
    distance = pdist2(TSNEProjection, target);

    % 将结果传回CPU
    Sort_ROI = gather(Sort_ROI);
    distance = gather(distance);

    Sort_ROI = [Sort_ROI distance];
end
