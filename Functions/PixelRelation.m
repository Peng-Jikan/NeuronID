function [SubBlock_Location] = PixelRelation(SubBlock_Signal,SubBlock_Location)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
A=sum(SubBlock_Signal,2);
[x,~]=find(A(:,1)>3);
SubBlock_Signal=SubBlock_Signal(x,:);
SubBlock_Location=SubBlock_Location(x,:);

mat=[];k=1;
for i=1:1
    for j=i+1:size(SubBlock_Signal,1)
        signal1=SubBlock_Signal(i,:);
        signal2=SubBlock_Signal(j,:);
        signal3=signal1.*signal2;signal3(signal3>0)=1;
        S3=sum(signal3(1,:));
        signal4=signal1+signal2;signal4(signal4>0)=1;
        S4=sum(signal4(1,:));
        
        r = S3/S4;
        if r>0.5
            mat(k,1)=i;mat(k,2)=j;
            k=k+1;
        end
    end
end

vectors = {};
if ~isempty(mat)
    % 使用一个 cell array 来存储每个唯一的向量组
    

    for i = 1:size(mat, 1)
        assigned = false;
        current_row = mat(i, :);

        % 遍历 vectors 来找到应该合并的位置
        for j = 1:length(vectors)
            if any(ismember(vectors{j}, current_row))
                % 有共同的元素，合并 current_row 到这个向量
                vectors{j} = unique([vectors{j}, current_row]);
                assigned = true;
                break;
            end
        end

        if ~assigned
            % 如果当前行没有与现有向量合并，则创建新的向量
            vectors{end+1} = current_row; % 这里使用 unique 确保向量元素不重复
        end
    end

    % 合并过程可能还没有完全完成，因为新合并的向量可能和其他向量有共通元素。
    % 因此进行循环合并，直到没有更多的合并可以完成
    changed = true;
    while changed
        changed = false; % 假设没有变化
        new_vectors = {}; % 用于存储新合并后的向量

        while ~isempty(vectors)
            % 取出一个向量，并检查是否可以与 new_vectors 中的任何向量合并
            vec = vectors{end};
            vectors(end) = []; % 移除已经取出的向量

            merged = false; % 标记是否合并
            for j = 1:length(new_vectors)
                if any(ismember(new_vectors{j}, vec))
                    % 合并向量
                    new_vectors{j} = unique([new_vectors{j}, vec]);
                    merged = true;
                    break;
                end
            end

            if ~merged
                % 如果没有合并，则将其作为新向量添加
                new_vectors{end+1} = vec;
            else
                changed = true; % 发生了合并
            end
        end

        % 更新向量集，进行下一轮检查
        vectors = new_vectors;
    end
end
% 显示最终结果
if ~isempty(vectors)
    k=1;
    for i = 1:length(vectors)
        A=vectors{i};A=A';
        if size(A,1)>=3
            SubBlock_Location(A,3)=k;
            k=k+1;
        end
    end
end
end