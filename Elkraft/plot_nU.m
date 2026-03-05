% plot_nU.m
% Read current-voltage-efficiency data and plot voltage and efficiency vs current

% adjust path if needed, here assuming the CSV is in the same folder
csvPath = 'n_U.csv';

% load data
data = readmatrix(csvPath);
I = data(:,1);    % current
U = data(:,2);    % voltage
n = data(:,3);    % efficiency

% generate figure with two y-axes
figure;
yyaxis left
plot(I, U, 'bo', 'MarkerFaceColor','b', 'DisplayName','Spänning U_{2}');     % solid black dots
ylabel('Spänning U_{2} (V)');
ylim([70 75]);      % limit for voltage

yyaxis right
plot(I, n, 'ro', 'MarkerFaceColor','r', 'DisplayName','Verkningsgrad');   % solid red dots
ylabel('Verkningsgrad (η)');
ylim([0.5 1]);      % limit for efficiency

% annotate the plot
xlabel('Ström I_{2} (A)');
% title('Sekundärlindningens spänning och transformatorns verkningsgrad i respekt för sekundärlindningens ström');
legend('Location','best');
grid on;
