% test.m
P = alphabet;
T = targets;

[R, ~] = size(P);
[S2, Q] = size(T);

net = newp(minmax(alphabet), S2);

net.trainParam.epochs = 300;
max_times = 100;

[net, tr] = train(net, P, T);

netn = net;

noise_range = 0 : 0.05 : 0.2;

for pass = 1:max_times
    for noise = noise_range
        P1 = alphabet + randn(R, Q) * noise;
        [netn, tr] = train(netn, P1, T);
    end
end

noise_range = 0 : 0.02 : 0.2;
network = [];
T = zeros(26, 1);
T(1, 1) = 1;
for noise_level = noise_range
    errors = 0;
    for i = 1:max_times
        P1 = mA + randn(35, 1) * noise_level;
        An = sim(netn, P1);
        AAn = compet(An);
        errors = errors + sum(abs(AAn-T)) / 2;
    end
    network = [network errors/26/100];
end

figure(1);
plot(noise_range, network*100);
xlabel('noise level');
ylabel('percentage of error (%)');

noise_range = 0 : 0.05 : 0.4;

network = [];
PA = [0 1 1 1 0 ...
     0 1 0 1 1 ...
     1 1 0 1 1 ...
     1 1 0 1 1 ...
     1 1 1 1 1 ...
     1 0 0 0 1 ...
     1 0 0 0 1]';  % letter A
T = zeros(26, 1);
T(1, 1) = 1;
for noise_level = noise_range
   fprintf('noise_level = %.2f.\n', noise_level);
   errors = 0;
   for i = 1:max_times
      P1 = PA + randn(35, 1) * noise_level;
      An = sim(netn, P1);
      AAn = compet(An);
      errors = errors + sum(abs(AAn-T)) / 2;
   end
network = [network errors/26/100];
end

figure(2);
plot(noise_range, network*100);
xlabel('noise level');
ylabel('percentage of error (%)');