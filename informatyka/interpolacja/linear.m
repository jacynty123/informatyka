% Przyklad: spalanie paliwa na autostradzie (jazda na tempomacie)
% Odczyty ze wskaznika co 2 godziny
czas = [8, 10, 12, 14];
paliwo = [50, 35, 20, 5]; % ubywa po 15 litrow co 2 godziny

% Ile paliwa bylo o godzinie 11:00?
dokladny_czas = 11;
paliwo_wyliczone = interp1(czas, paliwo, dokladny_czas, 'linear');
disp(['O 11:00 w baku bylo: ', num2str(paliwo_wyliczone), ' litrow']);

% Tworzenie wykresu
figure;

% 1. TYLKO PUNKTY POMIAROWE
plot(czas, paliwo, 'bo', 'LineWidth', 2, 'MarkerSize', 10, 'MarkerFaceColor', 'b');
hold on;
xlabel('Godzina', 'FontSize', 14);
ylabel('Ilosc paliwa (litry)', 'FontSize', 14);
title('Spalanie paliwa na autostradzie - interpolacja liniowa', 'FontSize', 14);
legend('Pomiary z baku', 'Location', 'northeast');
grid on;
xlim([7, 15]);
ylim([0, 60]);
disp('Wcisnij dowolny klawisz, aby pokazac linie interpolacji liniowej...');
pause;

% 2. PELNY WYKRES INTERPOLOWANY
szczegolowy_czas = linspace(8, 14, 100);
paliwo_szczegolowy = interp1(czas, paliwo, szczegolowy_czas, 'linear');
plot(szczegolowy_czas, paliwo_szczegolowy, 'g--', 'LineWidth', 1, 'Color', [0.5 0.5 0.5]);
legend('Pomiary z baku', 'Interpolacja liniowa', 'Location', 'northeast');
disp('Wcisnij dowolny klawisz, aby pokazac wyliczony punkt o 11:00...');
pause;

% 3. WYLICZONY PUNKT (11:00)
plot(dokladny_czas, paliwo_wyliczone, 'ro', 'MarkerSize', 12, 'MarkerFaceColor', 'r');
legend('Pomiary z baku', 'Interpolacja liniowa', 'Odczyt o 11:00', 'Location', 'northeast');
