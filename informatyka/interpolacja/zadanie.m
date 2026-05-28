clear; close all; clc;

% Zadanie podsumowujace: dopasowanie metody interpolacji do znaczenia fizycznego
x = [1, 2, 3, 4, 5];
y = [0, 0, 10, 10, 10];
xd = 1:0.01:5;

% Obliczenia dla wszystkich metod
y_linear = interp1(x, y, xd, 'linear');
y_nearest = interp1(x, y, xd, 'nearest');
y_pchip = interp1(x, y, xd, 'pchip');
y_spline = interp1(x, y, xd, 'spline');

% Raport do okna polecen
disp('=== Zadanie podsumowujace: dopasowanie metody ===');
disp('Uwaga: to sa 3 niezalezne scenariusze, nie jedna historia.');
disp('1) Stan stycznika (on/off): nearest');
disp('2) Zbiornik cieczy (bez falowania > 10): pchip');
disp('3) Lot kamery robota (najwieksza gladkosc ruchu): spline');

% Prosta kontrola bezpieczenstwa dla scenariusza zbiornika
max_pchip = max(y_pchip);
max_spline = max(y_spline);
fprintf('Maksymalna wartosc pchip:  %.3f\n', max_pchip);
fprintf('Maksymalna wartosc spline: %.3f\n', max_spline);

figure('Position', [100, 100, 1000, 600]);

% Punkty wezlowe
plot(x, y, 'ko', 'MarkerSize', 9, 'LineWidth', 2, 'MarkerFaceColor', 'k');
hold on;

% Wszystkie metody na jednym wykresie
plot(xd, y_nearest, 'c--', 'LineWidth', 1.8);
plot(xd, y_linear,  'b-',  'LineWidth', 1.8);
plot(xd, y_pchip,   'g-',  'LineWidth', 2.2);
plot(xd, y_spline,  'm-',  'LineWidth', 2.0);

% Poziom graniczny dla scenariusza zbiornika
yline(10, 'k:', 'Limit zbiornika = 10', 'LineWidth', 1.2);

grid on;
xlabel('x (czas)', 'FontSize', 12);
ylabel('y (wartosc sygnalu)', 'FontSize', 12);
title('Zadanie podsumowujace: porownanie metod interpolacji', 'FontSize', 13, 'FontWeight', 'bold');
legend('Wezly', 'nearest', 'linear', 'pchip', 'spline', 'Location', 'southeast');
xlim([1, 5]);

% Komentarz koncowy
if max_spline > 10
    disp('Wniosek: spline moze przeszacowac limit 10 (oscylacje przy skoku).');
else
    disp('Wniosek: spline nie przekroczyl 10 dla tych danych, ale bywa ryzykowny przy skokach.');
end
