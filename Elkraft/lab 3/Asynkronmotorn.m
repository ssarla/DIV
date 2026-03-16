

%% Inläsning av mätdata
csvPath = 'data.csv';

data = readtable(csvPath);

% Hämta mätvärden i vektorer
I1 = data.I1;
U1 = data.U1;
P1 = data.P1;
cosphi = data.cosphi;
M = data.M;
n = data.n;

%% Beräkningar
% Synkront varvtal (rpm).
f = 50;
p = 4;
ns = 120 * f / p;

% Inmatad effekt (W)
Pin = 3 .* P1;            % enligt Pin = 3 * P1
Pin_alt = sqrt(3) .* U1 .* I1 .* cosphi; % alternativ beräkning

% Eftersläpning
s = ((ns - n) ./ ns) .* 100;

% Avgiven effekt
Put = 2 .* pi .* n ./ 60 .* M;

% Effektfaktor (beräknad)
cosphi1 = Pin ./ (sqrt(3) .* U1 .* I1);

% Verkningsgrad
eta = Put ./ Pin;

% Sätt ihop resultat i en tabell
resultat = table(...
    I1, U1, P1, cosphi, M, n, ...
    Pin, Pin_alt, s, Put, cosphi1, eta, ...
    'VariableNames', ...
    {'I1_A','U1_V','P1_W','cosphi','M_Nm','n_rpm','Pin_W','Pin_alt_W','s','Put_W','cosphi1','eta'});

fprintf('\nBeräknade värden:\n');
disp(resultat);

% Skriv ut resultat till CSV-fil
outputCsvPath = 'resultat.csv';
writetable(resultat, outputCsvPath);
fprintf('Resultat sparat till %s\n', outputCsvPath);
%% Diagram

figure('Name','P_{in} vs P_{ut}','NumberTitle','off');
plot(Put, Pin, 'o', 'MarkerEdgeColor','#cc6f49', 'MarkerFaceColor', '#cc6f49');
grid on;
title('Tillförd effekt (P_{in}) mot Avgiven effekt (P_{ut})');
xlabel('P_{ut} (W)');
ylabel('P_{in} (W)');
set(gcf, "Theme", "light");

figure('Name','\eta vs P_{ut}','NumberTitle','off');
plot(Put, eta, 'o', 'MarkerEdgeColor','#a7cc49', 'MarkerFaceColor', '#a7cc49');
grid on;
title('Verkningsgrad (\eta) mot Avgiven effekt (P_{ut})');
xlabel('P_{ut} (W)');
ylabel('Verkningsgrad (\eta)');
set(gcf, "Theme", "light");

figure('Name','s vs P_{ut}','NumberTitle','off');
plot(Put, s, 'o', 'MarkerEdgeColor','#49a7cc', 'MarkerFaceColor', '#49a7cc');
grid on;
title('Eftersläpning (s) mot Avgiven effekt (P_{ut})');
xlabel('P_{ut} (W)');
ylabel('Eftersläpning (s)');
set(gcf, "Theme", "light");

figure('Name','M vs s','NumberTitle','off');
plot(s, M, 'o', 'MarkerEdgeColor','#6e49cc', 'MarkerFaceColor', '#6e49cc');
grid on;
title('Moment (M) mot Eftersläpning (s)');
xlabel('Eftersläpning (%)');
ylabel('Moment (Nm)');
set(gcf, "Theme", "light");

fprintf('\nKlar!\n');