function [Segment_Class,Class_Por,FF_Base] = FeatureDFFT(DataFile)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
cd(DataFile);
cd('Signals');
cd('0');
TimeLabel_Signal=readmatrix('TimeLabel.csv');
cd(DataFile);

cd(DataFile);
cd('SignalFeatures');
cd('FeatureB');
cd('MiniTrailSegment');
LT=readmatrix('LT.csv');
FF_Base=mean(LT);
LT=LT-FF_Base;
Fs=abs(1/(TimeLabel_Signal(2,1)-TimeLabel_Signal(1,1)));
signal=LT;


% 执行FFT
n = length(signal); % 信号长度
Y = fft(signal); % 进行FFT变换
P2 = abs(Y/n); % 双侧频谱
P1 = P2(1:n/2+1); % 单侧频谱
P1(2:end-1) = 2*P1(2:end-1);

% 计算频率轴
f = Fs*(0:(n/2))/n;

% 绘制频谱图
figure(1),
set(gcf,'unit','centimeters','position',[5 5 7.5 5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
nexttile(1);
plot(f, P1,'LineWidth',1,'Color',[0.5 0.5 0.5]);
ylim([0,1]);
xlabel('Frequency/Hz');ylabel('|P1(f)|');
set(gca,'FontSize',6,'FontName','Helvetica');


% 参数设置
window = 100; % 窗口大小
noverlap = 10; % 重叠样本数
nfft =512; % FFT点数

% 执行STFT
[~,F,T,P] = spectrogram(signal,window,noverlap,nfft,Fs);
T=T+TimeLabel_Signal(1,1);

% 绘制时频图
figure(2),
set(gcf,'unit','centimeters','position',[15 5 9 7.5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
nexttile(1);
surf(T,F,10*log10(P),'edgecolor','none');
axis tight;colormap jet;
view(0,90);c=colorbar;clim([-120,30]);
xlabel('Time/s');ylabel('Frequency/Hz');
c.Label.String = 'Power/dB';
set(gca,'FontSize',6,'FontName','Helvetica');

% 绘制时频图
A=abs(F(:,1)-2);
[x,~]=find(A(:,1)==min(A(:,1)));
Idx_Near=x(1,1);

A=10*log10(P);
A=A';
Y=tsne(A);
[idx,~]=kmeans(Y,2);


[x,~]=find(idx(:,1)==1);
Power1=sum(mean(A(x,:)));
[x,~]=find(idx(:,1)==2);
Power2=sum(mean(A(x,:)));

if Power1>Power2
    Idx=idx;
    Idx(Idx==1)=0;
    Idx(Idx==2)=1;
    Idx(Idx==0)=2;
    idx=Idx;
end
c=[0.57 0.93 0;0 0.65 0.47];
figure(3),
set(gcf,'unit','centimeters','position',[15 5 7.5 7.5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
nexttile(1);
[x,~]=find(idx(:,1)==1);
scatter(Y(x,1),Y(x,2),20,'MarkerFaceColor',c(1,:),'MarkerEdgeColor','none','MarkerFaceAlpha',0.5);hold on;
[x,~]=find(idx(:,1)==2);
scatter(Y(x,1),Y(x,2),20,'MarkerFaceColor',c(2,:),'MarkerEdgeColor','none','MarkerFaceAlpha',0.5);
xlabel('TSNE-1');ylabel('TSNE-2');
box on;
set(gca,'FontSize',6,'FontName','Helvetica');

Segment_Class=[];
for i=1:size(T,2)
    Segment_Class(i,1)=T(1,i);
    A=abs(TimeLabel_Signal(:,1)-T(1,i));
    [x,~]=find(A(:,1)==min(A(:,1)));
    Idx_Near=x(1,1);

    Segment_Class(i,2)=Idx_Near-50;
    Segment_Class(i,3)=Idx_Near+49;
end
Segment_Class=[Segment_Class idx Y];

[x,~]=find(Segment_Class(:,4)==1);Target1=Segment_Class(x,5:6);
[x,~]=find(Segment_Class(:,4)==2);Target2=Segment_Class(x,5:6);
for i=1:size(Segment_Class,1)
    Point=Segment_Class(i,5:6);
    switch  Segment_Class(i,4)
        case 1
            distances = pdist2(Target2, Point);
        case 2
            distances = pdist2(Target1, Point);
    end
    Segment_Class(i,7)=min(distances);
end



Segment_Class2=Segment_Class;
Segment_Class2(:,end+1)=(1:1:size(Segment_Class2,1))';
[x,~]=find(Segment_Class2(:,4)==1);
Target1=Segment_Class2(x,:);Target1=sortrows(Target1,-7);
[x,~]=find(Segment_Class2(:,4)==2);
Target2=Segment_Class2(x,:);Target2=sortrows(Target2,7);
Segment_Class2=[Target1;Target2];

P2=[];
for i=1:size(Segment_Class2,1)
    P2(:,i)=P(:,Segment_Class2(i,8));
end
c=[0.57 0.93 0;0 0.65 0.47];
% 绘制时频图
figure(4),
set(gcf,'unit','centimeters','position',[15 5 9 7.5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
nexttile(1);
surf(T,F,10*log10(P2),'edgecolor','none');hold on;

X=T(1,1:size(Target1,1));Y=X.*0-0.1;
plot(X,Y,'Color',c(1,:),'LineWidth',5);
X=T(1,size(Target1,1)+1:end);Y=X.*0-0.1;
plot(X,Y,'Color',c(2,:),'LineWidth',5);

axis tight;colormap jet;set(gca,'Xtick',[]);
view(0,90);c=colorbar;clim([-120,30]);ylabel('Frequency/Hz');
c.Label.String = 'Power/dB';
set(gca,'FontSize',6,'FontName','Helvetica');


Class_Por(1,1)=size(Target1,1)/size(Segment_Class2,1)*100;
Class_Por(2,1)=size(Target2,1)/size(Segment_Class2,1)*100;
end