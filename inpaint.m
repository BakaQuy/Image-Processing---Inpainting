function  imageOut = inpaint(imageIn,mask)
%% Plot
subplot(1, 3, 1);
imshow(imageIn);
subplot(1, 3, 2);
imshow(mask);
subplot(1, 3, 3);

%% Parameters
windowSize = 8; % Size of the window Wi,Vi
iterations = 10; % Number of iterations per scale
final_iterations = 2; % Number of iterations in the final recontruction (1 or 2 iterations is well enough)
thresholdScale = 1; % Threshold to go to next scale level

%% Onion peel recontruction
I = OnionPeelReconstruct(imageIn,mask,windowSize);

%% Pyramid level recontruction
I = PyramidReconstruct(I,mask,windowSize,iterations,thresholdScale);

%% Pyramid level recontruction
imageOut = FinalReconstruction(I,mask,windowSize,final_iterations);

end