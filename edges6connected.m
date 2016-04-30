function E = edges6connected(height,width, Z)

% EDGE4CONNECTED Creates edges where each node
%   is connected to its four adjacent neighbors on a 
%   height x width grid.
%   E - a vector in which each row i represents an edge
%   E(i,1) --> E(i,2). The edges are listed is in the following 
%   neighbor order: down,up,right,left, where nodes 
%   indices are taken column-major.
%
%   (c) 2008 Michael Rubinstein, WDI R&D and IDC
%   $Revision$
%   $Date$
%

N = height*width;
I = []; J = [];

% connect vertically (down, then up)
for i = 1:Z
    is = [(i-1)*N+1:i*N]'; is([height:height:N])=[];
    js = is+1;
    I = [I;is;js];
    J = [J;js;is];
    % connect horizontally (right, then left)
    is = [(i-1)*N+1:i*N-height]';
    js = is+height;
    I = [I;is;js];
    J = [J;js;is];
end

   
   is = [1:(Z-1)*N]';
   js = is+N;
   I = [I;is;js];
   J = [J;js;is];
   
   E = [I,J];
end