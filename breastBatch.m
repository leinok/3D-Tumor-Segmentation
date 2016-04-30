[ndata, text, alldata] = xlsread('breast.xlsx'); 

load position

for i = 1
    
    for j = 1:23:23
        path = alldata(j,i);
        y = zeros(6,1);
        z = zeros(6,1);
%         for k = 1:6
%             startFile = alldata(j + 1 + (k-1)*3, i);
%             endFile = alldata(j + 2 + (k-1)*3, i);
%             volume = breasTumorAnalysis(startFile, endFile, path, path, position(2*i-1,:))
%             y(k) = volume;
%         end
        %Temporary for the report
        for k = 1:6
            startFile = alldata(j + 1 + (k-1)*3, i);
            endFile = alldata(j + 2 + (k-1)*3, i);
            ma(:,:,k) = kinetic(startFile, endFile, path, path, position(2*i-1,:));
        end
        x = [1:6];
        for m = 1:6
            for n = 1:6
                t = ma(m,n,1)
                figure, plot(x, [0, ma(m,n,2)-t,ma(m,n,3)-t,ma(m,n,4)-t,ma(m,n,5)-t,ma(m,n,6)-t]);
                title(['plot',int2str(m),int2str(n)]);
            end
        end
        z(2:6) = y(2:6)-y(1:5);
        plot(x,z);
        ylabel('Volume enhancement');
        xlabel('Time points');
        set(gca, 'XTick', [1:1:6]);
        disp('One data sets');
    end
end
    