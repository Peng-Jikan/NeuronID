function [Decision,Target_Signal,region] = SomaFlr(memMap_Soma,i,Sum_Projection,Region_label,numFrames,memMap)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
region=memMap_Soma.Data.Soma(1:size(Sum_Projection,1),1:size(Sum_Projection,2),i);
[row,col]=find(region==1);
Target_signal=[];region_label=[];
for j=1:size(row,1)
    target_i=row(j,1);
    target_j=col(j,1);
    data=memMap.Data.Denoise(target_i:target_i,target_j:target_j,1:numFrames);
    data = reshape(data, 1, numFrames);
    Target_signal=[Target_signal double(data)'];
    region_label(1,j)=Region_label(target_i,target_j);
end
[~,y]=find(region_label(1,:)==1);
if size(y,2)>=3
    Target_signal=Target_signal(:,y);
    Decision=1;
end
if isempty(y)||size(y,2)<3
    Decision=0;
    Target_Signal=zeros(numFrames,1);
end
if Decision==1
    for j=1:numFrames
        target=Target_signal(j,:);
        target=target(:);
        Indices_nonzero=target(:,1)>0;
        if ~isempty(Indices_nonzero)
            target=target(Indices_nonzero,1);
            Target_Signal(j,1)=mean(target);
            Target_Signal(j,2)=std(target);
        end
        if isempty(Indices_nonzero)
            Target_Signal(j,1)=Target_Signal(j-1,1);
            Target_Signal(j,2)=Target_Signal(j-1,2);
        end
    end
end
Target_Signal(isnan(Target_Signal))=0;
end