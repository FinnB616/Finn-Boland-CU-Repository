clear; clc; close all;

h_max = 125;
g = 9.81;
v_0 = sqrt(2 * g * h_max);
theta_turn = 60;
r = (v_0^2 * cotd(theta_turn)) / g;
s = (pi * r) / 2;
G_v = 1 / cosd(theta_turn);
G_lateral = 0;
G_forward = 1;

path_length = linspace(0, s, 100);
G_vertical = G_v * ones(size(path_length));
G_lateral_plot = G_lateral * ones(size(path_length));
G_forward_plot = G_forward * ones(size(path_length));

figure;
subplot(3,1,1);
plot(path_length, G_vertical, 'b', 'LineWidth', 2);
title('Vertical G-force vs Path Length');
xlabel('Path Length (m)');
ylabel('G-force (G)');
ylim([0, 6]);

subplot(3,1,2);
plot(path_length, G_lateral_plot, 'r', 'LineWidth', 2);
title('Lateral G-force vs Path Length');
xlabel('Path Length (m)');
ylabel('G-force (G)');
ylim([0, 6]);

subplot(3,1,3);
plot(path_length, G_forward_plot, 'g', 'LineWidth', 2);
title('Forward G-force vs Path Length');
xlabel('Path Length (m)');
ylabel('G-force (G)');
ylim([0, 6]);

theta = linspace(0, pi/2, 100);
x = r * cos(theta);
y = r * sin(theta);
z = zeros(size(theta));

figure;
plot3(x, y, z, 'k', 'LineWidth', 2);
grid on;
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
zlim([0,125])
title('Banked Turn');
