 % Breast Tumor Analysis
 function [volumeFilled] = breasTumorAnalysis(startFile, endFile, startPath, endPath, position)

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

choice = 0;

volume = 0;
volumeFilled = 0;

lengthRECIST = 0;
%----------------------------------------------------------------------------
if choice == 0      % CMF
    [u, erriter, i, timet] = CMF3D_Cut(M);
    
    beta = 0.1;
  
%     show the segmentation
    fHandle1 = figure('Name', 'Segmented voxel', 'NumberTitle', 'Off'), ...
        isosurface(u,beta), title('Tumor Segmentation');
    h1 = rotate3d(fHandle1);
    set(h1, 'Enable', 'on');
    
    
    us = max(u, beta);  % where beta in (0,1)
    volume = 0;
    
   
    for iter = 1:num
        % if there is some tumor detected
        % 1. fill the holes
        tempImg = u(:,:,iter);
        bw = im2bw(tempImg);
        bw = imdilate(bw, ones(2,2));
        bw1 = imfill(bw, 'holes');
        bwA = zeros(size(bw));
        bwA(position(1):position(3), position(2):position(4)) = 1;
        bw= bw .* bwA;
        [rows, cols] = find(bw == 1);
        vol = length(rows);
               
        if vol > 0 
            if iter >= startSlice && iter <= endSlice
            volFill = length(find(bw1(:) == 1));
        
            volume = volume + vol;
            volumeFilled = volumeFilled + volFill;
            X = [rows, cols];
            
            dist = sqrt(bsxfun(@minus, X(:,1), X(:,1)').^2 + ... 
                   bsxfun(@minus, X(:,2), X(:,2)').^2);
            maxDist = max(dist(:));
            [maxR,maxC] = find(dist == maxDist);
            end
         % 2. Calculate the RECIST   (need to make sure that the distance is in the same region!)
%             if maxDist > lengthRECIST
%                 bw2 = imopen(bw1, ones(2,2));
%                 cc = bwconncomp(bw2);
%                 L = labelmatrix(cc);
%                 
%                 lengthRECIST = maxDist;                            
%                 p1 = X(maxR(1),:);
%                 p2 = X(maxC(1),:);
%                 figure, imshow(bw);
%                 hold on;
%                 plot([p1(2),p2(2)],[p1(1),p2(1)],'Color','r','LineWidth',1);
%                 close(gcf) ;
%                  lengthRECIST = 0;   %need to be deleted, just for test
%             end

        end

        
    end
%----------------------------------------------------------    
elseif choice == 1  % Graph Cuts 3D
    volume = interactive_graph_cuts3D(M);
end

