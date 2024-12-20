function OUT= DecaySignal(Signal,Sigma)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
[~,y]=find(Signal(1,:)<=0);
if ~isempty(y)
    Signal2=Signal(1,y);
end

[~,y]=find(Signal(1,:)>=std2(Signal2)*Sigma);
Decay=zeros(1,size(Signal,2));
Decay(1,y)=1;
DecaySignal=Decay;
for i=2:(size(Decay,2)-1)
    if Decay(1,i)==1&&Decay(1,i-1)==0&&Decay(1,i+1)==0
        DecaySignal(1,i)=0;
    end
end
OUT=DecaySignal;
end

