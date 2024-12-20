function [Potential_Location,ROI1_Num] = CombineRegion(Potential_Location,Diff_Projection,MAT_features)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明

for iii=1:10
    Old_ID=Potential_Location(:,5);New_ID=Old_ID.*0;
    TDLocation=[];N_max=max(Old_ID(:,1));
    h=waitbar(0,'please wait');
    for i=1:N_max
        [x,~]=find(Old_ID(:,1)==i);
        Location=Potential_Location(x,1:2);
        TDLocation(i,:)=mean(Location);
        str=['分析进度1/2……',num2str(i/N_max*100),'%'];
        waitbar(i/N_max,h,str);
    end
    delete(h);

    mat=[];h=waitbar(0,'please wait');Target_Pair=[];
    for i=1:N_max
        target=TDLocation(i,:);
        [x,~]=find(TDLocation(:,1)>=(target(1,1)-50)&TDLocation(:,1)<=(target(1,1)+50)&TDLocation(:,2)>=(target(1,2)-50)&TDLocation(:,2)<=(target(1,2)+50));

        Target_ID=i;
        Target_May=x;

        [x,~]=find(Target_May(:,1)~=Target_ID);
        if ~isempty(x)
            Target_May=Target_May(x,1);

            if i>1
                [x,~]=find(Target_Pair(:,1)==Target_ID);
                target=Target_Pair(x,2);
                Target_May=Target_May(~ismember(Target_May, target));

                if ~isempty(Target_May)
                    [x,~]=find(Target_Pair(:,2)==Target_ID);
                    target=Target_Pair(x,1);
                    Target_May=Target_May(~ismember(Target_May, target));
                end
            end

            if ~isempty(Target_May)
                [Region_overlap] = RegionOverlapPixel2(Diff_Projection,Target_May,Target_ID,Potential_Location,MAT_features);
                if ~isempty(Region_overlap)
                    mat=[mat;Region_overlap];
                end
            end
        end
        Target=[];
        Target(:,2)=Target_May;
        Target(:,1)=Target(:,1)+Target_ID;
        Target_Pair=[Target_Pair;Target];

        str=['分析进度2/2……',num2str(i/N_max*100),'%'];
        waitbar(i/N_max,h,str);
    end
    delete(h);


    Mat=[];
    [x,~]=find(mat(:,3)>0&mat(:,4)>0);
    if ~isempty(x)
        Mat=mat(x,:);
    end
    Mat=unique(Mat,"rows");
    for i=1:size(Mat,1)
        Mat(i,10)=Mat(i,8)/Mat(i,9);
    end
    [x,~]=find(Mat(:,10)<0.1);
    Mat=Mat(x,:);

    vectors={};
    if ~isempty(Mat)
        [vectors] = CombineROI(Mat(:,1:2));
    end

    USED_ROI=[];
    if ~isempty(vectors)
        for i = 1:length(vectors)
            A=vectors{i};A=A';
            USED_ROI=[USED_ROI;A];
            for j=1:size(A,1)
                [x,~]=find(Old_ID(:,1)==A(j,1));
                New_ID(x,1)=i;
            end
        end
    end

    if ~isempty(USED_ROI)
        ROI1_Num=max(New_ID(:,1))+1;
        for i=1:N_max
            containsElement = any(ismember(USED_ROI, i));
            if containsElement==0
                [x,~]=find(Old_ID(:,1)==i);
                New_ID(x,1)=ROI1_Num;
                ROI1_Num=ROI1_Num+1;
            end
        end
        ROI1_Num=ROI1_Num-1;
    end
    if isempty(USED_ROI)
        ROI1_Num=1;
        for i=1:N_max
            [x,~]=find(Old_ID(:,1)==i);
            New_ID(x,1)=ROI1_Num;
            ROI1_Num=ROI1_Num+1;
        end
        ROI1_Num=ROI1_Num-1;
    end
    Potential_Location(:,5)=New_ID;

   
    if isequal(New_ID, Old_ID)
        disp(['Combine Finshed:',num2str(ROI1_Num),'循环次数',num2str(iii)]);
        break;
    else
        disp(['Combine Continue:',num2str(ROI1_Num),'循环次数',num2str(iii)]);
    end
end

end