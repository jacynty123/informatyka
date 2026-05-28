% numer zestawu lab zadania 
% Nazwisko i imie oraz nr grupy

clear
clc
close all
x = [0 , 1, 3, 4.5 , 2*pi];
y = 2*sin(x) + x;
disp('Aproksymacja - wpisz z klawiatury a lub aproksymacja')
disp('Interpolacja - wpisz z klawiatury i lub interpolacja') 

wybor = input('co bedzie liczone: ','s');

switch wybor
    case {'a' , 'aproksymacja'}
        xi=input('podaj xi = ');
        ww = polyfit(x,y,2);
        ya = polyval(ww,xi);
        clc % czysci ekran
        disp(['dla x = ',num2str(xi),'   y = ',num2str(ya),' wedlug aproksymacji wielomianem 2 stopnia'])
    case  {"i" , "interpolacja"}
        ster=input('interpolacja przedzialowa (10) czy wielomianowa (20 lub 30): ');
        if ster == 10
            yi=interp1(x,y,2.5,'linear');
            clc % czysci ekran
            disp(['dla x = 2,5  y = ',num2str(yi),' wedlug interpolacji przedzialowej - linear'])
        elseif ster == 20 || ster == 30
            ww = polyfit(x,y,4);
            % w przypadku interpolacji wielomianowej stopien wielomianu 
            % musi byæ mniejszy o 1 od liczby punktow wezlowych
            x2=[1.8 , 4.1];
            yw = polyval(ww,x2);
            clc %czysci ekran
            disp(['dla x = 1,8  y = ',num2str(yw(1)),' wedlug interpolacji wielomianowej'])      
            disp(['dla x = 4,1  y = ',num2str(yw(2)),' wedlug interpolacji wielomianowej'])      
        else
            disp('Niepoprawna liczba')
        end
    otherwise
       disp('Niepoprawny tekst')                
end
    

