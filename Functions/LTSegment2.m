function [Trail2] = LTSegment2(Trail,LT,TimeLabel_Signal)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

[x,~]=find(Trail(:,3)==-1);Trail_Descend=Trail(x,:);
[x,~]=find(Trail(:,3)==1);Trail_Ascend=Trail(x,:);

Mini_Trail=[];
for i=1:size(Trail_Descend,1)
    Mini_Trail(i,1:2)=Trail_Descend(i,1:2);
    [x,~]=find(Trail_Ascend(:,1)==Trail_Descend(i,2));
    if ~isempty(x)
        Mini_Trail(i,3)=Trail_Ascend(x(1,1),2);
    end
end
[x,~]=find(Mini_Trail(:,3)~=0);
Mini_Trail=Mini_Trail(x,:);

Mini_Trail(:,4)=LT(Mini_Trail(:,2),1);

LT_Segment=Mini_Trail(2:end,4)-Mini_Trail(1:end-1,4);
LT_Segment=[LT_Segment;LT_Segment(end,1)];
LT_Segment(LT_Segment>0)=1;
LT_Segment(LT_Segment<0)=-1;

Trail0=[];k=1;
for i=1:size(LT_Segment,1)-1
    if LT_Segment(i,1)~=LT_Segment(i+1,1)
        Trail0(k,1)=i+1;
        k=k+1;
    end
end
Trail0=[1;Trail0;size(LT_Segment,1)];
Trail11=[];k=1;
for i=1:size(Trail0,1)-1
    Trail11(k,1)=Trail0(i,1);
    Trail11(k,2)=Trail0(i+1,1);
    k=k+1;
end

Trail2=[];
for i=1:size(Trail11,1)
    Trail2(i,1)=Mini_Trail(Trail11(i,1),2);
    Trail2(i,2)=Mini_Trail(Trail11(i,2),2);
    Trail2(i,3)=LT_Segment(Trail11(i,1),1);
end
Trail2(:,4)=TimeLabel_Signal(Trail2(:,2),1)-TimeLabel_Signal(Trail2(:,1),1);

Trail2=sortrows(Trail2,1);
for i=1:size(Trail2,1)
    a=LT(Trail2(i,1),1);
    b=LT(Trail2(i,2),1);
    c=abs(b-a);
    Trail2(i,5)=c/a*100;
    Trail2(i,6)=c/Trail2(i,4);
end

end