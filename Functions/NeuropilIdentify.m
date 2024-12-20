function [Target_Signal,Region] = NeuropilIdentify(ROI_Num1,Sum_Projection,memMap_ROI_1,memMap,numFrames)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
Region=zeros(size(Sum_Projection,1),size(Sum_Projection,2));
h=waitbar(0,'please wait');
for ii=1:ROI_Num1
    region=memMap_ROI_1.Data.ROI1(1:size(Sum_Projection,1),1:size(Sum_Projection,2),ii);
    Region=Region+region;
    str=['已完成(1/2)……',num2str(ii/ROI_Num1*100),'%'];
    waitbar(ii/ROI_Num1,h,str);
    clear region;
end
delete(h);
Region(Region>1)=1;

[row,col]=find(Region==0);Target_Signal=[];
h=waitbar(0,'please wait');
for i=1:numFrames
    data=memMap.Data.Denoise(1:size(Sum_Projection,1),1:size(Sum_Projection,2),i);
    for j=1:size(row,1)
        target_i=row(j,1);
        target_j=col(j,1);
        target(j,1)=data(target_i,target_j);
    end
    target=double(target);
    Indices_nonzero=target(:,1)>0;
    if ~isempty(Indices_nonzero)
        target=target(Indices_nonzero,1);
        Target_Signal(i,1)=mean(target);
        Target_Signal(i,2)=std(target);
    end
    if isempty(Indices_nonzero)
        Target_Signal(i,1)=Target_Signal(i-1,1);
        Target_Signal(i,2)=Target_Signal(i-1,2);
    end
    clear target data;
    str=['已完成(2/2)……',num2str(i/numFrames*100),'%'];
    waitbar(i/numFrames,h,str);
end
delete(h);

end