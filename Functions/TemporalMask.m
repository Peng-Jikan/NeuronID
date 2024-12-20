function [ROI_Feature,Region_Mask] = TemporalMask(data,Region_Mask,Area_Size)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
Max_projection=max(data,[],3);
Mean_projection=uint16(mean(data,3));
Diff_projection_Block=Max_projection-Mean_projection;

normalized_frame=mat2gray(Diff_projection_Block);

T = adaptthresh(normalized_frame, 0.3);
BW=imbinarize(normalized_frame,T);
[labeledImage1,~] = bwlabel(BW);
labeledImage1(1:3,:)=0;labeledImage1(end-2:end,:)=0;
labeledImage1(:,1:3)=0;labeledImage1(:,end-2:end)=0;
frequency_table = tabulate(labeledImage1(:));
[x,~]=find(frequency_table(:,2)<=Area_Size&frequency_table(:,1)>0);
Miss_ID=frequency_table(x,1);

for k=1:size(Miss_ID,1)
    labeledImage1(labeledImage1==Miss_ID(k,1))=0;
end

[labeledImage1,~] = bwlabel(labeledImage1);



Region= imfill(labeledImage1, 'holes');
Region(Region>0)=1;
[Region2,~] = bwlabel(Region);
ROI_Feature=Region2(:);

Region2(Region2>0)=1;
Region_Mask=Region_Mask+Region2;

figure(1),
set(gcf,'unit','centimeters','position',[10 10 25 15]);
set(gcf,'color','w');
tiledlayout(2,3,"TileSpacing","loose",'Padding',"compact");
nexttile(1);
imagesc(Max_projection);colormap gray;axis off
nexttile(2);
imagesc(Mean_projection);colormap gray;axis off;
nexttile(3);
imagesc(Diff_projection_Block);colormap gray;axis off;axis off;
nexttile(4);
imagesc(normalized_frame);colormap gray;axis off;axis off;
nexttile(5);
labeledImage1(labeledImage1>0)=1;
imagesc(labeledImage1);colormap gray;axis off;axis off;
nexttile(6);
imagesc(Region2);colormap gray;axis off;axis off;
end