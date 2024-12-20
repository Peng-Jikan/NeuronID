function [Potential_Location,ROI_num] = TSNEMaskPartone(TSNEProjection,Potential_Location,Diff_Projection)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
X_min=floor(min(TSNEProjection(:,1)));X_max=ceil(max(TSNEProjection(:,1)));
Y_min=floor(min(TSNEProjection(:,2)));Y_max=ceil(max(TSNEProjection(:,2)));
Potential_Location(:,4)=0;ROI_num=1;
h=waitbar(0,'please wait');
for i=X_min:1:X_max
    for j=Y_min:1:Y_max
        [x,~]=find(TSNEProjection(:,1)>=i&TSNEProjection(:,1)<(i+1)...
&TSNEProjection(:,2)>=j&TSNEProjection(:,2)<(j+1));
        if ~isempty(x)
            Location=Potential_Location(x,1:2);
            region = Diff_Projection .* 0;
            for ii = 1:size(Location, 1)
                region(Location(ii, 1), Location(ii, 2)) = 1;
            end
            [LabelImage, numRegions] = bwlabel(region);
            [rows, cols] = size(LabelImage);
            [colIdx, rowIdx] = meshgrid(1:cols, 1:rows);
            rowIdx = rowIdx(:);
            colIdx = colIdx(:);
            values = LabelImage(:);
            newMatrix = [rowIdx, colIdx, values];
            for ii=1:numRegions
                [x, ~] = find(newMatrix(:, 3) == ii);
                SubBlock_Location_Raw=newMatrix(x, 1:2);
                positions = find_row_positions(Potential_Location(:, 1:2), SubBlock_Location_Raw);
                Potential_Location(positions,4)=ROI_num;
                ROI_num=ROI_num+1;
            end
        end
    end
    [x,~]=find(Potential_Location(:,4)>0);A1=size(x,1);
    str=['分析进度……',num2str(A1/size(Potential_Location,1)*100),'%'];
    waitbar(A1/size(Potential_Location,1),h,str);
end
delete(h);
ROI_num=ROI_num-1;
end