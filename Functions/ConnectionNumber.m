function [Con_num,Diameter_ratio,Diameter_overlap] = ConnectionNumber(Location1,Location2,Region)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
Con_num=0;
Region1=Region;
Region1(Location1(:,1),Location1(:,2))=1;
Region2=Region;
Region2(Location2(:,1),Location2(:,2))=1;

stats = regionprops(Region1,"MaxFeretProperties","MinFeretProperties");
B1=stats(1).MaxFeretDiameter;
stats = regionprops(Region2,"MaxFeretProperties","MinFeretProperties");
B2=stats(1).MaxFeretDiameter;

B=max(B1,B2);

Region(Location1(:,1),Location1(:,2))=1;
Region(Location2(:,1),Location2(:,2))=1;
stats = regionprops(Region,"MaxFeretProperties","MinFeretProperties");
C=stats(1).MaxFeretDiameter;

Diameter_overlap=C;
Diameter_ratio=C/B;

for i=1:size(Location1,1)
    for j=1:size(Location2,1)
        A=abs(Location1(i,1)-Location2(j,1));
        B=abs(Location1(i,2)-Location2(j,2));
        if A+B==1
            Con_num=Con_num+1;
        end
    end
end
end