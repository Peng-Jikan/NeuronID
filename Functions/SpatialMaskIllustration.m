function [ROI_AREA] = SpatialMaskIllustration(Potential_Location,Color_Data,ROI_Num,Diff_Projection)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
figure(1),
set(gcf,'unit','centimeters','position',[10 10 9 7.5]);
set(gcf,'ToolBar','none','ReSize','off');
set(gcf,'color','w');
tiledlayout(1,1,"TileSpacing","compact",'Padding',"compact");
nexttile(1);
imagesc(Diff_Projection);colormap gray;axis off;hold on;

ROI_AREA=[];
for i=1:ROI_Num
    [x,~]=find(Potential_Location(:,4)==i);
    scatter(Potential_Location(x,2),Potential_Location(x,1),0.1,'MarkerFaceColor',Color_Data(i,:),'MarkerEdgeColor','none');hold on;
    ROI_AREA(i,1)=1;ROI_AREA(i,2)=size(x,1);
    disp(['已找到ROI数量:',num2str(i),'面积:',num2str(size(x,1))]);
end

end