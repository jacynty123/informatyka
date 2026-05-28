clear; close all; clc;

% ============ TWORZYMY DANE ============
% Prawdziwa funkcja (nieznana w rzeczywistosci)
x_prawdziwe = 0:0.05:10;
y_prawdziwe = 2*exp(-0.3*x_prawdziwe).*sin(2*x_prawdziwe) + 0.5;

% Pobieramy tylko 12 punktow pomiarowych (z szumem!)
x_pomiar = 0:0.9:10;  % 12 punktow
y_ideal = 2*exp(-0.3*x_pomiar).*sin(2*x_pomiar) + 0.5;
szum = 0.4*randn(size(x_pomiar));  % szum gaussowski
y_pomiar = y_ideal + szum;  % nasze "brudne" dane z czujnika

% Punkty do wygladzenia
x_dokladny = 0:0.05:10;

figure('Position', [50 50 1200 400]);

% ============ WYKRES 1: INTERPOLACJA (BLEEEED!) ============
subplot(1,2,1);
plot(x_pomiar, y_pomiar, 'ro', 'MarkerSize', 8); hold on;
plot(x_prawdziwe, y_prawdziwe, 'k-', 'LineWidth', 1.5);

% Interpolacja zaszumionych danych - KATASTROFA!
y_spline = interp1(x_pomiar, y_pomiar, x_dokladny, 'spline');
plot(x_dokladny, y_spline, 'b-', 'LineWidth', 1.5);

grid on;
title('INTERPOLACJA (ZLE!) - przechodzi przez szum', 'FontSize', 14);
xlabel('x', 'FontSize', 14); ylabel('y', 'FontSize', 14);
legend('Pomiary', 'Prawdziwa funkcja', 'Interpolacja', 'Location', 'best');

% ============ WYKRES 2: APROKSYMACJA (DOBRZE!) ============
subplot(1,2,2);
plot(x_pomiar, y_pomiar, 'ro', 'MarkerSize', 8); hold on;
plot(x_prawdziwe, y_prawdziwe, 'k-', 'LineWidth', 1.5);

% Aproksymacja wielomianem 3 stopnia
p3 = polyfit(x_pomiar, y_pomiar, 3);
y_approx3 = polyval(p3, x_dokladny);
plot(x_dokladny, y_approx3, 'g-', 'LineWidth', 1.5);

% Aproksymacja wielomianem 5 stopnia
p5 = polyfit(x_pomiar, y_pomiar, 5);
y_approx5 = polyval(p5, x_dokladny);
plot(x_dokladny, y_approx5, 'm-', 'LineWidth', 1.5);

grid on;
title('APROKSYMACJA - wygladza szum', 'FontSize', 14);
xlabel('x', 'FontSize', 14); ylabel('y', 'FontSize', 14);
legend('Pomiary', 'Prawdziwa funkcja', 'Wielomian st.3', 'Wielomian st.5', 'Location', 'best');

sgtitle('INTERPOLACJA vs APROKSYMACJA - dlaczego aproksymacja wygrywa z szumem?');

% Obliczamy bledy
blad_spline = mean((y_spline - y_prawdziwe).^2);
blad_st3 = mean((y_approx3 - y_prawdziwe).^2);
blad_st5 = mean((y_approx5 - y_prawdziwe).^2);

disp('=== BLEDY (MSE) ===');
disp(['Interpolacja spline: ', num2str(blad_spline)]);
disp(['Aproksymacja st.3:   ', num2str(blad_st3)]);
disp(['Aproksymacja st.5:   ', num2str(blad_st5)]);
