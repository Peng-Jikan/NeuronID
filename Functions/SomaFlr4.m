function [Target_Signal] = SomaFlr4(Potential_Location,i,numFrames,memMap,Soma_ID,Diff_Projection)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
[x,~]=find(Soma_ID(:,i)==1);
Location=Potential_Location(x,1:2);
Region=Diff_Projection.*0;
for i=1:size(Location,1)
    Region(Location(i,1),Location(i,2))=1;
end

Target_Signal=[];Target_Signal=gpuArray(Target_Signal);
h=waitbar(0,'please wait');

for j=1:numFrames
    data=gpuArray(memMap.Data.Denoise(:,:,j));
    target=Region.*data;
    target=double(target);target=target(:);
    [Indices_nonzero,~]=find(target(:,1)>0);
    if ~isempty(Indices_nonzero)
        target=target(Indices_nonzero,1);
        Target_Signal(j,1)=mean(target);
        Target_Signal(j,2)=std(target);
    end
    if isempty(Indices_nonzero)
        Target_Signal(j,1)=Target_Signal(j-1,1);
        Target_Signal(j,2)=Target_Signal(j-1,2);
    end
    str=['信号提取……',num2str(j/numFrames*100),'%'];
    waitbar(j/numFrames,h,str);
end
delete(h);
end