% Punkty nawigacyjne kamery przelatujacej nad miastem (dron)
czas = 0:2:8;
wysokosc = [10, 30, 15, 25, 10]; 

% Szukamy idealnie plynnej trajektorii bez szarpniec
czas_dokladny = 0:0.1:8;
wysokosc_smooth = interp1(czas, wysokosc, czas_dokladny, 'spline');
wysokosc_linear = interp1(czas, wysokosc, czas_dokladny, 'linear');

figure('Position', [100, 100, 900, 500]);

% 1. TYLKO WEZLY GPS
h1 = plot(czas, wysokosc, 'ko', 'MarkerSize', 10, 'LineWidth', 2, 'MarkerFaceColor', 'k');
hold on;
xlabel('Czas trwania lotu (sekundy)', 'FontSize', 14);
ylabel('Wysokosc drona (metry)', 'FontSize', 14);
title('Misja filmowa drona - punkty nawigacyjne GPS', 'FontSize', 14, 'FontWeight', 'bold');
legend(h1, {'Punkty GPS (Wezly)'}, 'Location', 'best');
grid on;
xlim([0, 8]);
ylim([0, 40]);
set(gca, 'XTick', 0:1:8, 'YTick', 0:5:40, 'FontSize', 11);
box on;

disp('Wcisnij dowolny klawisz, aby sprawdzic metode liniowa (linear)...');
pause;

% 2. LINIOWA
h3 = plot(czas_dokladny, wysokosc_linear, 'r--', 'LineWidth', 1);
text(2.6, 12, 'linear tworzy "skok"', 'Color', 'r', 'FontSize', 10, 'Rotation', -35);
title('Lot drona ze sztywnym przechodzeniem przez punkty (linear)', 'FontSize', 13, 'FontWeight', 'bold');
legend([h1, h3], {'Punkty GPS (Wezly)', 'Zly lot (linear - szarpanie)'}, 'Location', 'best');

disp('Wcisnij dowolny klawisz, aby wyznaczyc idealnie plynna trase (spline)...');
pause;

% 3. SPLINE
h2 = plot(czas_dokladny, wysokosc_smooth, 'b-', 'LineWidth', 2.5, 'Color', '#5BC0DE');
area(czas_dokladny, wysokosc_smooth, 'FaceColor', [0.4 0.7 0.9], 'FaceAlpha', 0.2, 'EdgeColor', 'none');
text(1, 32, 'spline wykracza za punkt, aby zachowac gladkosc', 'Color', 'b', 'FontSize', 10);
title('Interpolacja spline - doskonale plynna trajektoria lotu', 'FontSize', 13, 'FontWeight', 'bold');
legend([h1, h3, h2], {'Punkty GPS (Wezly)', 'Zly lot (linear)', 'Plynny lot (spline)'}, 'Location', 'best');
