function [Decision] = NeedTrainAI2(T,DataFile,FilePathTrue)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
RegistrationFiles=strcat(DataFile,'\Registration');
cd(RegistrationFiles);
namelist=dir(strcat(RegistrationFiles,'\*.tif'));

cd(RegistrationFiles);
B=namelist(1,1);
filename=B.name;
imgInfo = imfinfo(filename);
M(1,1)=imgInfo.Width;M(1,2)=imgInfo.Height;M(1,3)=T;
cd(FilePathTrue);

Decision=0;
if M(1,1)==512&&M(1,2)==512&&M(1,3)==83.67
    folderA=[FilePathTrue,'\AIModel\','Denoise Model (512 512 83.67ms)'];Decision=1;
end
if M(1,1)==512&&M(1,2)==512&&M(1,3)==100.14
    folderA=[FilePathTrue,'\AIModel\','Denoise Model (512 512 100.14ms)'];Decision=1;
end
if M(1,1)==512&&M(1,2)==512&&M(1,3)==104.33
    folderA=[FilePathTrue,'\AIModel\','Denoise Model (512 512 104.33ms)'];Decision=1;
end
if M(1,1)==600&&M(1,2)==512&&M(1,3)==108.20
    folderA=[FilePathTrue,'\AIModel\','Denoise Model (600 512 108.20ms)'];Decision=1;
end
if M(1,1)==600&&M(1,2)==512&&M(1,3)==110.06
    folderA=[FilePathTrue,'\AIModel\','Denoise Model (600 512 110.06ms)'];Decision=1;
end
if M(1,1)==600&&M(1,2)==512&&M(1,3)==110.04
    folderA=[FilePathTrue,'\AIModel\','Denoise Model (600 512 110.06ms)'];Decision=1;
end
if M(1,1)==600&&M(1,2)==512&&M(1,3)==115.78
    folderA=[FilePathTrue,'\AIModel\','Denoise Model (600 512 115.78ms)'];Decision=1;
end
if M(1,1)==600&&M(1,2)==512&&M(1,3)==115.77
    folderA=[FilePathTrue,'\AIModel\','Denoise Model (600 512 115.78ms)'];Decision=1;
end
if M(1,1)==600&&M(1,2)==512&&M(1,3)==127.32
    folderA=[FilePathTrue,'\AIModel\','Denoise Model (600 512 127.32ms)'];Decision=1;
end
if M(1,1)==600&&M(1,2)==512&&M(1,3)==105.94
    folderA=[FilePathTrue,'\AIModel\','Denoise Model (600 512 105.94ms)'];Decision=1;
end

if Decision==1
    folderB=[DataFile,'\','Denoise'];
    % 获取A文件夹下的所有文件
    fileList = dir(fullfile(folderA, '*.mat'));

    % 复制文件到B文件夹
    for i = 1:length(fileList)
        fileName = fileList(i).name; % 获取文件名

        % 构建源文件和目标文件的完整路径
        sourceFile = fullfile(folderA, fileName);
        targetFile = fullfile(folderB, fileName);

        % 复制文件
        copyfile(sourceFile, targetFile);
    end

end

end