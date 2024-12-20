function [Descien_use,Pixel_ID] = ROI_Detect2(TSNEProjection, i, Potential_Location, memMap, Diff_Projection, dataSize,Area_Size)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
% 计算距离
target = TSNEProjection(i, :);
distance = pdist2(TSNEProjection, target);
distance(:, 2) = (1:1:size(distance, 1))';
distance = sortrows(distance, 1);
distance = distance(1:1000, :);
Location = Potential_Location(distance(:, 2), 1:2);

% 初始化区域
region = Diff_Projection .* 0;
for ii = 1:size(Location, 1)
    region(Location(ii, 1), Location(ii, 2)) = 1;
end
% 标记区域
[LabelImage, numRegions] = bwlabel(region);
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

positions = find_row_positions(Potential_Location(:, 1:2), SubBlock_Location_Raw);
Potential_Location_Use=Potential_Location(positions,1:4);
[x,~]=find(Potential_Location_Use(:,4)==0);
SubBlock_Location_Raw=Potential_Location_Use(x,1:2);
positions = find_row_positions(Potential_Location(:, 1:2), SubBlock_Location_Raw);

Descien_use=1;
if size(positions,1)<Area_Size
    Descien_use=0;
    Pixel_ID=i;
end
if size(positions,1)>=Area_Size
    SubBlock_Signal = memMap.Data.Feature(positions, 1:dataSize(1, 2));
    SubBlock_Signal_1 =SubBlock_Signal(1,:);
    SubBlock_Signal_2 =SubBlock_Signal(2:end,:);
    A_Signal = repelem(SubBlock_Signal_1, size(SubBlock_Signal_2,1), 1);
    B_Signal=SubBlock_Signal_2;
    Total_Signal=A_Signal+B_Signal;
    Diff_Signal=abs(A_Signal-B_Signal);
    Total_Signal(Total_Signal>0)=1;
    Diff_Signal(Diff_Signal>0)=1;
    Total_Num=sum(Total_Signal,2);
    Diff_Num=sum(Diff_Signal,2);
    Same_Num=Total_Num-Diff_Num;
    R_JSC=Same_Num./Total_Num;
    R_JSC(:,2)=positions(1,1);
    R_JSC(:,3)=positions(2:end,1);

    [x,~]=find(R_JSC(:,1)>0.5);
    Pixel_ID=R_JSC(x,2:3);
    Pixel_ID=Pixel_ID(:);
    Pixel_ID=unique(Pixel_ID);
    if size(Pixel_ID,1)<Area_Size
        Descien_use=0;
    end
    if size(Pixel_ID,1)>=Area_Size
        Location=Potential_Location(Pixel_ID, 1:2);
        Region = double(Diff_Projection .* 0);
        for ii = 1:size(Location, 1)
            Region(Location(ii, 1), Location(ii, 2)) = 1;
        end
        stats = regionprops(Region,"MaxFeretProperties","MinFeretProperties");
        R=stats(1).MaxFeretDiameter/stats(1).MinFeretDiameter;
        if R>3
            Descien_use=0;
        end
    end
end
end