warning('off');
clear;

P = [-2 -2 -2 -2 -2 -1 -1 -1 -1 -1  0  0 0 0 0  1  1 1 1 1  2  2 2 2 2;
     -2 -1  0  1  2 -2 -1  0  1  2 -2 -1 0 1 2 -2 -1 0 1 2 -2 -1 0 1 2];

T = [-2 -2 -1 -1 0  -2 -1 -1  0  0 -1 -1 0 0 1 -1  0 0 1 1  0  0 1 1 2];

S1 = 10;
[R, ~] = size(P);
[S2, Q] = size(T);

net = newff(minmax(P), [S1,1], {'tansig', 'purelin'}, 'trainlm'); 

% 初始化
net.IW{1, 1} = rands(S1, R);
net.b{1} = rands(S1, 1);
net.LW{2, 1} = rands(S2, S1);
net.b{2} = rands(S2, 1);

% 打印初始权重
net.IW{1, 1}
net.b{1}
net.LW{2, 1}
net.b{2}

net.trainParam.epochs = 25000;
net.trainParam.lr = 0.08;
net.trainParam.goal = 1e-3;
net.trainParam.mc = 0.9;

[net,tr]= train(net, P, T, nnMATLAB); 
Y = sim(net ,P);

sse_error = perform(net, T, Y);
fprintf('SSE = %f\n', sse_error);
% 打印训练完毕后的权重
net.IW{1, 1}
net.b{1}
net.LW{2, 1}
net.b{2}
