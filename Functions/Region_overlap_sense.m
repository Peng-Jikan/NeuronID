function [Region_Near,Region_Near_unique] = Region_overlap_sense(Diff_Projection,Potential_Location,ROI_num)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
Region_Label = Diff_Projection .* 0;
for ii = 1:size(Potential_Location, 1)
    Region_Label(Potential_Location(ii, 1), Potential_Location(ii, 2)) = Potential_Location(ii, 4);
end
Region_Near=[];k=1;
h=waitbar(0,'please wait');
for i=1:ROI_num
    [x,~]=find(Potential_Location(:,4)==i);
    if ~isempty(x)
        Location=Potential_Location(x,1:2);
        X_min=min(Location(:,1));X_max=max(Location(:,1));
        Y_min=min(Location(:,2));Y_max=max(Location(:,2));
        [x,~]=find(Potential_Location(:,1)>=(X_min-3)&Potential_Location(:,1)<=(X_max+3)...
            &Potential_Location(:,2)>=(Y_min-3)&Potential_Location(:,2)<=(Y_max+3));
        Potential_ID=Potential_Location(x,4);
        Potential_ID=unique(Potential_ID);

        for j=1:size(Potential_ID,1)
            if Potential_ID(j,1)~=i&&Potential_ID(j,1)~=0
                region=Region_Label;
                region(region==i)=ROI_num+1;
                region(region==Potential_ID(j,1))=ROI_num+1;
                region(region<ROI_num+1)=0;
                region(region==ROI_num+1)=1;
                [~, numRegions] = bwlabel(region);
                if numRegions==1
                    Region_Near(k,1)=min(i,Potential_ID(j,1));
                    Region_Near(k,2)=max(i,Potential_ID(j,1));
                    k=k+1;
                end
            end
        end
    end
    str=['分析进度……',num2str(i/ROI_num*100),'%'];
    waitbar(i/ROI_num,h,str);
end
delete(h);
Region_Near_unique=unique(Region_Near,'rows');
end