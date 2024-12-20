function [Calcium_signal,Positive_negtive,Positive_label,Calcium_signal2, Decision] = CalciumSignalIllustration(RawSignal,c,Baseline)
%UNTITLED7 此处显示有关此函数的摘要
%   此处显示详细说明
kde_obj = fitdist(RawSignal(:,1), 'Kernel', 'BandWidth', 100);
x = linspace(min(RawSignal(:,1)), max(RawSignal(:,1)), 1000);
y = pdf(kde_obj, x);

figure(1),
set(gcf,'unit','centimeters','position',[0 0 7.5 5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
nexttile(1);
area(x,y, 'FaceColor',c,'EdgeColor',[0.5 0.5 0.5],'LineWidth',1,'FaceAlpha',0.5);hold on;
Y=min(y):(max(y)-min(y))/100:max(y);X=zeros(1,size(Y,2))+Baseline;
plot(X,Y,'Color',[0 0 0],'LineWidth',0.5);hold off;
xlabel('Fluorescene Intensity');ylabel('Counts');
set(gca,'Ytick',[]);
set(gca,'FontSize',6,'FontName','Helvetica');

figure(2),
set(gcf,'unit','centimeters','position',[5 5 20 5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
nexttile(1);
plot(RawSignal(:,1),'LineWidth',1,'Color',c);hold on;
X=0:1:size(RawSignal,1);Y=zeros(1,size(X,2))+Baseline;
plot(X,Y,'Color',[0 0 0],'LineWidth',1);hold off;
xlabel('#Frames');ylabel('Fluorescene Intensity');
xlim([0,size(RawSignal,1)]);box on;
set(gca,'FontSize',6,'FontName','Helvetica');

Calcium_signal=((RawSignal(:,1))-(Baseline))./(Baseline);
figure(3),
set(gcf,'unit','centimeters','position',[5 5 20 5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
nexttile(1);
plot(Calcium_signal,'LineWidth',1,'Color',c);
xlabel('#Frames');ylabel('ΔF/F');
xlim([0,size(RawSignal,1)]);box on;
set(gca,'FontSize',6,'FontName','Helvetica');

[Positive_negtive,Positive_label] = SignalPeaks(Calcium_signal);
Decision=0;Calcium_signal2=0;
if Positive_negtive(1,1)>10*Positive_negtive(1,2)
    Decision=1;
    RawSignal(RawSignal<Baseline)=Baseline;
    Calcium_signal2=(RawSignal(:,1)-Baseline)./Baseline;
    figure(4),
    set(gcf,'unit','centimeters','position',[5 5 20 5]);
    set(gcf,'ToolBar','none','ReSize','off');
    set(gcf,'color','w');
    tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
    nexttile(1);
    plot(Calcium_signal2,'LineWidth',1,'Color',c);
    xlabel('#Frames');ylabel('ΔF/F');
    xlim([0,size(RawSignal,1)]);box on;
    set(gca,'FontSize',6,'FontName','Helvetica');
end

end