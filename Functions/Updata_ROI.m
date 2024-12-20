
function [Overlap_ID] = Updata_ROI(Overlap_ID,Potential_Location,Pixel_ID)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
for j=1:size(Overlap_ID,1)
    [Position1,~]=find(Potential_Location(:,4)==Overlap_ID(j,1));
    intersectionAB = intersect(Position1, Pixel_ID);
    unionAB = union(Position1, Pixel_ID);
    Same_pixel = size(intersectionAB,1);
    Total_pixel=size(unionAB,1);
    Overlap_ID(j,2)=Same_pixel/Total_pixel;
    if Same_pixel==size(Pixel_ID,1)||Same_pixel==size(Position1,1)
        Overlap_ID(j,2)=1;
    end
end
[x,~]=find(Overlap_ID(:,2)==max(Overlap_ID(:,2)));
Overlap_ID=Overlap_ID(x(1,1),:);
end

