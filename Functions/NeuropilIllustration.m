function NeuropilIllustration(Diff_Projection,Location_Baackground,c,numFrames,Target_Signal)
%UNTITLED5 此处显示有关此函数的摘要
%   此处显示详细说明
figure(1),
set(gcf,'unit','centimeters','position',[0 0 9 7.5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
nexttile(1);
imagesc(Diff_Projection);colormap gray;axis off;hold on;
scatter(Location_Baackground(:,2),Location_Baackground(:,1),0.1,'MarkerFaceColor',c,'MarkerEdgeColor','none');hold off;

figure(2),
set(gcf,'unit','centimeters','position',[5 5 20 5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
nexttile(1);
x=1:numFrames;
upper_bound = Target_Signal(:,1)' + Target_Signal(:,2)';
lower_bound = Target_Signal(:,1)' - Target_Signal(:,2)';
plot(x, Target_Signal(:,1)','LineWidth',1,'Color',[0 0 0]);hold on;
fill([x fliplr(x)],[lower_bound fliplr(upper_bound)],c,'edgealpha', '0', 'facealpha', '.5');hold off;
xlabel('#Frames');ylabel('Fluorescene Intensity');
xlim([0,numFrames]);box on;
set(gca,'FontSize',6,'FontName','Helvetica');

kde_obj = fitdist(Target_Signal(:,1), 'Kernel', 'BandWidth', 50);
x = linspace(min(Target_Signal(:,1)), max(Target_Signal(:,1)), 1000);
y = pdf(kde_obj, x);
figure(3),
set(gcf,'unit','centimeters','position',[0 0 7.5 5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
nexttile(1);
area(x,y, 'FaceColor',c,'EdgeColor',[0 0 0],'LineWidth',1,'FaceAlpha',0.5);
xlabel('Fluorescene Intensity');ylabel('Counts');
set(gca,'Ytick',[]);
set(gca,'FontSize',6,'FontName','Helvetica');

kde_obj = fitdist(Target_Signal(:,2), 'Kernel', 'BandWidth', 50);
x = linspace(min(Target_Signal(:,2)), max(Target_Signal(:,2)), 1000);
y = pdf(kde_obj, x);
figure(4),
set(gcf,'unit','centimeters','position',[0 0 7.5 5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
nexttile(1);
area(x,y, 'FaceColor',c,'EdgeColor',[0 0 0],'LineWidth',1,'FaceAlpha',0.5);
xlabel('Fluorescene Intensity');ylabel('Counts');
set(gca,'Ytick',[]);
set(gca,'FontSize',6,'FontName','Helvetica');
end