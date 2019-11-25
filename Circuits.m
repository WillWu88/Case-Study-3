% implementing circuit A: RC

resisA = 1000;
capacA = 0.000001;
vInConstant = 5;

h = 0.1 * resisA * capacA;
k = 500;
vInA = 5 * ones(k, 1);
time_series = [0:h:(k-1)*h]';

vc_out = updateCVoltage(vInA, resisA, capacA, h, k);
plotVOut(vc_out, vInA, time_series, 'Simple RC Circuit');

% sample rate changed to h prime
hPrime = 0.0008;
tsprime = [0:hPrime:(k-1)*hPrime]';
vc_out_prime = updateCVoltage(vInA, resisA, capacA, hPrime, k);
plotVOut(vc_out_prime, vInA, tsprime, 'Circuit A sampled at h_prime interval');

% flipped RC circuit
freq1 = 50;
freq2 = 1000;
vInFlipped1 = 5 * sin(2 * pi * freq1 * time_series);
vInFlipped2 = 5 * sin(2 * pi * freq2 * (time_series * 0.1));

vcOutF1 = updateCVoltage(vInFlipped1, resisA, capacA, h, k);
vrOutF1 = vInFlipped1 - vcOutF1;
plotVOutMulti(vcOutF1, vrOutF1, vInFlipped1, time_series, 'Flipped circuit with 50 Hz Input');

vcOutF2 = updateCVoltage(vInFlipped2, resisA, capacA, h * 0.1, k);
vrOutF2 = vInFlipped2 - vcOutF2;
plotVOutMulti(vcOutF2, vrOutF2, vInFlipped2, time_series, 'Flipped circuit with 1k Hz Input');

% v out is vr in this case
% plotting transfer function
freqRange = [10:10000]';
transferMag1 = zeros(10000, 1);
transferMag2 = zeros(10000, 1);

for i = 10:10000
    vinTemp = sin(2 * pi * i * (time_series * 0.1));
    vcOutTemp = updateCVoltage(vinTemp, resisA, capacA, 0.1*h, 500);
    vrOutTemp = vinTemp - vcOutTemp;
    transferMag1(i) = max(vcOutTemp)/max(abs(vinTemp));
    transferMag2(i) = max(vrOutTemp)/max(abs(vinTemp));
end

% plotting the filter graph
figure();
hold on;
plot(log10(freqRange), transferMag1(10:10000));
plot(log10(freqRange), transferMag2(10:10000));
hold off;
legend('vrOut', 'vcOut', 'location', 'best');

% cascaded RC Circuits
freq1 = 440;
freq2 = 3000;
c1 = 0.00000068;
c2 = c1;
c3 = c1;

r1 = 330;
r2 = r1;
r4 = r1;

vInCas = 5 * sin(2 * pi * freq1 * time_series*0.1) + sin(2 * pi * freq2 * time_series * 0.1);

[vOUT,vOUT2,vIN,time2] = voutCas(440,3000,resisA,capacA);

figure();
hold on;
plot(time2, vIN);
plot(time2, vOUT);
hold off;
legend('vIn', 'vOut', 'location', 'best');

figure();
hold on;
plot(time2, vIN);
plot(time2, vOUT2);
hold off;
legend('vIn', 'vOut2', 'location', 'best');

plotting transfer function

freqRange2 = [10:500:10000];
freqComb = combnk(freqRange2,2);
freqComb = sortrows(cat(1, freqComb, fliplr(freqComb)));

[interval,~] = size(freqComb);

transferMag3 = zeros(interval,1);
transferMag4 = zeros(interval,1);

for i = 1:interval
    [vOUT3,vOUT4,vIN,time2] = voutCas(freqComb(i,1),freqComb(i,2),resisA,capacA);
    transferMag3(i) = max(vOUT3);
    transferMag4(i) = max(vOUT4);
end

ts3 = freqRange2;
figure();
hold on;
plot(log10(ts3), transferMag3);
plot(log10(ts3), transferMag4);
hold off;
legend('vrOut', 'vcOut', 'location', 'best');

figure('Name','Test');
loglog(freqRange,fout1);

function vc_out = updateCVoltage(vin, r, c, h, k)
    % updateVoltage - takes in five arguments, vin, resistance, capacitance and time
    % step of the function, produce a output matrix that tracks the voltage of the
    % capacitor throughout k time steps
    % vin: vector of size k,
    % r: scalar
    % c: scalar
    % h: scalar
    % k: scalar
    % Syntax: vc_out = updateVoltage(vin, r, c, h, k);
    temp = zeros(k, 1);
    temp(1, 1) = 0; % assume initial state is zero
    constant = h / (r * c);

    %always assume constant v-in voltage input
    for entry = 2:k
        temp(entry, 1) = (1 - constant) * temp(entry - 1, 1) + (constant * vin(entry - 1));
    end

    vc_out = temp;
end

function plotVOut(vOut, vin, time_series, label)
    % plotVOut - takes 4 arguments

    figure('Name', label);
    hold on;
    plot(time_series, vin);
    plot(time_series, vOut);
    legend('voltage in', 'voltage out');
    hold off;

end

function plotVOutMulti(vcOut, vrOut, vin, time_series, label)
    % plotVOut - takes 4 arguments

    figure('Name', label);
    hold on;
    plot(time_series, vin);
    plot(time_series, vcOut);
    plot(time_series, vrOut)
    legend('voltage in', 'CVout', 'RVout');
    hold off;

end

function vc_next = updateCapacitor(ik, h, c, v)
    vc_next = (v + h / c * ik);
end

function [vout1, vout2, vin, time] = voutCas(freq1,freq2,r,c);

    R4 = 330;
    R2 = 330;
    R1 = 330;

    h2 = 0.01*r*c;

    vC1 = zeros(1000, 1);
    vC3 = zeros(1000, 1);
    vIN = zeros(1000, 1);
    vOUT = zeros(1000, 1);
    time2 = zeros(1000, 1);

    vC2 = zeros(1000, 1);
    vC32 = zeros(1000, 1);
    vOUT2 = zeros(1000, 1);

    for t = 1:1000
        vIN(t) = 5 * sin(2 * pi * freq1 * (t * h2)) + sin(2 * pi * freq2 * (t * h2));
        A = [1, -1, -1, 0, 0, 0; 0, -R2, 0, 0, 1, 0; 0, 0, -R4, 0, 0, 1; 0, 0, 0, 1, 0, 0; 0, 0, 0, 1, -1, 0; 0, 0, 0, 0, 1, -1];
        A2 = [1, -1, -1, 0, 0, 0; -R1, 0, 0, 1, 0, 0; 0, 0, -R4, 0, 0, 1; 0, 0, 0, 1, 0, 0; 0, 0, 0, 0, 1, 0; 0, 0, 0, 0, 1, -1];
        b = [0, 0, 0, vIN(t), vC1(t), vC3(t)]';
        b2 = [0, 0, 0, vIN(t), vC2(t), vC32(t)]';
        x = linsolve(A, b);
        x2 = linsolve(A2, b2);
        vOUT(t) = x(6);
        vOUT2(t) = x2(6);

        vC1(t + 1) = vC1(t) + (h2 / (.68 * (10^(-6))) * x(1));
        vC3(t + 1) = vC3(t) + (h2 / (.68 * (10^(-6))) * x(3));

        vC2(t + 1) = vC2(t) + (h2 / (.68 * (10^(-6))) * x2(2));
        vC32(t + 1) = vC32(t) + (h2 / (.68 * (10^(-6))) * x2(3));

        time2(t, 1) = h2 * (t - 1);
    end

    vout1 = vOUT;
    vout2 = vOUT2;
    vin = vIN;
    time = time2;
end
