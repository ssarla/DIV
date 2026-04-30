%% Inläsning av mätdata
csvPath_1 = 'pv_cycle.csv';
csvPath_2 = 'dyno.csv';

data_1 = readtable(csvPath_1);
data_2 = readtable(csvPath_2);

% Hämta mätvärden i vektorer
p = data_1.p;
V = data_1.V;

rps = data_2.rps;
F = data_2.F;

rpm = rps * 60;
T = F * 0.1; %Nm från F och 0.1m hjul
P_out = 2 * pi * rps .* T;

%% Konvertering
p2 = p * 100;
V2 = V / 10^6;

% arbete per cykel
W_cycle_kJ = polyarea(V2, p2); %"numerical integration via the trapezoidal method" :P
W_cycle = W_cycle_kJ * 1000; %från kJ till J

% andra värden
f = 5.4; %frekvens (Hz)
P = W_cycle * f;


P_in = 225;
eta = P_out ./ P_in;

%% Qin and Qout calculation

dV = diff(V2); % Change in volume (m^3)
p_mid = (p2(1:end-1) + p2(2:end)) / 2; % Average pressure between points (kPa)

% Qin: sum over expansion (dV > 0)
Qin = sum(p_mid(dV > 0) .* dV(dV > 0));   % J

% Qout: sum over compression (dV < 0)
Qout = -sum(p_mid(dV < 0) .* dV(dV < 0)); % J

Qin = Qin * 1000 * f;   % W
Qout = Qout * 1000 * f; % W

eta_th = P / Qin;

fprintf('P{in}: %.2f W\n', P_in);
fprintf('P{out}: %.2f W\n', P_out);

fprintf('Q{in}: %.2f W\n', Qin);
fprintf('Q{out}: %.2f W\n', Qout);

%% Diagram

figure('Name','RPM vs \eta','NumberTitle','off');
plot(rpm, eta, 'o', 'MarkerEdgeColor','#ff3c00', 'MarkerFaceColor', '#ff3c00');
grid on;
title('RPM vs Efficiency (\eta)');
xlabel('RPM');  
ylabel('Efficiency (\eta)');
set(gcf, "Theme", "light");

figure('Name','Volume vs Pressure','NumberTitle','off');
plot(V2, p2, 'o', 'MarkerEdgeColor','#0c93dd', 'MarkerFaceColor', '#0c93dd');
hold on
plot(V2(1), p2(1), 'ro')
hold off
grid on;
title('Volume vs Pressure in no-load condition');
xlabel('Volume (m^3)');
ylabel('Pressure (kPa)');
set(gcf, "Theme", "light");

fprintf('Arbete ut: %.2f W\n', P);
fprintf('eta{TH}: %.2f\n', eta_th);
fprintf('\nKlar!\n');