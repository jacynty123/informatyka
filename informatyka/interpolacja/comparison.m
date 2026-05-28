clear; close all; clc;

% Dane ze SKOKIEM (testujemy czy metoda faluje)
x = [0, 1, 2, 2.5, 3, 4, 5, 6];
y = [0, 0, 0, 1, 1, 1, 1, 2];
x_dense = 0:0.05:6;

figure('Position', [100 100 800 500]);

plot(x, y, 'ro', 'MarkerSize', 10, 'LineWidth', 2); hold on;

% Oblicz wszystkie metody
y_linear = interp1(x, y, x_dense, 'linear');
y_nearest = interp1(x, y, x_dense, 'nearest');
y_pchip  = interp1(x, y, x_dense, 'pchip');
y_spline = interp1(x, y, x_dense, 'spline');
pause
plot(x_dense, y_linear, 'b-', 'LineWidth', 1.5);
pause
plot(x_dense, y_nearest, 'c--', 'LineWidth', 1.5);
pause
plot(x_dense, y_pchip,  'g-', 'LineWidth', 1.5);
pause
plot(x_dense, y_spline, 'm-', 'LineWidth', 1.5);

grid on;
title('Porownanie metod interpolacji', 'FontSize', 14);
xlabel('x', 'FontSize', 14); ylabel('y', 'FontSize', 14);
legend('Wezly', 'linear', 'nearest', 'pchip', 'spline', 'Location', 'best');

% Zauwaz: spline "faluje" przed i po skoku!
% pchip zachowuje skok bez falowania
