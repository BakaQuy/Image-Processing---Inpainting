% clear; close all;
% 
% W_set(1).patch = rand(400,3,'gpuArray');
% W_set(2).patch = rand(400,3,'gpuArray');
% W_set(3).patch = rand(400,3,'gpuArray');
% W_set(4).patch = rand(400,3,'gpuArray');
% W_set(5).patch = rand(400,3,'gpuArray');
% W_set(6).patch = rand(400,3,'gpuArray');
% W_set(7).patch = rand(400,3,'gpuArray');
% W_set(8).patch = rand(400,3,'gpuArray');
% W_set(9).patch = rand(400,3,'gpuArray');
% W_set(10).patch = rand(400,3,'gpuArray');
% 
% W_set2(1).patch = rand(400,3);
% W_set2(2).patch = rand(400,3);
% W_set2(3).patch = rand(400,3);
% W_set2(4).patch = rand(400,3);
% W_set2(5).patch = rand(400,3);
% W_set2(6).patch = rand(400,3);
% W_set2(7).patch = rand(400,3);
% W_set2(8).patch = rand(400,3);
% W_set2(9).patch = rand(400,3);
% W_set2(10).patch = rand(400,3);
% 
% W_set2_GPU = gpuArray([W_set2(:).patch]);
% W_set2_GPU_reshape = reshape(W_set2_GPU,400,3,10);
% 
% Wi = W_set(1).patch;
% 
% res = arrayfun(@ComputeSim,Wi,Wi);
% res = pagefun(@ComputeSim,Wi,Wi);
% 

% A = rand(10,10,3)
% B = reshape(A,100,3)

W_set2(1).patch = rand(1);
W_set2(2).patch = rand(1);
W_set2(3).patch = rand(1);
W_set2(4).patch = rand(1);
W_set2(5).patch = rand(1);
W_set2(6).patch = rand(1);
W_set2(7).patch = rand(1);
W_set2(8).patch = rand(1);
W_set2(9).patch = rand(1);
W_set2(10).patch = rand(1);


