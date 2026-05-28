clc
clear
close all

y0_1=[1 , 2];
y0_2=[3 , 5];
tspan=0:0.05:10;
[x1,y1]=ode45(@odefun,tspan,y0_1);
[x2,y2]=ode45(@odefun,tspan,y0_2);

figure(3)
subplot(1,2,1)
   plot(x1,y1(:,1),'-k',x1,y1(:,2),'--r')
   title('rozwiazanie dla  y_1(x=0)=1 , y_2(x=0)=2');
   xlabel('x');
   ylabel('y_1 , y_2');
   legend('y_1','y_2');
   grid 

subplot(1,2,2)
   plot(x2,y2(:,1),'-k',x2,y2(:,2),'--r')
   title('rozwiazanie dla  y_1(x=0)=3 , y_2(x=0)=5');
   xlabel('x');
   ylabel('y_1 , y_2');
   legend('y_1','y_2');
   grid 

function dydx=odefun(x,y)
    dydx=[cos(y(1))*sin(y(2))+0.1*sin(x) ; -0.2*(y(1))*cos(y(2))];
end