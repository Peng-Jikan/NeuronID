function [ROI_Feature,Region_Mask] = TemporalMask(data,Region_Mask,Area_Size)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
Mean_projection=uint16(mean(data,3));
Mean_projection= medfilt2(Mean_projection, [3 3]);
Ifilt=imhmin(Mean_projection,1);
labeledImage1=watershed(Ifilt);
labeledImage1(1:3,:)=0;labeledImage1(end-2:end,:)=0;
labeledImage1(:,1:3)=0;labeledImage1(:,end-2:end)=0;
frequency_table = tabulate(labeledImage1(:));

[x,~]=find(frequency_table(:,2)<=Area_Size&frequency_table(:,1)>0);
Miss_ID=frequency_table(x,1);
[x,~]=find(frequency_table(:,2)>=300&frequency_table(:,1)>0);
Miss_ID=[Miss_ID;frequency_table(x,1)];
for k=1:size(Miss_ID,1)
    labeledImage1(labeledImage1==Miss_ID(k,1))=0;
end
[labeledImage1,~] = bwlabel(labeledImage1);

Region2=labeledImage1;

ROI_Feature=Region2(:);

Region2(Region2>0)=1;
Region_Mask=Region_Mask+Region2;

figure(1),
set(gcf,'unit','centimeters','position',[10 10 35 5]);
set(gcf,'color','w');
tiledlayout(1,3,"TileSpacing","loose",'Padding',"compact");
nexttile(1);
imagesc(Mean_projection);colormap gray;axis off
nexttile(2);
imagesc(Ifilt);colormap gray;axis off
nexttile(3);
labeledImage1(labeledImage1>0)=1;
imagesc(labeledImage1);colormap gray;axis off;axis off;

end