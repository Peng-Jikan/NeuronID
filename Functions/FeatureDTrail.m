function [Trail,Data1,Data2,TestP] = FeatureDTrail(DataFile)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
cd(DataFile);
cd('Signals');
cd('0');
TimeLabel_Signal=readmatrix('TimeLabel.csv');
FS=TimeLabel_Signal(2,1)-TimeLabel_Signal(1,1);

cd(DataFile);
cd('SignalFeatures');
cd('FeatureD');
cd('SegmentFiringFraction');
Segment_Class=readmatrix('Segment_Class.csv');
Segment_Class=sortrows(Segment_Class,2);

diff_data = diff(Segment_Class(:,4));
change_idx = [1; find(diff_data) + 1];

R=[];
for i=1:size(change_idx,1)-1
    R(i,1)=change_idx(i,1);
    R(i,2)=change_idx(i+1,1)-1;
end
if R(end,2)<size(Segment_Class,1)
    a=R(end,2);
    R(end+1,1)=a+1;R(end,2)=size(Segment_Class,1);
end

Trail=[];
for i=1:size(R)
    Trail(i,1)=Segment_Class(R(i,1),2);
    Trail(i,2)=Segment_Class(R(i,2),3);
    Trail(i,3)=Segment_Class(R(i,1),4);
    Trail(i,4)=(Trail(i,2)-Trail(i,1))*FS;
end

[x,~]=find(Trail(:,3)==1);Data1=Trail(x,4);
[x,~]=find(Trail(:,3)==2);Data2=Trail(x,4);

c=[0.57 0.93 0;0 0.65 0.47];
str1="LF";
str2="HF";
figure(1),
set(gcf,'unit','centimeters','position',[5 15 5 7.5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
nexttile(1);
Hdl=BoxChart(gca,1,Data1,c(1,:),0.5);
Hdl=BoxChart(gca,2,Data2,c(2,:),0.5);
labels = [str1,str2];x=1:2;
xticks(x);xticklabels(labels);ylabel('Duration/s');
set(gca,'FontSize',6,'FontName','Helvetica');
[~,TestP1]=ttest2(Data1,Data2);
TestP(1,1)=TestP1;
pos=axis;
text(0.7,pos(1,4),strcat('p=',sprintf('%.2e',TestP1)),"HorizontalAlignment","left",'FontSize',6,'FontName','Helvetica');


end