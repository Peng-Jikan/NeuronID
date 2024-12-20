function [Overlap,Threshold_Set,Data1,Data2,Segment_Class] = FeatureDSegmentFiringFraction(DataFile)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
cd(DataFile);
cd('SignalFeatures');
cd('FeatureD');
cd('TimeFrequency');
Segment_Class=readmatrix('Segment_Class.csv');
FF_Base=readmatrix('FF_Base.csv');
cd(DataFile);
cd('Signals');
cd('0');
TimeLabel_Signal=readmatrix('TimeLabel.csv');

cd(DataFile);
cd('SignalFeatures');
cd('FeatureB');
cd('MiniTrailSegment');
LT=readmatrix('LT.csv');

[x,~]=find(Segment_Class(:,4)==1);
Target1=Segment_Class(x,:);Target1=sortrows(Target1,-7);
[x,~]=find(Segment_Class(:,4)==2);
Target2=Segment_Class(x,:);Target2=sortrows(Target2,-7);

Total_Segment=max(size(Target1,1),size(Target2,1));
Overlap=[];Threshold_Set=[];

h=waitbar(0,'please wait');
for i=1:Total_Segment
    Overlap(i,1)=i;
    Overlap(i,2)=i/Total_Segment*100;
    E1=min(i,size(Target1,1));
    E2=min(i,size(Target2,1));
    Target_segment=[Target1(1:E1,:);Target2(1:E2,:)];

    T=[];
    for j=1:size(Target_segment,1)
        t=Target_segment(j,2):1:Target_segment(j,3);
        T=[T;t];
    end
    T1=unique(T);
    Overlap(i,3)=size(T1,1)/size(TimeLabel_Signal,1)*100;
    Overlap(i,4)=(size(T,1)*size(T,2))/size(T1,1)*100;

    T1=[];
    for j=1:E1
        t=Target1(j,2):1:Target1(j,3);
        T1=[T1;t];
    end
    T1=unique(T1);

    T2=[];
    for j=1:E2
        t=Target2(j,2):1:Target2(j,3);
        T2=[T2;t];
    end
    T2=unique(T2);

    common_elements = intersect(T1(:), T2(:));
    Overlap(i,5)=size(common_elements,1)/(size(T1,1)+size(T2,1))*100;

    str=['已完成……',num2str(i/Total_Segment*100),'%'];
    waitbar(i/Total_Segment,h,str);

    if i>1&&Overlap(i,3)==100&&Overlap(i-1,3)<100
        Threshold_Set=Overlap(i,:);
    end
end
delete(h);
if isempty(Threshold_Set)
    Threshold_Set=Overlap(i,:);
end

figure(1),
set(gcf,'unit','centimeters','position',[0 0 7.5 5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
nexttile(1);
area(Overlap(:,2),Overlap(:,3), 'FaceColor',[0.5 0.5 0.5],'EdgeColor',[0.5 0.5 0.5],'LineWidth',1,'FaceAlpha',0.5);hold on;
Y=0:1:Threshold_Set(1,3);X=Y.*0+Threshold_Set(1,2);
plot(X,Y,'Color',[1 1 1],'LineWidth',1);
xlabel('Top/%');ylabel('Overlap Whole Recording/%');
set(gca,'FontSize',6,'FontName','Helvetica');


figure(2),
set(gcf,'unit','centimeters','position',[0 0 7.5 5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
nexttile(1);
area(Overlap(:,2),Overlap(:,4), 'FaceColor',[0.5 0.5 0.5],'EdgeColor',[0.5 0.5 0.5],'LineWidth',1,'FaceAlpha',0.5);hold on;
Y=0:0.1:Threshold_Set(1,4);X=Y.*0+Threshold_Set(1,2);
plot(X,Y,'Color',[1 1 1],'LineWidth',1);
xlabel('Top/%');ylabel('Overlap Segments/%');
set(gca,'FontSize',6,'FontName','Helvetica');

Data1=[];Data2=[];
figure(3),
set(gcf,'unit','centimeters','position',[5 5 7 7.5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
for i=1:size(Target1,1)
    Z=LT(Target1(i,2):Target1(i,3),1);Y=Z.*0+i;X=1:1:100;
    Data1=[Data1;Z'];
    if i<=100
        figure(3),
        nexttile(1);
        scatter(X,Y,5,Z,"filled");hold on;
    end
end
figure(3),
nexttile(1);
xlim([0,100]);ylim([0,100]);
colormap gray;
c=colorbar;clim([min(LT),max(LT)]);
c.Label.String = 'Firing Fraction/%';
axis off;
set(gca,'FontSize',6,'FontName','Helvetica');


figure(4),
set(gcf,'unit','centimeters','position',[15 5 7 7.5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
for i=1:size(Target2,1)
    Z=LT(Target2(i,2):Target2(i,3),1);Y=Z.*0+i;X=1:1:100;
    Data2=[Data2;Z'];
    if i<=100
        figure(4),
        nexttile(1);
        scatter(X,Y,5,Z,"filled");hold on;
    end
end
figure(4),
nexttile(1);
xlim([0,100]);ylim([0,100]);
colormap gray;
c=colorbar;clim([min(LT),max(LT)]);
c.Label.String = 'Firing Fraction/%';
axis off;
set(gca,'FontSize',6,'FontName','Helvetica');

c=[0.57 0.93 0;0 0.65 0.47];
figure(5),
set(gcf,'unit','centimeters','position',[5 15 5.5 7.5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
nexttile(1);
X=0.1:0.1:10;Y1=mean(Data1(1:100,:))-std(Data1(1:100,:))/sqrt(size(Data1(1:100,:),1))-FF_Base;
plot(X,Y1,'Color',c(1,:),'LineWidth',0.1);hold on;
X=0.1:0.1:10;Y2=mean(Data1(1:100,:))+std(Data1(1:100,:))/sqrt(size(Data1(1:100,:),1))-FF_Base;
plot(X,Y2,'Color',c(1,:),'LineWidth',0.1);hold on;
fill([X, fliplr(X)], [Y1, fliplr(Y2)], c(1,:),'EdgeColor',c(1,:));

X=0.1:0.1:10;Y1=mean(Data2(1:100,:))-std(Data2(1:100,:))/sqrt(size(Data2(1:100,:),1))-FF_Base;
plot(X,Y1,'Color',c(2,:),'LineWidth',0.1);hold on;
X=0.1:0.1:10;Y2=mean(Data2(1:100,:))+std(Data2(1:100,:))/sqrt(size(Data2(1:100,:),1))-FF_Base;
plot(X,Y2,'Color',c(2,:),'LineWidth',0.1);hold on;
fill([X, fliplr(X)], [Y1, fliplr(Y2)], c(2,:),'EdgeColor',c(2,:));
xlim([0.1,10]);
xlabel('Time/s');ylabel('Firing Fraction (Removed)/%');
set(gca,'FontSize',6,'FontName','Helvetica');


figure(6),
set(gcf,'unit','centimeters','position',[15 15 5.5 7.5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
nexttile(1);
X=0.1:0.1:10;Y1=mean(Data1)-std(Data1)/sqrt(size(Data1,1))-FF_Base;
plot(X,Y1,'Color',c(1,:),'LineWidth',0.1);hold on;
X=0.1:0.1:10;Y2=mean(Data1)+std(Data1)/sqrt(size(Data1,1))-FF_Base;
plot(X,Y2,'Color',c(1,:),'LineWidth',0.1);hold on;
fill([X, fliplr(X)], [Y1, fliplr(Y2)], c(1,:),'EdgeColor',c(1,:));

X=0.1:0.1:10;Y1=mean(Data2)-std(Data2)/sqrt(size(Data2,1))-FF_Base;
plot(X,Y1,'Color',c(2,:),'LineWidth',0.1);hold on;
X=0.1:0.1:10;Y2=mean(Data2)+std(Data2)/sqrt(size(Data2,1))-FF_Base;
plot(X,Y2,'Color',c(2,:),'LineWidth',0.1);hold on;
fill([X, fliplr(X)], [Y1, fliplr(Y2)], c(2,:),'EdgeColor',c(2,:));
xlim([0.1,10]);
xlabel('Time/s');ylabel('Firing Fraction (Removed)/%');
set(gca,'FontSize',6,'FontName','Helvetica');

figure(7),
set(gcf,'unit','centimeters','position',[0 0 7.5 5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
nexttile(1);
area(Overlap(:,2),Overlap(:,5), 'FaceColor',[0.5 0.5 0.5],'EdgeColor',[0.5 0.5 0.5],'LineWidth',1,'FaceAlpha',0.5);hold on;
Y=0:1:Threshold_Set(1,5);X=Y.*0+Threshold_Set(1,2);
plot(X,Y,'Color',[1 1 1],'LineWidth',1);
xlabel('Top/%');ylabel('Overlap Classes/%');
set(gca,'FontSize',6,'FontName','Helvetica');

Segment_Class=[Target1;Target2];
end