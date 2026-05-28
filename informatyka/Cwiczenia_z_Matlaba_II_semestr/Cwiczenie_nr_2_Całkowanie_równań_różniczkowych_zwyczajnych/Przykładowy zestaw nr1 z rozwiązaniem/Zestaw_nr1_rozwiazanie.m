clc
clear
close all

disp('Calkowanie jednego rownania - liczba z przedzalu (0,1>')
disp('Calkowanie ukladu rownan - liczba z przedzalu <2,3)')
wybor = input('wybierz zadanie ');
if wybor > 0 && wybor <= 1

    skok = input('co ile maja byc obliczenia? skok = ');
    tspan=2:skok:6;
    y0 = input('Podaj warunek poczatkowy na y = ');
    
    [t,y]=ode23(@odefun1,tspan,y0);
    figure(1)
    plot(t,y)

elseif wybor>= 2 && wybor< 3

    skok = input('co ile maja byc obliczenia? skok = ');
    tspan=0:skok:4;

    y1_0 = input('Podaj warunek poczatkowy na y1 = ');
    y2_0 = input('Podaj warunek poczatkowy na y2 = ');

    y0 = [y1_0 , y2_0];

    [x,y]=ode45(@odefun2,tspan,y0);
    figure(3)
    plot(x,y)
else
    disp('wprowadzono niepoprawna liczbe')
end

function dydt=odefun1(t,y)
    dydt= -2*sin(y) + 1.5*cos(5*t) + 3;
end

function dydx=odefun2(x,y)
    dydx=[ 0.1*y(1) - cos(y(2))+ x ; -2*y(2) + sin(y(1))];
end
