% Autor
% nr grupy
% Co program realizuje

clear
clc
close all  % zamyka okna wszystkich wykresow

funkcja='sin(x)*cos(2x)'; % przykladowa postaæ funkcji rzeczywistej

x= (-pi:2*pi/199:pi); % wspolrzedna x punktow dla ktorych chcemy wyznaczyc wartosc funkcji rzeczywistej

y=sin(x).*cos(2*x);   % wartosci funkcji rzeczywistej

ster=input('nacisnij enter aby zobaczyc przebieg rzeczywistej funkcji ','s');

figure(1)           
plot(x,y,'-k')
xlabel('x')
ylabel('y')
title('przebieg funkcji rzeczywistej')
legend(funkcja)
grid 
hold on

format short 

n=input('podaj liczbe punktow wezlowych n= ');
%disp(['liczba punktow wezlowych n = ', num2str(n)])

%x_w = linspace(-pi,pi,10);   % wspolrzedna x punktow wezlowych interpolacji
x_w= (-pi:2*pi/(n-1):pi);     % inny sposob okreslania wspolrzednej x punktow wezlowych interpolacji 
y_w = sin(x_w).*cos(2*x_w);   % wspolrzedna y punktow wezlowych 


figure(1)           
plot(x_w,y_w,'ob')
xlabel('x')
ylabel('y')
title('Punkty wezlowe na tle funkcji rzeczywistej')
legend(funkcja,['Punkty wezlowe n= ',num2str(n)])
grid on


ster=input('nacisnij enter aby zobaczyc interpolacje przedzialowa liniami prostymi ','s');

%xi= linspace(-pi,pi,100);   % wspó³rzêdna x punktów dla których chcemy wyznaczyæ wartoœæ funkcji interpoluj¹cej
xi= (-pi:2*pi/199:pi);        % inny sposób okreœlania wspó³rzêdnej x punktów dla których chcemy wyznaczyæ wartoœæ funkcji interpoluj¹cej

y_l=interp1(x_w,y_w,xi,'linear');
%disp(['liniowa interpolacja = ',num2str(y_l)])

figure(2)
plot(x_w,y_w,'ob',xi,y_l,'-r',x,y,'-k')
xlabel('x')
ylabel('y')
sgtitle('Interpolacja przedzia³owa funkcjami liniowymi')
legend(['Punkty wezlowe n= ',num2str(n)],'interpolacja linear',funkcja);
grid;

ster=input('nacisnij enter aby zobaczyc interpolacje przedzialowa funkcjami sklejanymi ','s');

figure(3);
y_s=interp1(x_w,y_w,xi,'spline');
%disp(['interpolacja funkcjami sklejanymi = ',num2str(y_s)])
plot(x_w,y_w,'ob',xi,y_s,'-r',x,y,'-k')
xlabel('x')
ylabel('y')
sgtitle('Interpolacja przedzialowa funkcjami sklejanymi')
legend([' Punkty wezlowe n= ',num2str(n)],'interpolacja spline',funkcja);
grid;

ster=input('nacisnij enter aby zobaczyæ interpolacje przedzialowa wielomianami 3 stopnia','s');
y_c=interp1(x_w,y_w,xi,'pchip'); % pchip
%disp(['interpolacja wiel. 3 stop = ',num2str(y_c)])

figure(4)
plot(x_w,y_w,'ob',xi,y_c,'-r',x,y,'-k')
xlabel('x')
ylabel('y')
sgtitle('Interpolacja przedzialowa wielomianami 3 stopnia')
legend(['Punkty wezlowe n= ',num2str(n)],'interpolacja pchip',funkcja);
grid;


ster=input('nacisnij enter aby zobaczyc aproksymacje linia prosta ','s');

f=polyfit(x_w,y_w,1);
%y_wiel_wzor = f(1)*xi.^9 + f(2)*xi.^8 + ...

y_wiel=polyval(f,xi);

figure(5)
plot(x_w,y_w,'ob',xi,y_wiel,'-r',x,y,'-k')
xlabel('x')
ylabel('y')
sgtitle('Aproksymacja funkcja liniowa ')
legend(['Punkty wezlowe n= ',num2str(n)],'aproksymacja linia prosta',funkcja);
grid;

ster=input('nacisnij enter aby zobaczyc aproksymacje wielomianem 3 stopnia ','s');

f=polyfit(x_w,y_w,3);
%y_wiel_wzor = f(1)*xi.^9 + f(2)*xi.^8 + ...

y_wiel=polyval(f,xi);

figure(6)
plot(x_w,y_w,'ob',xi,y_wiel,'-r',x,y,'-k')
xlabel('x')
ylabel('y')
sgtitle('Aproksymacja wielomianem 3 stopnia')
legend(['Punkty wezlowe n= ',num2str(n)],'aproksymacja wiel. 3 stopnia',funkcja);
grid;


ster=input('nacisnij enter aby zobaczyc interpolacje wielomianowa ','s');

stopien_wielomianu = n-1;
f=polyfit(x_w,y_w,stopien_wielomianu);
%y_wiel_wzor = f(1)*xi.^9 + f(2)*xi.^8 + ...

y_wiel=polyval(f,xi);

%disp(['interpolacja wielomianowa = ',num2str(y_wiel)])

figure(7)
plot(x_w,y_w,'ob',xi,y_wiel,'-r',x,y,'-k')
xlabel('x')
ylabel('y')
sgtitle('Interpolacja wielomianowa')
legend(['Punkty wezlowe n= ',num2str(n)],'aproksymacja wiel. n-1',funkcja);
grid;



%blad_linear = sum(abs(y_rz-y_l));
%disp(['b³¹d interpolacji funkcjami liniowymi = ',num2str(blad_linear)])
%blad_linear_w = 100*blad_linear/sum(abs(y_rz));
%disp(['b³¹d wzglêdny interpolacji funkcjami liniowymi = ',num2str(blad_linear_w),' %'])

%blad_spline = sum(abs(y_rz-y_s));
%disp(['b³¹d interpolacji funkcjami sklejanymi = ',num2str(blad_spline)])
%blad_spline_w = 100*blad_spline/sum(abs(y_rz));
%disp(['b³¹d wzglêdny interpolacji funkcjami sklejanymi = ',num2str(blad_spline_w),' %'])


%blad_cubic = sum(abs(y_rz-y_c));
%disp(['b³¹d interpolacji wiel. 3 stop = ',num2str(blad_cubic)])
%blad_cubic_w = 100*blad_cubic/sum(abs(y_rz));
%disp(['b³¹d wzglêdny interpolacji wiel. 3 stop = ',num2str(blad_cubic_w),' %'])


%blad_wiel = sum(abs(y_rz-y_wiel));
%disp(['b³¹d interpolacji wielomianowej = ',num2str(blad_wiel)])
%blad_wiel_w = 100*blad_wiel/sum(abs(y_rz));
%disp(['b³¹d wzglêdny interpolacji wielomianowej = ',num2str(blad_wiel_w),' %'])


disp(' Pozamykaj wszystkie wykresy przed ponownym uruchomieniem programu')

