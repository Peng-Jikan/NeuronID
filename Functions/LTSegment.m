function [Loss,Trail] = LTSegment(Simutaneous_Firing,LT,TimeLabel_Signal)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
Loss=sum(abs(Simutaneous_Firing(:,1)-LT(:,1)))/size(Simutaneous_Firing,1);

LT_Segment=LT(2:end,1)-LT(1:end-1,1);
LT_Segment=[LT_Segment;LT_Segment(end,1)];
LT_Segment(LT_Segment>0)=1;
LT_Segment(LT_Segment<0)=-1;

for i=3:size(LT_Segment,1)-3
    if LT_Segment(i-2,1)==LT_Segment(i-1,1)&&LT_Segment(i-1,1)==LT_Segment(i+1,1)&&LT_Segment(i+2,1)==LT_Segment(i+1,1)
        LT_Segment(i,1)=LT_Segment(i-1,1);
    end
end

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

Trail11(:,3)=LT_Segment(Trail11(:,1),1);

Trail11(:,4)=TimeLabel_Signal(Trail11(:,2),1)-TimeLabel_Signal(Trail11(:,1),1);

[x,~]=find(Trail11(:,4)>0);

Trail=Trail11(x,:);

end
