clear
close all
dataPath = '../../bin zheng/Breast-MRI/NA001/Date_20050101/1';
addpath(dataPath);

% fileLists = dir(dataPath);
% fileLists = fileLists(3:end);

startNum = 160;
endNum = 176;
imgMatrix = zeros(512, 512, endNum - startNum + 1);
j = 1;
for i = startNum:endNum
    fileNmae = ['HB17158_MR_0A0CABC7_01_101_01_' num2str(i) '.dcm'];
    imgMatrix(:,:,j) =  dicomread(fileNmae);
    j = j + 1;
end

imgMatrix = zeros(512, 512, 64);
% from 7th to 70th, they are suppose to in the same sequence
for iter = 7:70         
    a = dicominfo(fileLists(iter).name);
    fileLists(iter).name
    imgMatrix(:,:,iter-6) = dicomread(fileLists(iter).name);
%     imshow(imgMatrix(:,:,iter-6), [0 500]);
%     pause(0.3);
end
% 

tt = imgMatrix(208:380,:,:);
[rows, cols, height] = size(tt);
figure, isosurface(imgMatrix(208:380,:,:), 80);
% axis([1 rows 1 cols 1 height]);
% rotate3d on;
