% filepath: c:\Users\Husse\Documents\Repos\DIV\A_weighting.m
% Read A-weighting table and plot curve, plus example dBA calculation.


% Read the CSV (adjust path if you move the files)
tbl = readtable(fullfile('c:\Users\Husse\Documents\Repos\DIV','A-weights.csv'));

% Columns: Frequency(Hz), A-weighting(dB)
f = tbl{:,1};
A = tbl{:,2};

% Plot A-weighting curve
figure('Name','A-weighting');
semilogx(f, A, '-o', 'LineWidth', 1.5);
yline(0, '--k', 'LineWidth', 1); % Add dashed line at 0 dB
grid on;
xlabel('Frequency (Hz)');
ylabel('Gain (dB)');
title('A-weighting curve');
xlim([min(f) max(f)]);

hold on;
legend('A-weighting (A)', 'Location','SouthWest');

% Optional: if user provides a spectrum file 'spectrum.csv' with two columns
% Frequency(Hz), dB, compute and plot the A-weighted spectrum
spec_path = fullfile('c:\Users\Husse\Documents\Repos\DIV','spectrum.csv');
if exist(spec_path,'file')
    Spec = readtable(spec_path);
    f_user = Spec{:,1};
    db_user = Spec{:,2};
    % Interpolate A-weighting to user frequencies (pchip keeps shape)
    A_interp = interp1(f, A, f_user, 'pchip', 'extrap');
    dBA_user = db_user + A_interp;

    % Logarithmic addition for user spectrum
    L_user_unweighted = 10 * log10(sum(10.^(db_user/10)));
    L_user_Aweighted = 10 * log10(sum(10.^(dBA_user/10)));

    figure('Name','User spectrum A-weighting');
    semilogx(f_user, db_user, '-', 'LineWidth', 1);
    hold on;
    semilogx(f_user, dBA_user, '-', 'LineWidth', 1.5);
    grid on;
    xlabel('Frequency (Hz)');
    ylabel('Level (dB)');
    title('User spectrum: unweighted vs A-weighted (dBA)');
    legend('Unweighted','A-weighted');

    % Annotate single-number dB values
    text(f_user(round(end*0.7)), L_user_unweighted, sprintf('Unweighted: %.2f dB', L_user_unweighted), 'FontSize',8, 'Color','k');
    text(f_user(round(end*0.7)), L_user_Aweighted, sprintf('A-weighted: %.2f dBA', L_user_Aweighted), 'FontSize',8, 'Color','b');
end

% Short message
fprintf('Plotted A-weighting. dBA = dB + A-weighting. To process your spectrum, place spectrum.csv (Frequency(Hz), dB) in the same folder.\n');
