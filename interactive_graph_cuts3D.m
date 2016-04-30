function [volume] = interactive_graph_cuts3D(testM)
% Try to modified to use in 3D case
% Interactive Graph cuts Segmentation Algorithm
% Towards Medical Image Analysis course
% By Ravindra Gadde, Raghu Yalamanchili

% Interactive Graph cut segmentation using max flow algorithm as described
% in Y. Boykov, M. Jolly, "Interactive Graph Cuts for Optimal Boundary and
% Region Segmentation of Objects in N-D Images", ICCV, 2001.
% close all;
K=10; % Large constant
sigma=1;% Similarity variance
lambda=10^12;% Terminal Constant
c=10^5;% Similarity Constant
% mex maxflowmex.cpp maxflow-v3.0\graph.cpp maxflow-v3.0\maxflow.cpp % Mex
mex -largeArrayDims 'maxflowmex.cpp' 'maxflow-v3.0/graph.cpp' 'maxflow-v3.0/maxflow.cpp'

% im = imread('abdomen.jpg'); % Read image
% tt = dicomread('106.dcm');
% im(:,:,1) = tt(208:388, :);
% tt = dicomread('107.dcm');
% im(:,:,2) = tt(208:388, :);
% tt = dicomread('108.dcm');
% im(:,:,3) = tt(208:388, :);

% load testMatrix1;
% im = tt;
im = testM;
if length(size(im(:,:,1))) == 3
    m = double(rgb2gray(im));
else
    m = double(im);
end

[height,width, znum] = size(m);

disp('building graph');

N = height*width;

% construct graph
% Calculate weighted graph
% E = edges4connected(height,width);
E = edges6connected(height, width, znum);
V = c*exp(-abs(m(E(:,1))-m(E(:,2))))./(2*sigma^2);
A = sparse(E(:,1),E(:,2),V,znum*N,znum*N,6*znum*N);
% load 'ground_abdomen.mat' % Comment this part to manually select seeds
% Uncomment this part to manually select seeds
chosedNum = ceil(znum/2);

figure, imshow(m(:,:,chosedNum),[0 1000]);
disp('select foreground pixels');
[x,y] = ginput(30);
fg(:,1)=ceil(y);
fg(:,2)=ceil(x);
% calcualate Terminal weights

imshow(m(:,:,chosedNum),[0 1000]);
disp('select background pixels');
[x1,y1] = ginput(30);
bg(:,1)=ceil(y1);
bg(:,2)=ceil(x1);
T = calc_weights3D(m,fg,bg,K,lambda,chosedNum); 


%Max flow Algorithm
disp('calculating maximum flow');

[flow,labels] = maxflow(A,T);
labels = reshape(labels,[height width znum]);
for k = 1:znum
    for i = 1: height
        for j = 1: width
            if(labels(i,j, k)==0)
                im_segment(i,j,k)=im(i,j,k);

            else
                im_segment(i,j,k)=0;


            end
        end
    end
end
% show(im_segment(:,:,39));
figure,isosurface(im_segment, 500), axis([0 height 0 width 0 znum]), title('Seeds Segmentation');
rotate3d on;

volume = 0;
for i = 1:znum
    volume = volume + length(find(im_segment(:,:,i) ~= 0));
end
