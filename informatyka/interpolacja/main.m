%% ================================================================================
%  PROGRAM: INTERPOLACJA I APROKSYMACJA W MATLAB
%  Opis: Program rozwijany krok po kroku - kazde cwiczenie dodaje nowe funkcje,
%        które nastepnie sa wykorzystywane w kolejnych czesciach kodu.
% ================================================================================

%% =====================================================================
%  CWICZENIE 1 - Szablon glowny
% =====================================================================
clear; close all; clc;

x_wezly = [0, 1, 2, 3, 4, 5, 6];
y_wezly = 2*sin(x_wezly) + x_wezly;

%% =====================================================================
%  CWICZENIE 2 - Instrukcje if/else
% =====================================================================
x_punkt = input('Podaj badany punkt x: ');

if x_punkt < 0
    disp('Punkt poza wezlami - ekstrapolacja (lewa strona).');
elseif x_punkt > 6
    disp('Punkt poza wezlami - ekstrapolacja (prawa strona).');
else
    disp('Punkt pomiedzy wezlami - interpolacja.');
end

%% =====================================================================
%  CWICZENIE 3 - Instrukcja switch/case
% =====================================================================
disp('Dostepne metody interpolacji: 1-linear, 2-pchip, 3-spline');
wybor = input('Wybierz (1-3): ');

switch wybor
    case 1
        metoda = 'linear'; nazwa_met = 'linear';
    case 2
        metoda = 'pchip'; nazwa_met = 'pchip';
    case 3
        metoda = 'spline'; nazwa_met = 'spline';
    otherwise
        disp('Nieprawidlowy wybor -- domyslnie uzywam spline');
        metoda = 'spline'; nazwa_met = 'spline';
end

%% =====================================================================
%  CWICZENIE 4 - Podstawowy wykres
% =====================================================================
odp = input('Czy narysowac wykres wezlow? (t/n): ', 's');

if odp == 't'
    figure('Name', 'Wykres wezlow', 'NumberTitle', 'off', ...
    'Position', [100, 100, 800, 600]);
    plot(x_wezly, y_wezly, 'ro', 'MarkerSize', 12, 'LineWidth', 2);
    grid on;
    xlabel('x', 'FontSize', 14);
    ylabel('y = 2*sin(x) + x', 'FontSize', 14);
    title('Wezly funkcji f(x) = 2*sin(x) + x', 'FontSize', 14);
end

%% =====================================================================
%  CWICZENIE 5 - Aproksymacja wielomianowa
% =====================================================================
odp = input('Czy wykonac aproksymacje wielomianowa? (t/n): ', 's');

if odp == 't'
    stopien = input('Podaj stopien wielomianu aproksymujacego (1-5): ');
    if stopien < 1
        disp('Za maly stopien -- ustawiono: 2'); stopien = 2;
    elseif stopien > 5
        disp('Za duzy stopien -- ustawiono: 5'); stopien = 5;
    else
        disp(['Wybrano stopien: ' num2str(stopien)]);
    end
    p = polyfit(x_wezly, y_wezly, stopien);
    disp('Wspolczynniki wielomianu (od najwyzszej potegi):');
    for i = 1:length(p), disp(['        p' num2str(i) ' = ' num2str(p(i))]); end
    
    x_siatka = 0 : 0.05 : 6;
    y_aproks = polyval(p, x_siatka);
    y_oryg = 2*sin(x_siatka) + x_siatka;
    
    y_punkt_aproks = polyval(p, x_punkt);
    disp(['Wartosc aproksymacji w punkcie x = ', num2str(x_punkt), ' wynosi y = ', num2str(y_punkt_aproks)]);
    
    figure('Name', 'Aproksymacja wielomianowa', 'NumberTitle', 'off', 'Position', [100, 100, 800, 600]);
    plot(x_wezly, y_wezly, 'ro', 'MarkerSize', 12, 'LineWidth', 2); hold on;
    plot(x_siatka, y_aproks, 'b-', 'LineWidth', 2);
    plot(x_siatka, y_oryg, 'g--', 'LineWidth', 1.5);
    plot(x_punkt, y_punkt_aproks, 'm*', 'MarkerSize', 15, 'LineWidth', 2);
    grid on;
    xlabel('x', 'FontSize', 14); ylabel('y', 'FontSize', 14);
    title(['Aproksymacja wielomianem stopnia ' num2str(stopien)], 'FontSize', 14);
    legend('Wezly pomiarowe', 'Wielomian aproksymujacy', 'Funkcja oryginalna', 'Wyliczony punkt', 'Location', 'best');
end

%% =====================================================================
%  CWICZENIE 6 - Interpolacja
% =====================================================================
odp = input('Czy wykonac interpolacje wybrana wczesniej metoda? (t/n): ', 's');

if odp == 't'
    x_siatka = 0 : 0.05 : 6;
    y_interp = interp1(x_wezly, y_wezly, x_siatka, metoda);
    y_oryg = 2*sin(x_siatka) + x_siatka;
    
    y_punkt_interp = interp1(x_wezly, y_wezly, x_punkt, metoda);
    disp(['Wartosc interpolacji w punkcie x = ', num2str(x_punkt), ' wynosi y = ', num2str(y_punkt_interp)]);
    
    figure('Name', 'Interpolacja', 'NumberTitle', 'off', 'Position', [100, 100, 800, 600]);
    plot(x_wezly, y_wezly, 'ro', 'MarkerSize', 12, 'LineWidth', 2); hold on;
    plot(x_siatka, y_interp, 'b-', 'LineWidth', 2);
    plot(x_siatka, y_oryg, 'g--', 'LineWidth', 1.5);
    plot(x_punkt, y_punkt_interp, 'm*', 'MarkerSize', 15, 'LineWidth', 2);
    
    grid on;
    xlabel('x', 'FontSize', 14); ylabel('y', 'FontSize', 14);
    title(['Interpolacja metoda ' nazwa_met], 'FontSize', 14);
    legend('Wezly pomiarowe', 'Krzywa interpolacji', 'Funkcja oryginalna', 'Wyliczony punkt', 'Location', 'best');
end
