%% Inläsning av mätdata
csvPath = 'temp.csv';

data = readtable(csvPath);

% Hämta mätvärden i vektorer
t = data.tid;
U = data.volt;
t_offset = data.tid(1);

%% Kalibrerning
plateau = -0.000758; %volt
start = -3.330232E-5; %volt
delta_T = 18; %celsius

t = t - t_offset;

delta_U = (-plateau) - (-start); %volt
T = (U - plateau) * delta_T / delta_U; %celsius

t_min = t / 60;

%% Diagram

figure('Name','Tid (s) mot Spänning (V)','NumberTitle','off');
plot(t, U, '-o', 'MarkerEdgeColor','#ff3c00', 'MarkerFaceColor', '#ff3c00');
grid on;
title('Tid (s) vs Spänning (V)');
xlabel('Tid (s)');  
ylabel('Spänning (V)');
set(gcf, "Theme", "light");

figure('Name','Tid (min) mot Temperatur (°C)','NumberTitle','off');
plot(t_min, T, '-', 'MarkerEdgeColor','#0c93dd', 'MarkerFaceColor', '#0c93dd');
grid on;
title('Tid (min) vs Temperatur (°C)');
xlabel('Tid (min)');
ylabel('Temperatur (°C)');
set(gcf, "Theme", "light");

%fprintf('Arbete ut: %.2f W\n', P);
fprintf('\nKlar!\n');