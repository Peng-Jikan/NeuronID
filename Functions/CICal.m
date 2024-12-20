function [Entropy] = CICal(x,y)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明

A=x(:);
B=y(:);

A1=0;B1=0;C1=0;
[x,~]=find(A(:,1)>0);
if ~isempty(x)
    A1=size(x,1);
end

[x,~]=find(B(:,1)>0);
if ~isempty(x)
    B1=size(x,1);
end

C=A.*B;
[x,~]=find(C(:,1)>0);
if ~isempty(x)
    C1=size(x,1);
end

A1=A1/size(A,1);
B1=B1/size(A,1);
D1=size(A,1)*A1*B1;

F1=size(A,1)*((A1*B1)^(0.5));

Entropy=0;
if A1~=0&&B1~=0
    Entropy=(C1-D1)/F1;
end

end