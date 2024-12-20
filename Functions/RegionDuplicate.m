function [Region_Duplicate,Region_Feature,Decision] = RegionDuplicate(Region_Feature,ii,Frame_block_size,memMap_ROI,Sum_Projection)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
Distance(:,1)=(Region_Feature(:,3)-Region_Feature(ii,3)).^2;
Distance(:,2)=(Region_Feature(:,4)-Region_Feature(ii,4)).^2;
Distance(:,3)=(Distance(:,1)+Distance(:,2)).^0.5;
D=sortrows(Distance,3,'ascend');
Distance_Threshold=D(Frame_block_size,3);
[x1,~]=find(Distance(:,3)<=Distance_Threshold);
Region_Target=Region_Feature(x1,:);
[x2,~]=find(Region_Target(:,5)~=1);
if ~isempty(x2)
    Region_Target=Region_Target(x2,:);
    Decision=1;
end
if isempty(x2)
    Decision=0;
    Region_Duplicate=zeros(1,2);
end
if Decision==1
    Region1=memMap_ROI.Data.ROI(1:size(Sum_Projection,1),1:size(Sum_Projection,2),Region_Feature(ii,1));
    region1=double(Region1);S1=sum(region1(:));
    Region_Duplicate=zeros(1,4);k=1;a=[Region_Feature(ii,3),Region_Feature(ii,4)];
    for i=1:size(Region_Target,1)
        if Region_Target(i,1)~=Region_Feature(ii,1) && Region_Target(i,2)~=Region_Feature(ii,2)
            Region2=memMap_ROI.Data.ROI(1:size(Sum_Projection,1),1:size(Sum_Projection,2),Region_Target(i,1));
            region2=double(Region2);
            region3=region1.*region2;S2=sum(region2(:));S3=sum(region3(:));
            b=[Region_Target(i,3),Region_Target(i,4)];
            if S3>0
                Region_Duplicate(k,1)=max(S3/S1,S3/S2);
                Region_Duplicate(k,2)=min(S3/S1,S3/S2);
                Region_Duplicate(k,3)=2*S3/(S1+S2);
                Region_Duplicate(k,4)=sqrt(sum((a - b).^2));
                Region_Target(i,5)=1;
                k=k+1;
            end
        end
    end
    [A,~]=find(Region_Target(:,5)==1);
    if ~isempty(A)
        for j=1:size(A,1)
            [a,~]=find(Region_Feature(:,1)==Region_Target(A(j,1),1)&Region_Feature(:,2)==Region_Target(A(j,1),2));
            Region_Feature(a,5)=1;
        end
        Decision=2;
    end
end
end