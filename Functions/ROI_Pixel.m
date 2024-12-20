function [SubBlock_Location,ROI_size] = ROI_Pixel(Potential_Location,i,SubBlock_Location,Diff_Projection)
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
region=Diff_Projection.*0;
[x,~]=find(SubBlock_Location(:,3)>0);
Location=SubBlock_Location(x,1:2);
for ii=1:size(Location,1)
    region(Location(ii,1),Location(ii,2))=1;
end
[LabelImage, numRegions] = bwlabel(region);

if numRegions>1
    A=LabelImage(Potential_Location(i,1),Potential_Location(i,2));
    LabelImage(LabelImage>A)=0;
    LabelImage(LabelImage<A)=0;
    LabelImage(LabelImage==A)=1;
end

[rows, cols] = size(LabelImage);
[colIdx, rowIdx] = meshgrid(1:cols, 1:rows);
rowIdx = rowIdx(:);
colIdx = colIdx(:);
values = LabelImage(:);
newMatrix = [rowIdx, colIdx, values];

[x,~]=find(newMatrix(:,3)==1);
SubBlock_Location=newMatrix(x,:);
ROI_size=size(x,1);
end