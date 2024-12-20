function [Entropy] = MICal(x,y)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明

Pairwise=[x y];
p=1;P=[];
for m=0:1
    for n=0:1
        [x,~]=find(Pairwise(:,1)==m);
        if ~isempty(x)
            P(1,p)=size(x,1)/size(Pairwise,1);
        end
        if isempty(x)
            P(1,p)=0;
        end

        [x,~]=find(Pairwise(:,2)==n);
        if ~isempty(x)
            P(2,p)=size(x,1)/size(Pairwise,1);
        end
        if isempty(x)
            P(2,p)=0;
        end

        [x,~]=find(Pairwise(:,1)==m&Pairwise(:,2)==n);
        if ~isempty(x)
            P(3,p)=size(x,1)/size(Pairwise,1);
        end
        if isempty(x)
            P(3,p)=0;
        end
        p=p+1;
    end
end

Entropy=0;
for m=1:size(P,2)
    if P(3,m)>0
        Entropy=Entropy+P(3,m)*log2(P(3,m)/(P(1,m)*P(2,m)));
    end
end

end