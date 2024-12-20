function [Fc_corrected,r_opt] = NeuropilSubtraction1(Flsorescene,Neuropil)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
% Example data
Fm = Flsorescene(:,1);  % Measured fluorescence trace
Fn = Neuropil(:,1);  % Neuropil fluorescence trace
lambda = 0.05;


% 计算最优的r值和校正荧光轨迹
options = optimset('Display', 'iter'); % 显示迭代过程
cost_function = @(r) neuropil_cost(r, Fm, Fn, lambda);
[r_opt, ~] = fminsearch(cost_function, 0.5, options); % 初始猜测为0.5

% 使用最优的r值计算最终的校正荧光轨迹
Fc_corrected = Fm - r_opt * Fn;


% 成本函数定义
function cost = neuropil_cost(r, Fm, Fn, lambda)
    Fc = Fm - r * Fn;
    LFc = [diff(Fc); 0]; % 计算一阶导数，并补充最后一个元素以匹配尺寸
    cost = sum((Fc - Fm + r * Fn).^2) + lambda * sum(LFc.^2);
end

end