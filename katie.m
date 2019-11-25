%define parameters
R = 1000;
C = 0.000001;

h = .1 * R * C;

vR = zeros(100, 1);
vIn = 5 * ones(100, 1);
vC = zeros(100, 1);
time = zeros(100, 1);

for k = 2:100
    vC(k) = (1 - (h / (R * C))) * vC(k - 1) + (h / (R * C)) * vIn(k - 1);
    vR(k) = vIn(k) - vC(k);
    time(k, 1) = h * (k - 1);
end

figure('Name','Task 1: Charging Capacitor');
hold on;
plot(time, vIn);
plot(time, vC);
hold off;
legend('vIn', 'vC', 'location', 'best');

hPrime = 0.0008;
vRNew = zeros(100, 1);
vInNew = 5 * ones(100, 1);
vCNew = zeros(100, 1);
timeNew = zeros(100, 1);

for k = 2:100
    vCNew(k) = (1 - (hPrime / (R * C))) * vCNew(k - 1) + (hPrime / (R * C)) * vInNew(k - 1);
    vRNew(k) = vInNew(k) - vCNew(k);
    timeNew(k, 1) = hPrime * (k - 1);
end

figure('Name','H prime Capacitor Charging');
hold on;
plot(timeNew, vInNew);
plot(timeNew, vCNew);
hold off;
legend('vInNew', 'vCNew', 'location', 'best');

% vCTheoretical = 5 * (1 - exp(-time / (R * C)));
% figure();
% plot(time, vCTheoretical);

f1 = 50;
f2 = 1000;
t = zeros(500, 1);

vR2 = zeros(500, 1);
vInF1 = zeros(500, 1);
vC2 = zeros(500, 1);

for k = 2:500
    t(k, 1) = h * (k - 1);
    vInF1(k) = 5 * sin(2 * pi * f1 * t(k));
    vC2(k) = (1 - (h / (R * C))) * vC2(k - 1) + (h / (R * C)) * vInF1(k - 1);
    vR2(k) = vInF1(k) - vC2(k);
end

figure();
hold on;
plot(t, vR2);
plot(t, vInF1);
plot(t, vC2);
hold off;
legend('vR', 'vIn', 'vC', 'location', 'best');

vR22 = zeros(500, 1);
vInF2 = zeros(500, 1);
vC22 = zeros(500, 1);
t2 = zeros(500, 1);
h2 = .01 * R * C;

for k = 2:500
    t2(k, 1) = h2 * (k - 1);
    vInF2(k) = 5 * sin(2 * pi * f2 * t2(k));
    vC22(k) = (1 - (h2 / (R * C))) * vC22(k - 1) + (h2 / (R * C)) * vInF2(k - 1);
    vR22(k) = vInF2(k) - vC22(k);
end

figure();
hold on;
plot(t2, vR22);
plot(t2, vInF2);
plot(t2, vC22);
hold off;
legend('vR', 'vIn', 'vC', 'location', 'best');

vRT = zeros(500,1);
vInT = zeros(500,1);
vCT = zeros(500,1);
tT = zeros(500,1);

hT = .01 * R * C;
hFC = zeros(9991, 1);
hFR = zeros(9991, 1);
freq = (10:1:10000);

for f = 10:10000

    for k = 2:500
        tT(k, 1) = hT * (k - 1);
        vInT(k) = sin(2 * pi * f * tT(k));
        vCT(k) = (1 - (hT / (R * C))) * vCT(k - 1) + (hT / (R * C)) * vInT(k - 1);
        vRT(k) = vInT(k) - vCT(k);
    end
    hFC(f, 1) = max(vCT);
    hFR(f, 1) = max(vRT);
end

figure();
hold on;
loglog(freq, hFC(10:10000));
loglog(freq, hFR(10:10000));
hold off;
legend('hFC', 'hFR', 'location', 'best');
