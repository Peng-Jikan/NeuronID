function [SubBlock_Signal,SubBlock_Location] = PixelChoose(TSNEProjection,i,Potential_Location,MAT_features,Diff_Projection)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
target=TSNEProjection(i,:);
distance=pdist2(TSNEProjection,target);
distance(:,2)=(1:1:size(distance,1))';
distance=sortrows(distance,1);
distance=distance(1:2000,:);

Location1=Potential_Location(distance(:,2),1:2);

target=Potential_Location(i,1:2);
distance=pdist2(Potential_Location(:,1:2),target);
distance(:,2)=(1:1:size(distance,1))';
distance=sortrows(distance,1);
distance=distance(1:2500,:);

Location2=Potential_Location(distance(:,2),1:2);
Location=[Location1;Location2];
region=Diff_Projection.*0;
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
SubBlock_Location_Raw=newMatrix(x,1:2);
Raw_Location=Potential_Location(i,1:2);
[x,~]=find(SubBlock_Location_Raw(:,1)==Potential_Location(i,1)&SubBlock_Location_Raw(:,2)==Potential_Location(i,2));
SubBlock_Location_Raw(x,:)=[];
SubBlock_Location_Raw=[Raw_Location;SubBlock_Location_Raw];

for ii=1:size(SubBlock_Location_Raw,1)
    [x,~]=find(Potential_Location(:,1)==SubBlock_Location_Raw(ii,1)&Potential_Location(:,2)==SubBlock_Location_Raw(ii,2));
    SubBlock_Location(ii,:)=Potential_Location(x,1:4);
    SubBlock_Signal(ii,:)=MAT_features(x,:);
end

[x,~]=find(SubBlock_Location(:,4)==0);
SubBlock_Signal=SubBlock_Signal(x,:);
SubBlock_Location=SubBlock_Location(x,1:2);

end