function [a] = ReconstructionLoss(inputArg1,inputArg2)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
inputArg1(isnan(inputArg1))=0;
inputArg2(isnan(inputArg2))=0;
c=inputArg1-inputArg2;
b=sum(sum(c));
a=b/(size(inputArg1,1)*size(inputArg1,2));
end