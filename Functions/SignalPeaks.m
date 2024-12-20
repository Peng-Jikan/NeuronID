function [Positive_negtive,Positive_label] = SignalPeaks(Calcium_signal)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
[x,~]=find(Calcium_signal(:,1)<0);target=Calcium_signal(x,1);Event_threshold(1,1)=3*std(target);
vector=zeros(size(Calcium_signal,1),1);[x,~]=find(Calcium_signal(:,1)>=Event_threshold(1,1));
if ~isempty(x)
    vector(x,1)=1;result=vector;
    for i=2:(size(vector,1)-1)
        if vector(i,1)==1&&vector(i-1,1)==0&&vector(i+1,1)==0
            result(i,1)=0;
        end
    end
    [x1,~]=find(result(:,1)==1);
    if ~isempty(x1)
        Positive_negtive(1,1)=size(x1,1)/size(vector,1)*100;
    end
    if isempty(x1)
        Positive_negtive(1,1)=0;
    end
end
if isempty(x)
    Positive_negtive(1,1)=0;
    result=0;
end
Positive_label=result;

[x,~]=find(Calcium_signal(:,1)>0);target=Calcium_signal(x,1);Event_threshold(1,2)=-3*std(target);
vector=zeros(size(Calcium_signal,1),1);[x,~]=find(Calcium_signal(:,1)<=Event_threshold(1,2));
if ~isempty(x)
    vector(x,1)=1;result=vector;
    for i=2:(size(vector,1)-1)
        if vector(i,1)==1&&vector(i-1,1)==0&&vector(i+1,1)==0
            result(i,1)=0;
        end
    end
    [x1,~]=find(result(:,1)==1);
    if ~isempty(x1)
        Positive_negtive(1,2)=size(x1,1)/size(vector,1)*100;
    end
    if isempty(x1)
        Positive_negtive(1,2)=0;
    end
end
if isempty(x)
    Positive_negtive(1,2)=0;
end
end