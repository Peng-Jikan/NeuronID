function [Min_Matrix] = SliceMatrix(m,n)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
row_number = ceil(m/512); %原矩阵行数可以拆分小矩阵的数量
col_number = ceil(n/512); %原矩阵列数可以拆分小矩阵的数量
Min_Matrix=[];k=1;
for i=1:row_number
    for j=1:col_number
        if i==row_number
            Min_Matrix(k,1)=m-511;
            Min_Matrix(k,2)=m;
        else
            Min_Matrix(k,1)=1+(i-1)*512;
            Min_Matrix(k,2)=Min_Matrix(k,1)+511;
        end
        if j==col_number
            Min_Matrix(k,3)=n-511;
            Min_Matrix(k,4)=n;
        else
            Min_Matrix(k,3)=1+(j-1)*512;
            Min_Matrix(k,4)=Min_Matrix(k,3)+511;
        end
        k=k+1;
    end
end
end