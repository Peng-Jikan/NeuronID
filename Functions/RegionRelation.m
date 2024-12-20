function [region,Decision] = RegionRelation(memMap_R,ii,PotentialLocation,Region_Mask,Frame_block)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
Decision=0;
region=zeros(size(Region_Mask,1),size(Region_Mask,2));
target_r=PotentialLocation(ii,1);
target_c=PotentialLocation(ii,2);
Target_Signal=memMap_R.Data.R(target_r:target_r,target_c:target_c,1:size(Frame_block,1));
Target_Signal = reshape(Target_Signal, 1, size(Frame_block,1));
Target_Signal(Target_Signal>1)=1;
if sum(Target_Signal)>=3
    Decision=1;
end
if Decision==1
    target_r_s=target_r-50;
    if target_r_s<=0
        target_r_s=1;
    end
    target_r_e=target_r+50;
    if target_r_e>size(Region_Mask,1)
        target_r_e=size(Region_Mask,1);
    end

    target_c_s=target_c-50;
    if target_c_s<=0
        target_c_s=1;
    end
    target_c_e=target_c+50;
    if target_c_e>size(Region_Mask,2)
        target_c_e=size(Region_Mask,2);
    end

    Pixel_Relation=zeros(size(Region_Mask,1),size(Region_Mask,2));
    for i=target_r_s:target_r_e
        for j=target_c_s:target_c_e
            target_Signal=memMap_R.Data.R(i:i,j:j,1:size(Frame_block,1));
            target_Signal = reshape(target_Signal, 1, size(Frame_block,1));
            target_Signal(target_Signal>1)=1;
            [R,~] = corrcoef(Target_Signal,target_Signal);
            Pixel_Relation(i,j)=R(1,2);
        end
    end
    nanIndices = isnan(Pixel_Relation);
    Pixel_Relation(nanIndices) = 0;
    Pixel_Relation(Pixel_Relation>=0.5)=1;
    Pixel_Relation(Pixel_Relation<0.5)=0;
    [labeledImage,~] = bwlabel(Pixel_Relation);
    Region_Label=labeledImage(target_r,target_c);
    region=labeledImage==Region_Label;
    stats = regionprops(region,'Area',"MaxFeretProperties","MinFeretProperties");
    if stats(1).Area>10 && stats(1).Area<10000 && stats(1).MaxFeretDiameter/stats(1).MinFeretDiameter<3
        Decision=2;
    end
end
end