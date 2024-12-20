function positions = find_row_positions(A, B)
    % 获取矩阵 B 的行数
    nRowsB = size(B, 1);

    % 初始化结果向量
    positions = zeros(nRowsB, 1);

    % 遍历 B 的每一行
    for i = 1:nRowsB
        % 查找 B 的当前行在 A 中的位置
        [~, loc] = ismember(B(i, :), A, 'rows');
        positions(i) = loc;
    end
end