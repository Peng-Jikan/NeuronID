function [RJSC_result] = Region_overlap_check(Region_Near_unique,Potential_Location)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
MAT_features=readmatrix('MAT_features.csv');

Size_row=size(MAT_features,1);
Size_col=size(MAT_features,2);
clear MAT_features;

filename = 'Feature.dat';
dataSize = [Size_row,Size_col];
dataType = 'double';
memMap = memmapfile(filename, 'Format', {dataType, dataSize, 'Feature'});

RJSC_result=Region_Near_unique;
h=waitbar(0,'please wait');
for i=1:size(Region_Near_unique,1)
    [positions,~]=find(Potential_Location(:,4)==Region_Near_unique(i,1));
    SubBlock_Signal_1 = memMap.Data.Feature(positions, 1:dataSize(1, 2));
    [positions,~]=find(Potential_Location(:,4)==Region_Near_unique(i,2));
    SubBlock_Signal_2 = memMap.Data.Feature(positions, 1:dataSize(1, 2));
    A_Signal = repelem(SubBlock_Signal_1, size(SubBlock_Signal_2,1), 1);
    B_Signal=[];
    for j=1:size(SubBlock_Signal_1,1)
        B_Signal=[B_Signal;SubBlock_Signal_2];
    end
    Total_Signal=A_Signal+B_Signal;
    Diff_Signal=abs(A_Signal-B_Signal);
    Total_Signal(Total_Signal>0)=1;
    Diff_Signal(Diff_Signal>0)=1;
    Total_Num=sum(Total_Signal,2);
    Diff_Num=sum(Diff_Signal,2);
    Same_Num=Total_Num-Diff_Num;
    R_JSC=Same_Num./Total_Num;
    [x,~]=find(R_JSC(:,1)>=0.5);
    RJSC_result(i,3)=size(SubBlock_Signal_1,1);
    RJSC_result(i,4)=size(SubBlock_Signal_2,1);
    RJSC_result(i,5)=size(A_Signal,1);
    RJSC_result(i,6)=size(x,1);
    RJSC_result(i,7)= RJSC_result(i,6)/RJSC_result(i,5);
    str=['分析进度……',num2str(i/size(Region_Near_unique,1)*100),'%'];
    waitbar(i/size(Region_Near_unique,1),h,str);
end
delete(h);
end