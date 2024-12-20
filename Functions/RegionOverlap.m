function [Region1,Region_Feature,Decision] = RegionOverlap(Region_Feature,ii,memMap_ROI,Sum_Projection,Overlap_Threshold)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
Distance(:,1)=(Region_Feature(:,2)-Region_Feature(ii,2)).^2;
Distance(:,2)=(Region_Feature(:,3)-Region_Feature(ii,3)).^2;
Distance(:,3)=(Distance(:,1)+Distance(:,2)).^0.5;
D=sortrows(Distance,3,'ascend');
Distance_Threshold=D(300,3);
[x1,~]=find(Distance(:,3)<=Distance_Threshold);
Region_Target=Region_Feature(x1,:);
[x2,~]=find(Region_Target(:,4)~=1);
if ~isempty(x2)
    Region_Target=Region_Target(x2,:);
    Decision=1;
end
if isempty(x2)
    Decision=0;
    Region1=zeros(size(Sum_Projection,1),size(Sum_Projection,2));
end
if Decision==1
    Region1=memMap_ROI.Data.ROI(1:size(Sum_Projection,1),1:size(Sum_Projection,2),Region_Feature(ii,1));
    Region1=double(Region1);S1=sum(Region1(:));
    for i=1:size(Region_Target,1)
        Region2=memMap_ROI.Data.ROI(1:size(Sum_Projection,1),1:size(Sum_Projection,2),Region_Target(i,1));
        Region2=double(Region2);
        Region3=Region1.*Region2;
        S2=sum(Region2(:));S3=sum(Region3(:));
        if 2*S3/(S1+S2)>=Overlap_Threshold
            Region1=Region1+Region2;
            Region1(Region1>1)=1;
            Region_Target(i,4)=1;
        end
    end
    [A,~]=find(Region_Target(:,4)==1);
    for j=1:size(A,1)
        [a,~]=find(Region_Feature(:,1)==Region_Target(A(j,1),1));
        Region_Feature(a,4)=1;
    end
end
end