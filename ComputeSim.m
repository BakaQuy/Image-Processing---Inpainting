function similitude = ComputeSim(Wi,candidate_patch)
diff = Wi-candidate_patch;
NumberPixels = length(Wi(:,1));
diffs = zeros(NumberPixels,1);
for i=1:NumberPixels
    diffs(i) = norm(diff(i,:))^2;
end
% sigma = prctile(diffs,75);
sigma = 1;
similitude = exp(-sum(diffs)/(2*(sigma^2)));