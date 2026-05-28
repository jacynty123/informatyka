clc
clear
close all
disp('Calkowanie jednego rownania - zad1 lub 1')
disp('Calkowanie ukladu rownan - zad2 lub 2')
wybor = input('wybierz zadanie ','s');
switch wybor 
    case {'zad1','1'}
        tspan=2:0.05:6;
        y0 = 4.3;        
        [t,y]=ode23(@odefun1,tspan,y0);
        figure(1)
        plot(t,y)
    case {'zad2','2'}
        xspan=0:0.01:4;
        y0 = [5 , 10];    
        [x,y]=ode45(@odefun2,xspan,y0);
        figure(3)
        plot(x,y)
    otherwise
        disp('niepoprawny wybor')
end

function dydt=odefun1(t,y)
    dydt= -2*sin(y) + 1.5*cos(5*t) + 3;
end

function dydx=odefun2(x,y)
    dydx=[ 0.1*y(1) - cos(y(2))+ x ; -2*y(2) + sin(y(1))];
end
