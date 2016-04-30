%
function Y = kinetic(startFile, endFile, startPath, endPath, position)
addpath(genpath('CMF'));

startSlice = position(5);
endSlice = position(6);

if nargin < 4
    startFile = 'HB17158_MR_0A0CABC7_01_100_01_065';
    endFile = 'HB17158_MR_0A0CABC7_01_100_01_128';
    startPath = '~/bin zheng/Breast-MRI/NA001/Date_20050101/1/';
    endPath = '~/bin zheng/Breast-MRI/NA001/Date_20050101/1/';
else
    startPath = ['~/bin zheng/Breast-MRI/' char(startPath) '/'];
    endPath = ['~/bin zheng/Breast-MRI/' char(endPath) '/'];
end

[M, num] = makeMatrix(char(startFile), char(endFile), startPath, endPath);
% There should be a pre-processing to remove the body part
M = M(position(7):end, :, :);
Y = M(52:56,112:117,37);

