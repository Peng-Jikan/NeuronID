function [RJSC_result] = Region_overlap_check2(Region_Near_unique,ROI_Label)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
MAT_features=readmatrix('MAT_features.csv');

Size_row=size(MAT_features,1);
Size_col=size(MAT_features,2);
clear MAT_features;

filename = 'Feature.dat';
dataSize = [Size_row,Size_col];
dataType = 'double';
memMap = memmapfile(filename, 'Format', {dataType, dataSize, 'Feature'});
Region_Near_unique=gpuArray(Region_Near_unique);
ROI_Label=gpuArray(ROI_Label);
RJSC_result=Region_Near_unique;
h=waitbar(0,'please wait');
for i=1:size(Region_Near_unique,1)

    [positions1,~]=find(ROI_Label(:,Region_Near_unique(i,1))==1);
    SubBlock_Signal_1 = gpuArray(memMap.Data.Feature(positions1, 1:dataSize(1, 2)));

    [positions2,~]=find(ROI_Label(:,Region_Near_unique(i,2))==1);
    SubBlock_Signal_2 = gpuArray(memMap.Data.Feature(positions2, 1:dataSize(1, 2)));

    unionAB = union(positions1, positions2);
    RJSC_result(i,3)=size(SubBlock_Signal_1,1);
    RJSC_result(i,4)=size(SubBlock_Signal_2,1);
    RJSC_result(i,5)=size(unionAB,1);
    clear positions1 positions2 unionAB;
    R_JSC=[];
    for j=1:size(SubBlock_Signal_1,1)
        A_Signal = repelem(SubBlock_Signal_1(j,:), size(SubBlock_Signal_2,1), 1);
        Total_Signal=A_Signal+SubBlock_Signal_2;
        Total_Signal(Total_Signal>0)=1;
        Total_Num=sum(Total_Signal,2);
        clear Total_Signal;
        Diff_Signal=abs(A_Signal-SubBlock_Signal_2);
        Diff_Signal(Diff_Signal>0)=1;
        Diff_Num=sum(Diff_Signal,2);
        clear Diff_Signal;
        Same_Num=Total_Num-Diff_Num;
        R_JSC=[R_JSC;Same_Num./Total_Num];
    end

    RJSC_result(i,6)=size(R_JSC,1);
    [x,~]=find(R_JSC(:,1)>=0.5);
    RJSC_result(i,7)=size(x,1);
    RJSC_result(i,8)= RJSC_result(i,7)/RJSC_result(i,6);

    str=['分析进度2/2……',num2str(i/size(Region_Near_unique,1)*100),'%'];
    waitbar(i/size(Region_Near_unique,1),h,str);
end
delete(h);
end