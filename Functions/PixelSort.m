function [Pixel_Pro] = PixelSort(Sort_ROI)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
Sort_ROI = normalize(Sort_ROI, 'range');
Sort_ROI=Sort_ROI.^2;
Pixel_Pro=sum(Sort_ROI,2);
Pixel_Pro=Pixel_Pro.^0.5;
end