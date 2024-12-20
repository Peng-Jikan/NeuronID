function CorrectionSigalIllustration(Flsorescene,Neuropil,correction,c,Threshold)
%UNTITLED6 此处显示有关此函数的摘要
%   此处显示详细说明
figure(1),
set(gcf,'unit','centimeters','position',[5 5 20 5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
nexttile(1);
x=1:size(Flsorescene,1);
plot(x, Flsorescene(:,1)','LineWidth',1,'Color',c);
xlabel('#Frames');ylabel('Fluorescene Intensity');
xlim([0,size(Flsorescene,1)]);box on;
set(gca,'FontSize',6,'FontName','Helvetica');


figure(2),
set(gcf,'unit','centimeters','position',[5 5 20 5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
nexttile(1);
x=1:size(Flsorescene,1);
plot(x, Flsorescene(:,1)','LineWidth',1,'Color',c);hold on;
y=x.*0+Threshold;
plot(x, y,'LineWidth',1,'Color',[0.5 0.5 0.5]);hold off;
xlabel('#Frames');ylabel('Fluorescene Intensity');
xlim([0,size(Flsorescene,1)]);box on;
set(gca,'FontSize',6,'FontName','Helvetica');


figure(3),
set(gcf,'unit','centimeters','position',[5 5 20 5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
nexttile(1);
x=1:size(Flsorescene,1);
plot(x, Neuropil(:,1)','LineWidth',1,'Color',c);
xlabel('#Frames');ylabel('Fluorescene Intensity');
xlim([0,size(Flsorescene,1)]);box on;
set(gca,'FontSize',6,'FontName','Helvetica');

figure(4),
set(gcf,'unit','centimeters','position',[5 5 20 5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
nexttile(1);
x=1:size(Flsorescene,1);
plot(x, correction(:,1)','LineWidth',1,'Color',c);
xlabel('#Frames');ylabel('Fluorescene Intensity');
xlim([0,size(Flsorescene,1)]);box on;
set(gca,'FontSize',6,'FontName','Helvetica');




end