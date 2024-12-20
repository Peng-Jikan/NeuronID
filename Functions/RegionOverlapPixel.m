function [Region_overlap] = RegionOverlapPixel(Diff_Projection,Target_May,Target_ID,Potential_Location,MAT_features)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
Region_overlap=[];W=1;
for i=1:size(Target_May,1)
    Region=Diff_Projection.*0;
    region=Diff_Projection.*0;
    [x,~]=find(Potential_Location(:,4)==Target_ID);
    Location1=Potential_Location(x,1:2);
    Region(Location1(:,1),Location1(:,2))=1;
    [x,~]=find(Potential_Location(:,4)==Target_May(i,1));
    Location2=Potential_Location(x,1:2);
    Region(Location2(:,1),Location2(:,2))=1;
    [~,N] = bwlabel(Region);
    
    if N==1
        [Con_num,Diameter_ratio,Diameter_overlap] = ConnectionNumber(Location1,Location2,region);
        if size(Location1,1)<=size(Location2,1)
            Target_min=Target_ID;Target_max=Target_May(i,1);
        end
        if size(Location1,1)>size(Location2,1)
            Target_max=Target_ID;Target_min=Target_May(i,1);
        end
        [x,~]=find(Potential_Location(:,4)==Target_min);
        Feature_min=MAT_features(x,:);
        [x,~]=find(Potential_Location(:,4)==Target_max);
        Feature_max=MAT_features(x,:);

        A=sum(Feature_min,1);[~,Y1]=find(A(1,:)>=5);
        A=sum(Feature_max,1);[~,Y2]=find(A(1,:)>=5);

        if size(Y1,2)>0&&size(Y2,2)>0
            Pixel_Num=zeros(size(Feature_min,1),1);
            for j=1:size(Feature_min,1)
                for k=1:size(Feature_max,1)
                    signal1=Feature_min(j,:);
                    signal2=Feature_max(k,:);
                    signal3=signal1.*signal2;signal3(signal3>0)=1;
                    S3=sum(signal3(1,:));
                    signal4=signal1+signal2;signal4(signal4>0)=1;
                    S4=sum(signal4(1,:));
                    r = S3/S4;
                    if r>0.5
                        Pixel_Num(j,1)=Pixel_Num(j,1)+1;
                    end
                end
            end
            [x,~]=find(Pixel_Num(:,1)>0);

            R=size(x,1)/size(Feature_min,1);

            Region_overlap(W,1)=Target_min;Region_overlap(W,2)=Target_max;Region_overlap(W,3)=R;Region_overlap(W,4)=Con_num;
            Region_overlap(W,5)=Diameter_overlap;Region_overlap(W,6)=Diameter_ratio;Region_overlap(W,7)=size(x,1);
            Region_overlap(W,8)=size(Feature_min,1);Region_overlap(W,9)=size(Feature_max,1);
            W=W+1;
        end
    end
end
end