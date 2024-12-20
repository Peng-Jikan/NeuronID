function Hdl=BoxChart1(ax,X,Y1,FaceColor,Alpha)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
if nargin < 5
    Alpha=0.5;
end

if ~isempty(ax)
else
    ax=gca;
end
hold(ax,'on');


x=(X-0.3):0.01:(X+0.3);
y1=x.*0+0;y2=x.*0+mean(Y1);
Hdl.F_density(1)=fill([x, fliplr(x)], [y1, fliplr(y2)],FaceColor,'EdgeColor',[0 0 0],'FaceAlpha',Alpha,'LineWidth',0.5);hold on;

SEM=std(Y1)/sqrt(length(Y1));
x=(X-0.1):0.01:(X+0.1);y=x.*0+mean(Y1)+SEM;
plot(x,y,'Color',[0 0 0],'LineWidth',1.5);

y=mean(Y1):0.0001:(mean(Y1)+SEM);x=y.*0+X;
plot(x,y,'Color',[0 0 0],'LineWidth',1.5);

end