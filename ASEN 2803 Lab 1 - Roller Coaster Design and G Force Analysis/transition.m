%{ 
    F = ma
    T = KE = (1/2)*m*(v^2)
    V = PE = m*g*h
    h = height
    g = 9.81 m/s^2
    h0 = 125 m
    v0 = 0 m/s

    E = T + V = (1/2)*m*(v^2) + m*g*h
    E0 = m*g*h0
    E1 = (1/2)*m*v1^2 + m*g*h1
    v(h) = sqrt(2*g*(h0-h1))
    h1 > h0 only if additional energy is added

    BANKED TURN
    r = ((v^2)/g)*cot(theta)
        theta = 60
        v = 49.5227 m/s
        r = 144.33 m
    quarter bank circumference = (1/4)*2*pi*r
        = (pi*r)/2 = 226.725 m
    G-forces:
        Gup = 1/cos(theta) = 1/cos(60) = 2
        Glat=Gforward=Gback = 0
%}

clear;
clc;
close all;


h_start = 125;
h_transition_start = 125;
r_loop = 25;

MaxG_up = 6;
MaxG_down = -1;
MaxG_lateral = 3;
MaxG_forward = 5;
MaxG_backward = -4;

G_loop_transition = @(s) (((2*(h_start-(h_transition_start - r_loop + r_loop*cos(s/r_loop))))/(r_loop)) - sin((s/r_loop) + (pi)));

figure;
fplot(G_loop_transition, [0,pi*r_loop/2])
hold on
yline(MaxG_up, 'Color', 'r', 'LineStyle','--')
yline(MaxG_down, 'Color', 'k', 'LineStyle','--')
ylim([-2 8])
title("Loop Up and Down G's vs Track Length")
xlabel('Track Length (m)')
ylabel("Up and Down G's")
legend("Up and Down G's", "Max Upward G's", "Max Downward G's")

figure;
fplot(0, [0,pi*r_loop/2])
hold on
yline(MaxG_forward, 'Color', 'r', 'LineStyle','--')
yline(MaxG_backward, 'Color', 'k', 'LineStyle','--')
ylim([MaxG_backward-1 MaxG_forward+2])
title("Loop Forward and Backward G's vs Track Length")
xlabel('Track Length (m)')
ylabel("Forward and Backward G's")
legend("Forward and Backward G's", "Max Forward G's", "Max Backward G's")

figure;
fplot(0, [0,pi*r_loop/2])
hold on
yline(MaxG_lateral, 'Color', 'r', 'LineStyle','--')
yline(-1*MaxG_lateral, 'Color', 'k', 'LineStyle','--')
ylim([-1*MaxG_lateral-1 MaxG_lateral+2])
title("Loop Lateral G's vs Track Length")
xlabel('Track Length (m)')
ylabel("Lateral G's")
legend("Lateral G's", "Max Lateral G's", "Max Lateral G's (other direction)")

