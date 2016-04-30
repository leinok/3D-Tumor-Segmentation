function T=calc_weights3D(im,fg,bg,K,lambda,num)
% im-> input image with znum slices
% fg-> foreground pixel locations in row matrixes Mx2
% bg-> background pixel locations in row matrixes Nx2
[height,width, znum] = size(im);
N=height*width;
T=zeros(N*znum,2);
fgx=fg(:,1);% Foreground or object pixels
fgy=fg(:,2);
bgx=bg(:,1);% Background pixels
bgy=bg(:,2);

for i = 1:size(fgx,1)
    obj_pixels(i)=im(fgx(i),fgy(i), num);% Extract values of foreground pixels
end

for i = 1:size(bgx,1)
    bkg_pixels(i)=im(bgx(i),bgy(i), num);% Extract values of Background pixels
end


n_obj=hist(obj_pixels,0:max(im(:)));% Form Histogram
n_obj=n_obj./max(n_obj);% Calculate probability of object pixels

n_bkg=hist(bkg_pixels,0:max(im(:)));
n_bkg=n_bkg./max(n_bkg);% Calculate probability of background pixels
count=1;

T(:,1) = -lambda*log(n_bkg(im(:)+1)); 
T(:,2) = -lambda*log(n_obj(im(:)+1)); 

% S terminal(Object)

T(fgx+(fgy-1)*height+(num-1)*N,1) = K;
T(fgx+(fgy-1)*height+(num-1)*N,1) = 0;

T(bgx+(bgy-1)*height+(num-1)*N,2) = 0;
T(bgx+(bgy-1)*height+(num-1)*N,2) = K;

% for i = 1 : width
%     for j = 1 : height
%         if(size(find(fgx==j),1)&&size(find(fgy==i),1))% Check for foreground pixels
%             T(count,1)=K;
%         else if(size(find(bgx==j),1)&&size(find(bgy==i),1))% Check for background pixels
%                 T(count,1)=0;
%         end
%         end
% 
%         count=count+1;
%     end
% end
% 
% 
% count=1;
% % T terminal(Background)
% for i = 1 : width
%     for j = 1 : height
%         if(size(find(fgx==j),1)&&size(find(fgy==i),1))
%             T(count,2)=0;
%         else if(size(find(bgx==j),1)&&size(find(bgy==i),1))
%                 T(count,2)=K;
%             else
%                  T(count,2)=-lambda*log(n_obj(im(j,i)+1));
%             end
%         end
% 
%         count=count+1;
%     end
% end



T=sparse(T);
end