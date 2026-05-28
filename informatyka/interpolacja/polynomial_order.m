% GENEROWANIE DANYCH PRZYKLADOWYCH
% Prawdziwa funkcja (nieznana w rzeczywistosci)
x_prawdziwe = linspace(0, 10, 200)';
y_prawdziwe = 2*x_prawdziwe + 0.5*x_prawdziwe.^2 - 0.1*x_prawdziwe.^3 + 5*sin(x_prawdziwe/2);

% Punkty pomiarowe (z szumem)
x_pomiar = linspace(0, 10, 15)';
y_pomiar = 2*x_pomiar + 0.5*x_pomiar.^2 - 0.1*x_pomiar.^3 + 5*sin(x_pomiar/2) + 15*randn(size(x_pomiar));

% Zasada: stopien <= liczba_punktow/3 lub liczba_punktow/2
% Przyklad: badamy blad dla roznych stopni
stopnie = 1:8;
blad = zeros(size(stopnie));

for i = 1:length(stopnie)
    p = polyfit(x_pomiar, y_pomiar, stopnie(i));
    y_test = polyval(p, x_prawdziwe);
    blad(i) = mean((y_test - y_prawdziwe).^2);
end

figure('Position', [100, 100, 1100, 600]);

% GLOWNY WYKRES: Error vs polynomial degree
subplot(1, 2, 1);
plot(stopnie, log10(blad), 'bo-', 'LineWidth', 2.5, 'MarkerSize', 10, 'MarkerFaceColor', 'b');
hold on;

% Zaznacz najlepszy stopien
[min_blad, idx] = min(blad);
plot(stopnie(idx), log10(min_blad), 'r*', 'MarkerSize', 20, 'LineWidth', 2);
plot(stopnie(idx), log10(min_blad), 'ro', 'MarkerSize', 25, 'LineWidth', 2);

% Strefy: underfitting i overfitting
xline(stopnie(idx), 'g--', 'LineWidth', 2);
fill([1, stopnie(idx), stopnie(idx), 1], [-10, -10, 10, 10], [1 0.9 0.9], 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([stopnie(idx), 8, 8, stopnie(idx)], [-10, -10, 10, 10], [0.9 0.9 1], 'FaceAlpha', 0.3, 'EdgeColor', 'none');

% Adnotacje
text(mean([1, stopnie(idx)]), -1, 'UNDERFITTING', 'HorizontalAlignment', 'center', ...
     'FontSize', 11, 'FontWeight', 'bold', 'Color', [0.8 0.2 0.2]);
text(mean([stopnie(idx), 8]), -1, 'OVERFITTING', 'HorizontalAlignment', 'center', ...
     'FontSize', 11, 'FontWeight', 'bold', 'Color', [0.2 0.2 0.8]);
text(stopnie(idx), log10(min_blad)+0.5, sprintf('  NAJLEPSZY: stopien %d', stopnie(idx)), ...
     'FontSize', 11, 'FontWeight', 'bold', 'Color', 'green');

xlabel('Stopien wielomianu', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Log₁₀(Sredni blad kwadratowy MSE)', 'FontSize', 14, 'FontWeight', 'bold');
title('Dobor stopnia wielomianu - Ryzyko underfittingu i overfittingu', 'FontSize', 14, 'FontWeight', 'bold');
grid on;
xlim([1, 8]);
ylim([-3, 5]);
legend({'Blad MSE', 'Minimum bledu', '', 'Underfitting', 'Overfitting'}, 'Location', 'northwest');

% WYKRES POMOCNICZY: Wizualizacja dla niskiego, optymalnego i wysokiego stopnia
subplot(1, 2, 2);

% Przykladowe stopnie
przyklady = [1, stopnie(idx), min(8, stopnie(idx)+2)];
kolory = {'red', 'green', 'blue'};
tytuly = {'Underfitting - za prosty model', sprintf('Optymalny - stopien %d', stopnie(idx)), 'Overfitting - za zlozony model'};

% Krzywa prawdziwa
plot(x_prawdziwe, y_prawdziwe, 'k-', 'LineWidth', 2.5);
hold on;

% Punkty pomiarowe
plot(x_pomiar, y_pomiar, 'ko', 'MarkerSize', 6, 'MarkerFaceColor', 'k');

% Fit dla kazdego przykladu
for i = 1:length(przyklady)
    p = polyfit(x_pomiar, y_pomiar, przyklady(i));
    y_fit = polyval(p, x_prawdziwe);
    plot(x_prawdziwe, y_fit, '-', 'Color', kolory{i}, 'LineWidth', 2);
    text(9, 50 - (i-1)*15, sprintf('%s', tytuly{i}), 'Color', kolory{i}, 'FontSize', 10, 'FontWeight', 'bold');
end

xlabel('x', 'FontSize', 14);
ylabel('y', 'FontSize', 14);
title('Wizualizacja roznych stopni aproksymacji', 'FontSize', 14);
legend('Prawdziwa funkcja', 'Pomiary (zaszumione)', 'Stopien 1 (za prosty)', ...
       sprintf('Stopien %d (optymalny)', stopnie(idx)), ...
       sprintf('Stopien %d (za zlozony)', min(8, stopnie(idx)+2)), ...
       'Location', 'southwest');
grid on;
xlim([0, 10]);
ylim([-20, 80]);
