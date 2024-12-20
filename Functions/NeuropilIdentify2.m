function [Target_Signal] = NeuropilIdentify2(Potential_Location,numFrames,memMap)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
[x,~]=find(Potential_Location(:,4)==0);
Location=Potential_Location(x,1:2);
nums = randperm(size(Location,1), floor(size(Location,1)/30));
nums=nums';
Location=Location(nums,:);

Target_Signal=[];
h=waitbar(0,'please wait');

for j=1:numFrames
    data=memMap.Data.Denoise(:,:,j);
    target=data(Location(:,1),Location(:,2));
    target=target(:);
    target=double(target);
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
    str=['背景分析……',num2str(j/numFrames*100),'%'];
    waitbar(j/numFrames,h,str);
end
delete(h);
end