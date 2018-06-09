function  imageOut = inpaint(imageIn,mask)
%% Parameters
windowSize = 8; % Size of the window Wi,Vi
iterations = 10; % Number of iterations per scale
csh_iterations = 10;
final_iterations = 1; % Number of iterations in the final recontruction (1 or 2 iterations is well enough)
thresholdScale = 0.5; % Threshold to go to next scale level

%% Plot
subplot(1, 3, 1);imshow(imageIn);title('Original Image');
subplot(1, 3, 2);imshow(mask);title('Mask');
subplot(1, 3, 3); % Reconstruction plot

%% Onion peel recontruction
I = OnionPeelReconstruct(imageIn,mask,windowSize,csh_iterations);

%% Pyramid level recontruction
I = PyramidReconstruct(I,mask,windowSize,thresholdScale,iterations,csh_iterations);

%% Final recontruction
imageOut = FinalReconstruction(I,mask,windowSize,final_iterations,csh_iterations);

end