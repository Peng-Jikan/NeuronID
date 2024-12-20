function [Region_Near] = Region_overlap_sense2(ROI_Label,Diff_Projection,Potential_Location)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
Region_Near=[];k=1;
h=waitbar(0,'please wait');
for i=1:size(ROI_Label,2)-1
    [x,~]=find(ROI_Label(:,i)==1);
    Location1=Potential_Location(x,1:2);
    for j=i+1:size(ROI_Label,2)
        [x,~]=find(ROI_Label(:,j)==1);
        Location2=Potential_Location(x,1:2);

        Location=[Location1; Location2];
        Region_Label = Diff_Projection .* 0;
        for ii = 1:size(Location, 1)
            Region_Label(Location(ii, 1), Location(ii, 2)) = 1;
        end
        [~, numRegions] = bwlabel(Region_Label);
        if numRegions==1
            if size(Location1,1)<=size(Location2,1)
                Region_Near(k,1)=i;
                Region_Near(k,2)=j;
                k=k+1;
            end
            if size(Location1,1)>size(Location2,1)
                Region_Near(k,1)=j;
                Region_Near(k,2)=i;
                k=k+1;
            end
        end

    end
    str=['分析进度1/2……',num2str(i/size(ROI_Label,2)*100),'%'];
    waitbar(i/size(ROI_Label,2),h,str);
end
delete(h);
end