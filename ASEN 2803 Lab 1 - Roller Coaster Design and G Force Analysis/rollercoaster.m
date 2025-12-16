clear
clc
close all

g = 9.81; % gravitational acceleration, m/s^2
h_initial = 125; % starting position of roller coaster
n = 100;

%% loop

r_loop = 12; % radius of loop
h_loop_bottom = 100; % bottom height of loop

x_loop_center = -50;
z_loop_center = h_loop_bottom + r_loop;

G_loop = @(s) ((2.*(h_initial-(h_loop_bottom+r_loop-r_loop.*cos(s./r_loop)))./r_loop))-sin((s./r_loop)+((3.*pi)./2));
C_loop = 2.*pi.*r_loop; % track length of loop
v_loop_bottom = sqrt(2.*g.*(h_initial-h_loop_bottom));

% plot equation
theta_loop = linspace(0, 2.*pi, n);
x_loop = x_loop_center + r_loop .* cos(theta_loop);
y_loop = 200 .* ones(size(x_loop));
z_loop = h_loop_bottom + r_loop - r_loop .* sin(theta_loop);

%% drop from 125 to loop

z_drop = linspace(h_initial, h_loop_bottom, n);
x_drop = -sqrt(25.*(z_drop - 100)) - 60;
y_drop = 200 .* ones(size(x_drop));

% arc length of drop
dx_dz = gradient(x_drop, z_drop);
drop_arcLength = abs(trapz(z_drop, sqrt(1+dx_dz.^2))); % drop track length

% CHANGE DROP FROM PARABOLA TO CIRCLE


%% drop to loop transition

z_dl_trans = linspace(100, h_loop_bottom, n);
x_dl_trans = linspace(-60, -50, n);
y_dl_trans = 200 .* ones(size(x_dl_trans));
trans_length = 10;

%% banked turn

v_bank = 49.5227; % m/s
theta_bank = 60; % degree of turn
r_bank = ((v_bank.^2)./g).*cot(deg2rad(theta_bank)); % radius of turn
C_bank = (pi.*r_bank)./2; % circumference of turn (amount of track)

% G-forces:
G_bank_up = 1./cos(deg2rad(theta_bank));
G_bank_lat = 0;

%% 3D plot

figure
hold on
grid on
plot3(x_drop, y_drop, z_drop, 'r', 'LineWidth', 2)
plot3(x_dl_trans, y_dl_trans, z_dl_trans, 'r', 'LineWidth', 2)
plot3(x_loop, y_loop, z_loop, 'r', 'LineWidth', 2)
xlim([-100, 50])
ylim([-50, 200])
zlim([0, 140])

xlabel('X Position (m)')
ylabel('Y Position (m)')
zlabel('Z Position (m)')
title('3D Rollercoaster Path')
view(3)
axis equal
