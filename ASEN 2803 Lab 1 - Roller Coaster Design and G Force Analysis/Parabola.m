clear;
close all;
clc

h_max = 125;
h_0 = 100;
theta_0 = 0;
g = 9.81;
v0 = sqrt(2*g*(h_max - h_0));

y = @(x) (tand(theta_0)*x) - (g*(x^2))/(2*v0^2*cosd(theta_0)^2) + h_0;
dy_dx = @(x) (tand(theta_0) - ((g/((v0^2)*((cosd(theta_0))^2)))*x));
dy2_d2x = @(x) ((-1*g)/((v0^2)*(cosd(theta_0)^2)));

rho = @(x) ((1 + (dy_dx(x)^2))^(3/2))/abs(dy2_d2x(x));

% v = sqrt(2*g*(h_max - y));

figure;
fplot(y,[0 100])

figure;
fplot(rho,[0 50])

s(1) = 0;
y_calc(1) = h_0;
x(1) = 0;
dx = .1;
v(1) = sqrt(2*g*(h_max-h_0));
G_up_down(1) = 0;

y_root = fzero(y,[0 120]);

for i = 2:((y_root/dx)+1)
    
    x(i) = x(i-1) + dx;
    theta(i) = asin(x(i) / rho(x(i))) ;
    y_calc(i)= y(x(i));
    dy = y_calc(i) - y_calc(i-1);
    ds(i) = sqrt(dx^2 + (dy)^2);
    s(i) = s(i-1) + ds(i);
    
    v(i) = sqrt(2*g*(h_max-y_calc(i)));

    G_up_down(i) = 0;

end

figure;
plot(s, G_up_down)

