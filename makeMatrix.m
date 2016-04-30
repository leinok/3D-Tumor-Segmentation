% Make Matrix
function [M, totalNum] = makeMatrix(startFile, endFile, startPath, endPath)


expression = '\_';
[pathstr,name,ext] = fileparts(startFile);
splitStr = regexp(name,expression,'split');
numString = splitStr(end);
startNum = str2double(numString);

[pathstr,name,ext] = fileparts(endFile);
splitStr = regexp(name,expression,'split');
numString = splitStr(end);
endNum = str2double(numString);

temp = splitStr(1:end-1);

for i = 1:length(temp)
    if i == 1
        file = [temp{i} '_'];
    else
        file = [file temp{i} '_'];
    end
end

totalNum = endNum - startNum + 1;
imgMatrix = zeros(512, 512, totalNum);

j = 1;
for i = 1:totalNum
    num = startNum + i - 1;
    if num > 99
        cNum = num2str(num);
    else
        if num >= 10
            cNum = ['0' num2str(num)];
        else
            cNum = ['00' num2str(num)];
        end
    end
    fileNmae = [startPath file cNum '.dcm'];
    imgMatrix(:,:,j) =  dicomread(fileNmae);
    j = j + 1;
end

M = imgMatrix;
end