function Hdl=violinChart(ax,X,Y,FaceColor,Alpha)
% @author slandarer
% Hdl: 返回的图形对象句柄结构体
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Hdl.F_density(i)   | patch   | 核密度分布
% Hdl.F_outlier(i)   | scatter | 离群值点
% Hdl.F_range95(i)   | line    | 去除离群值点后最大值及最小值
% Hdl.F_quantile(i)  | patch   | 四分位数框
% Hdl.F_medianLine(i)| line    | 中位数
%
% Hdl.F_legend       | patch   | 用于生成legend图例的图形对象
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% 请使用如下方式生成图例：
% Hdl1=violinChart(ax,X,Y,... ...)
% Hdl2=violinChart(ax,X,Y,... ...)
% ... ...
% legend([Hdl1,Hdl2,... ...],{Name1,Name2,...})
% ===========================================================
% 以下为使用实例代码：
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% X1=[1:2:7,13];
% Y1=randn(100,5)+sin(X1);
% X2=2:2:10;
% Y2=randn(100,5)+cos(X2);
% 
% Hdl1=violinChart(gca,X1,Y1,[0     0.447 0.741],0.5);
% Hdl2=violinChart(gca,X2,Y2,[0.850 0.325 0.098],0.5);
% legend([Hdl1.F_legend,Hdl2.F_legend],{'randn+sin(x)','randn+cos(x)'});
if nargin < 5
    Alpha=0.5;
end
if Alpha<0.2
    Alpha=0.5;
end
oriX=X;
if ~isempty(ax)
else
    ax=gca;
end
hold(ax,'on');

for i=1:length(X)
    if length(oriX)==numel(Y)
        tY=Y(oriX==X(i));
    else
        tY=Y(:,i);
    end
    outliBool=isoutlier(tY,'quartiles');
    outli=tY(outliBool);
    tY=tY(~outliBool);
    [f,yi]=ksdensity(tY);
    r=max(f)/0.3;
    Hdl.F_density(i)=fill([f,-f(end:-1:1)]/r+X(i),[yi,yi(end:-1:1)],FaceColor,'Facealpha',Alpha,'EdgeColor',[0.5 0.5 0.5]);
    
    qt25=quantile(tY,0.25);
    qt75=quantile(tY,0.75);
    YY=qt25:0.001:qt75;XX=zeros(1,size(YY,2))+X(i);
    plot(XX,YY,'Color',[0.3 0.3 0.3],'LineWidth',2);

    Med=mean(tY);
    scatter(X(i),Med,40,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0.5 0.5 0.5]);

    
end