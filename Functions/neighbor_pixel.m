function [Descien_use,R_JSC] = neighbor_pixel(i, Potential_Location, memMap, dataSize)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

Raw_Location=Potential_Location(i,1:2);
[x,~]=find(Potential_Location(:,1)>=(Raw_Location(1,1))&Potential_Location(:,1)<=(Raw_Location(1,1)+1)...
    &Potential_Location(:,2)>=(Raw_Location(1,2))&Potential_Location(:,2)<=(Raw_Location(1,2)+1));
SubBlock_Location_Raw = Potential_Location(x, 1:2);
[x, ~] = find(SubBlock_Location_Raw(:, 1) == Potential_Location(i, 1) & SubBlock_Location_Raw(:, 2) == Potential_Location(i, 2));
SubBlock_Location_Raw(x, :) = [];
SubBlock_Location_Raw = [Raw_Location; SubBlock_Location_Raw];

positions = find_row_positions(Potential_Location(:, 1:2), SubBlock_Location_Raw);

Descien_use=1;
if size(positions,1)<2
    Descien_use=0;
    R_JSC=[];
end
if size(positions,1)>=2
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
end
end