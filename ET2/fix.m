% Läs in originaldata
data = readtable('pv.csv');
V = data.V;
p = data.p;

% Plotta hela kurvan för att hitta bra index
figure;
plot(V, p, 'b.-');
xlabel('Volym');
ylabel('Tryck');
title('Hela pV-kurvan');
grid on;

% Ange manuellt start- och slutindex här:
start_idx = 50;   % <-- Ändra till önskat startindex
end_idx   = 250;  % <-- Ändra till önskat slutindex

% Extrahera vald cykel
V_cycle = V(start_idx:end_idx);
p_cycle = p(start_idx:end_idx);

% Plotta vald cykel ovanpå hela kurvan
hold on;
plot(V_cycle, p_cycle, 'r', 'LineWidth', 2);
legend('All data', 'Vald cykel');

% Skapa ny tabell och spara till CSV
cycle_table = table(V_cycle, p_cycle, 'VariableNames', {'V', 'p'});
writetable(cycle_table, 'pv_cycle.csv');

disp('En cykel har sparats till pv_cycle.csv');