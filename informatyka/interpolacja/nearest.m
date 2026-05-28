% Polaczenie telefonu z masztami BTS (pozycje masztow w km trasy)
maszty_km = [5, 15, 25, 35];
maszt_id = [101, 102, 103, 104]; % identyfikatory stacji bazowych

% Z jakim masztem polaczy sie telefon na 18 kilometrze trasy?
polaczenie_18km = interp1(maszty_km, maszt_id, 18, 'nearest');
disp(['Na 18 km telefon uzywa masztu ID: ', num2str(polaczenie_18km)]);

% Tworzenie wykresu
figure('Position', [100, 100, 1000, 600]);

% 1. TYLKO PUNKTY POMIAROWE - pozycje masztow
plot(maszty_km, maszt_id, 'bo', 'LineWidth', 2, 'MarkerSize', 10, 'MarkerFaceColor', 'b');
hold on;
xlabel('Dystans na trasie podrozy (km)', 'FontSize', 14);
ylabel('ID Masztu BTS', 'FontSize', 14);
title('Przelaczanie stacji bazowych BTS - interpolacja nearest', 'FontSize', 14);
legend({'Polozenie masztow'}, 'Location', 'northwest');
grid on;
xlim([0, 40]);
ylim([100, 105]);
set(gca, 'YTick', 100:1:105);
disp('Wcisnij dowolny klawisz, aby pokazac strefy zasiegu (metoda nearest)...');
pause;

% 2. STREFY ZASIEGU
km_szczegolowy = linspace(0, 40, 400);
id_nearest = interp1(maszty_km, maszt_id, km_szczegolowy, 'nearest', 'extrap');
plot(km_szczegolowy, id_nearest, 'm-', 'LineWidth', 2);
legend({'Polozenie masztow', 'Zasieg stacji bazowych (ciagla schodkowa)'}, 'Location', 'northwest');
disp('Wcisnij dowolny klawisz, aby sprawdzic 18 km trasie...');
pause;

% 3. TELEFON NA 18 KM
plot(18, polaczenie_18km, 'rs', 'MarkerSize', 15, 'LineWidth', 2, 'MarkerFaceColor', 'r');
plot([18, 15], [polaczenie_18km, 102], 'r--', 'LineWidth', 1.5);
plot(15, 102, 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
legend({'Polozenie masztow', 'Zasieg stacji bazowych', 'Pozycja telefonu (18 km)', 'Linia do najblizszego masztu', 'Wybrany najblizszy maszt'}, 'Location', 'northwest');
text(18, polaczenie_18km + 0.3, sprintf('  %d km -> ID %d', 18, polaczenie_18km), 'FontSize', 11, 'Color', 'red');
