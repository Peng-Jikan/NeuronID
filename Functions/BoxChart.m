function Hdl=BoxChart(ax,X,Y1,FaceColor,Alpha)
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

x = X-0.3 + 0.6 * rand(1, size(Y1,1));
scatter(x,Y1,30,'MarkerFaceColor',FaceColor,'MarkerEdgeColor','none','MarkerFaceAlpha',Alpha);
outliBool=isoutlier(Y1,'quartiles');
Y1=Y1(~outliBool);
qt0=min(Y1);
qt25=quantile(Y1,0.25);
qt75=quantile(Y1,0.75);
qt100=max(Y1);

y=qt0:(qt100-qt0)/50:qt100;x=y.*0+X;
plot(x,y,'Color',[0 0 0],'LineWidth',1,'LineStyle',':');
x=(X-0.1):0.01:(X+0.1);y=x.*0+qt0;
plot(x,y,'Color',[0 0 0],'LineWidth',1);
x=(X-0.1):0.01:(X+0.1);y=x.*0+qt100;
plot(x,y,'Color',[0 0 0],'LineWidth',1);

x=(X-0.3):0.01:(X+0.3);
y1=x.*0+qt25;y2=x.*0+qt75;
Hdl.F_density(1)=fill([x, fliplr(x)], [y1, fliplr(y2)],FaceColor,'EdgeColor',[0 0 0],'FaceAlpha',0.5,'LineWidth',0.5);hold on;
y=x.*0+mean(Y1);
plot(x,y,'Color',[0 0 0],'LineWidth',1);

scatter(X,mean(Y1),50,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 0],'LineWidth',1);

end