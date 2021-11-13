warning('off');
clear;

P = [-2 -2 -2 -2 -2 -1 -1 -1 -1 -1  0  0 0 0 0  1  1 1 1 1  2  2 2 2 2;
     -2 -1  0  1  2 -2 -1  0  1  2 -2 -1 0 1 2 -2 -1 0 1 2 -2 -1 0 1 2];

T = [-2 -2 -1 -1 0  -2 -1 -1  0  0 -1 -1 0 0 1 -1  0 0 1 1  0  0 1 1 2];

S1 = 10;
[R, ~] = size(P);
[S2, Q] = size(T);

net = newff(minmax(P), [S1,1], {'tansig', 'purelin'}, 'traingd'); 

% 初始化
net.IW{1, 1} = rands(S1, R);
net.b{1} = rands(S1, 1);
net.LW{2, 1} = rands(S2, S1);
net.b{2} = rands(S2, 1);

net.trainParam.epochs = 25000;
net.trainParam.lr = 0.08;
net.trainParam.goal = 1e-3;

[net,tr]= train(net, P, T, nnMATLAB); 
Y = sim(net ,P);

sse_error = perform(net, T, Y)  ;
fprintf('SSE = %f\n', sse_error);

% 样本插值测试
P1 = zeros();
T1 = zeros();
step = 0.5;
e1 = -2:step:2;
ec1 = -2:step:2;
[~, S] = size(e1);
for i = 1:S
    for j = 1:S
        col = (i-1) * S + j;
        P1(1, col) = e1(i);
        P1(2, col) = ec1(j);
        T1(col) = floor((e1(i) + ec1(j)) / 2);
    end
end
A = sim(net, P1);
L = cat(1, A, T1)

sse_error = perform(net, T1, A);
fprintf('SSE = %f\n', sse_error);