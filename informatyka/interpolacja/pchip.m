% Przebieg samochodu w kolejnych miesiacach (w tys. km)
% Samochod nastepnie stal u mechanika przez 3 miesiace.
miesiace = 1:6;
przebieg = [100, 102, 102, 102, 105, 108]; 

% Generujemy ciagly przebieg
szczeg_mies = 1:0.1:6;
przebieg_pchip = interp1(miesiace, przebieg, szczeg_mies, 'pchip');
przebieg_spline = interp1(miesiace, przebieg, szczeg_mies, 'spline');

figure('Position', [100, 100, 900, 600]);

% 1. TYLKO ODCZYTY ORAZ GARAZ
fill([2, 2, 4, 4], [98, 110, 110, 98], [0.9 0.95 1], 'EdgeColor', 'none', 'FaceAlpha', 0.3);
hold on;
plot(miesiace, przebieg, 'ko', 'MarkerSize', 10, 'LineWidth', 2, 'MarkerFaceColor', 'k');

for i = 1:length(miesiace)
    text(miesiace(i), przebieg(i) + 0.5, sprintf('%.0f k', przebieg(i)), ...
         'HorizontalAlignment', 'center', 'FontSize', 10, 'FontWeight', 'bold');
end

xlabel('Czas (miesiace)', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Przebieg pojazdu (tys. km)', 'FontSize', 14, 'FontWeight', 'bold');
title('Analiza przebiegu auta - postoj w garazu', 'FontSize', 14, 'FontWeight', 'bold');
legend({'Auto w garazu (brak jazdy)', 'Odczyty co miesiac'}, 'Location', 'northwest', 'FontSize', 11);
grid on;
xlim([0.5, 6.5]);
ylim([98, 110]);
set(gca, 'FontSize', 11, 'XTick', 1:6);
set(gca, 'GridAlpha', 0.3, 'GridLineStyle', ':');

disp('Wcisnij dowolny klawisz, aby sprawdzic zachowanie wygładzania spline...');
pause;

% 2. ZLE ZACHOWANIE SPLINE
plot(szczeg_mies, przebieg_spline, 'r--', 'LineWidth', 2);
[~, idx] = min(przebieg_spline);
%plot(szczeg_mies(idx), przebieg_spline(idx), 'r*', 'MarkerSize', 10);
legend({'Auto w garazu', 'Odczyty co miesiac', 'Spline (Licznik sie cofa - ZLE!)'}, 'Location', 'northwest', 'FontSize', 11);
title('Problem z metoda spline - niefizyczne zachowanie', 'FontSize', 13, 'FontWeight', 'bold');

disp('Wcisnij dowolny klawisz, aby sprawdzic metode pchip...');
pause;

% 3. POPRAWNE ZACHOWANIE PCHIP
plot(szczeg_mies, przebieg_pchip, 'b-', 'LineWidth', 2.5);
legend({'Auto w garazu', 'Odczyty', 'Spline (zle)', 'Blad spline', 'PCHIP (Licznik stoi bezpiecznie)'}, 'Location', 'northwest', 'FontSize', 11);
title('PCHIP zapobiega "cofaniu" licznika i poprawnie zachowuje postoj', 'FontSize', 13, 'FontWeight', 'bold');
