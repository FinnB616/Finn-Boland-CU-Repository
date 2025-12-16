clear; clc; close all;

h_max = 125;
g = 9.81;
v_0 = sqrt(2 * g * h_max);
s_brake = 50;

a_brake = -v_0^2 / (2 * s_brake);

s = linspace(0, s_brake, 100);
v = sqrt(v_0^2 + 2 * a_brake * s);

G_forward = -a_brake / g;
G_vertical = 1;
G_lateral = 0;

figure;
subplot(3,1,1);
plot(s, G_vertical * ones(size(s)), 'b', 'LineWidth', 2);
title('Vertical G-force vs Path Length');
xlabel('Path Length (m)');
ylabel('G-force (G)');
ylim([0, 6]);

subplot(3,1,2);
plot(s, G_lateral * ones(size(s)), 'r', 'LineWidth', 2);
title('Lateral G-force vs Path Length');
xlabel('Path Length (m)');
ylabel('G-force (G)');
ylim([0, 6]);

subplot(3,1,3);
plot(s, G_forward * ones(size(s)), 'g', 'LineWidth', 2);
title('Forward G-force vs Path Length');
xlabel('Path Length (m)');
ylabel('G-force (G)');
ylim([0, 6]);

x_brake = linspace(0, s_brake, 100);
y_brake = zeros(size(x_brake));
z_brake = zeros(size(x_brake));

figure;
plot3(x_brake, y_brake, z_brake, 'k', 'LineWidth', 2);
grid on;
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
zlim([0,125]);
title('Braking Section at Z = 0');
