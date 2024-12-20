function [Pixel_Relation] = AdjactPixel(Potential_Location,MAT_features,TSNEProjection)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
Pixel_Relation=[];M=1;
h=waitbar(0,'please wait');
for i=1:size(Potential_Location,1)
    Origan_Pixel=Potential_Location(i,1:2);
    Idx1=i;
    TSNE_Location1=TSNEProjection(Idx1,1:2);
    Zero_location=[0 0];
    Origan_signal=MAT_features(Idx1,:)';
    Target_Pixel(1,1)=Origan_Pixel(1,1)+1;Target_Pixel(1,2)=Origan_Pixel(1,2);
    Target_Pixel(2,1)=Origan_Pixel(1,1);Target_Pixel(2,2)=Origan_Pixel(1,2)+1;
    Target_Pixel(3,1)=Origan_Pixel(1,1)+1;Target_Pixel(3,2)=Origan_Pixel(1,2)+1;
    for k=1:size(Target_Pixel,1)
        [Idx2,~]=find(Potential_Location(:,1)==Target_Pixel(k,1)&Potential_Location(:,2)==Target_Pixel(k,2));
        if ~isempty(Idx2)
            Target_signal=MAT_features(Idx2,:)';
            Signal(:,1)=Origan_signal+Target_signal;
            Signal(:,2)=abs(Origan_signal-Target_signal);

            [x,~]=find(Signal(:,1)>0);
            Total_Num=size(x,1);

            [x,~]=find(Signal(:,1)>0&Signal(:,2)==0);
            Same_Num=size(x,1);

            TSNE_Location2=TSNEProjection(Idx2,1:2);

            TSNE_Location=[TSNE_Location1;TSNE_Location2];
            TSNE_Location_Mean=mean(TSNE_Location,1);

            Pixel_Relation(M,1)=Idx1;
            Pixel_Relation(M,2)=Idx2;
            Pixel_Relation(M,3)=Same_Num/Total_Num;
            Pixel_Relation(M,4)=pdist2(TSNE_Location1,TSNE_Location2);
            Pixel_Relation(M,5)=pdist2(TSNE_Location_Mean,Zero_location);
            M=M+1;
        end
    end
    str=['分析进度……',num2str(i/size(Potential_Location,1)*100),'%'];
    waitbar(i/size(Potential_Location,1),h,str);
end
delete(h);
end