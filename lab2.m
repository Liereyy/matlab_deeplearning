P = [-2 -2 -2 -2 -2 -1 -1 -1 -1 -1  0  0 0 0 0  1  1 1 1 1  2  2 2 2 2;
     -2 -1  0  1  2 -2 -1  0  1  2 -2 -1 0 1 2 -2 -1 0 1 2 -2 -1 0 1 2];

T = [-2 -2 -1 -1 0  -2 -1 -1  0  0 -1 -1 0 0 1 -1  0 0 1 1  0  0 1 1 2];

S1 = 10;
[R, ~] = size(P);
[S2, Q] = size(T);

net = newff(minmax(P), [S1,1], {'tansig', 'purelin'}, 'trainlm'); 

net.performFcn = 'sse';
net.trainParam.epochs = 50000;
net.trainParam.lr = 0.01;
net.trainParam.goal = 1e-5;

[net,tr]= train(net, P, T); 
Y = sim(net ,P);

% 样本插值测试
P1 = zeros();
T1 = zeros();
step = 0.5
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
Res = cat(1, A, T1)
[~, C] = size(A);
ave_error = perform(net, T1, A) / C
