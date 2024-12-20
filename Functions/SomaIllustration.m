function SomaIllustration(Diff_Projection,Location,i,Color_Data,numFrames,Target_Signal)
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
figure(1),
set(gcf,'unit','centimeters','position',[0 0 9 7.5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
nexttile(1);
imagesc(Diff_Projection);colormap gray;axis off;hold on;
scatter(Location(:,2),Location(:,1),1,'MarkerFaceColor',Color_Data(i,:),'MarkerEdgeColor','none');hold on;

figure(2),
set(gcf,'unit','centimeters','position',[5 5 20 5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
nexttile(1);
x=1:numFrames;
upper_bound = Target_Signal(:,1)' + Target_Signal(:,2)';
lower_bound = Target_Signal(:,1)' - Target_Signal(:,2)';
plot(x, Target_Signal(:,1)','LineWidth',1,'Color',Color_Data(i,:));hold on;
fill([x fliplr(x)],[lower_bound fliplr(upper_bound)],[0.5, 0.5, 0.5],'edgealpha', '0', 'facealpha', '.5');hold off;
xlabel('#Frames');ylabel('Fluorescene Intensity');
xlim([0,numFrames]);box on;
set(gca,'FontSize',6,'FontName','Helvetica');

kde_obj = fitdist(Target_Signal(:,1), 'Kernel', 'BandWidth', 100);
x = linspace(min(Target_Signal(:,1)), max(Target_Signal(:,1)), 1000);
y = pdf(kde_obj, x);
figure(3),
set(gcf,'unit','centimeters','position',[0 0 7.5 5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
nexttile(1);
area(x,y, 'FaceColor',Color_Data(i,:),'EdgeColor',[0.5 0.5 0.5],'LineWidth',1,'FaceAlpha',0.5);
xlabel('Fluorescene Intensity');ylabel('Counts');
set(gca,'Ytick',[]);
set(gca,'FontSize',6,'FontName','Helvetica');

kde_obj = fitdist(Target_Signal(:,2), 'Kernel', 'BandWidth', 100);
x = linspace(min(Target_Signal(:,2)), max(Target_Signal(:,2)), 1000);
y = pdf(kde_obj, x);
figure(4),
set(gcf,'unit','centimeters','position',[0 0 7.5 5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
nexttile(1);
area(x,y, 'FaceColor',Color_Data(i,:),'EdgeColor',[0.5 0.5 0.5],'LineWidth',1,'FaceAlpha',0.5);
xlabel('Fluorescene Intensity');ylabel('Counts');
set(gca,'Ytick',[]);
set(gca,'FontSize',6,'FontName','Helvetica');

figure(5),
set(gcf,'unit','centimeters','position',[10 10 4 4]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
nexttile(1);
scatter(Location(:,2),Location(:,1),10,'MarkerFaceColor',[0.5 0.5 0.5],'MarkerEdgeColor','none');
xlim([median(Location(:,2))-24.5,median(Location(:,2))+24.5]);
ylim([median(Location(:,1))-24.5,median(Location(:,1))+24.5]);
set(gca,'Xtick',[]);set(gca,'Ytick',[]);box on;
set(gca,'FontSize',6,'FontName','Helvetica');

end