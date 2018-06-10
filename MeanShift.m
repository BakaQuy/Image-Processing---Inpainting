function [ M ] = MeanShift( I, Rdata, bandwidth, maxIt, thresholdCluster )
% Rdata contains the weighted colors of each pixel candidate
% M contains the pixels that belong to the higher mode
% sigma is the std of the color set
A = I(Rdata(:,3), Rdata(:,4), :);
[m, n, ~] = size(A);
A = reshape(A,[], 3);
A = A(1:m+1:m*n,:); % rgb
B = repmat(Rdata(:,5), [1 3]); % similitude 
RGB = B .* A; % I(i2, j2, :)

for iter = 1:maxIt
    for p = 1:m-1
        pixelP = RGB(p, :);
        neighborhood = [];
        for q = p+1:m
           % create neighborhood
           pixelQ = RGB(q,:);
           d = sum((pixelP - pixelQ).^2);
           if d < thresholdCluster
               neighborhood(end+1, :) = pixelQ; % neighborhood(end+1, 3) ?
           end
        end
        num = 0;
        den = 0;
        [nsize, ~] = size(neighborhood);
        for k = 1:nsize
            dist = sum((neighborhood(k,:)- pixelP).^2);
            weight = (1/bandwidth*sqrt(2*pi))* exp(-0.5*(dist/bandwidth)^2);
            num = num + weight*neighborhood(k);
            den = den + weight;
        end
        mean_shift = num/den;
        RGB(p,:) = mean_shift;        
    end
end
M = RGB;
end

