clear
close all
clc

h_start = 125;

g = 9.81;

MaxG_up = 6;
MaxG_down = -1;
MaxG_lateral = 3;
MaxG_forward = 5;
MaxG_backward = -4;

%% Start to loop

r_loop_transition1 = 25;
h_transition1_start = 125;

G_loop_transition1 = @(s) (((2*(h_start-(h_transition1_start - r_loop_transition1 + r_loop_transition1*cos(s/r_loop_transition1))))/(r_loop_transition1)) - sin((s/r_loop_transition1) + (pi)));

s_tran1 = pi*r_loop_transition1/2;

%% Loop

h_loop_bottom = 100;
r_loop = 11;

G_loop = @(s) (((2*(h_start-(h_loop_bottom + r_loop - r_loop*cos(s/r_loop))))/(r_loop)) - sin((s/r_loop)+(3*pi/2)));

s_loop = 2*pi*r_loop;

%% Test Plot

s1 = linspace(0, pi*r_loop_transition1/2, 500);
s2 = linspace(0, 2*pi*r_loop, 500);
Gs_1and2 = [G_loop_transition1(s1) G_loop(s2)];

s_tot = linspace(0, (pi*r_loop_transition1/2) + (2*pi*r_loop), 1000);

figure;
plot(s_tot, Gs_1and2)



%% Straight to parabola

Gstraight = 1;

s_straight = 50;

%% Transition to parabola

r_loop_transition2 = 20/(2-sqrt(2));
h_transition2_start = 100;

G_loop_transition2 = @(s) (((2*(h_start-(h_transition2_start + r_loop_transition2 - r_loop_transition2*cos(s/r_loop_transition2))))/(r_loop_transition2)) - sin((s/r_loop_transition1) + (3*pi/2)));

h_after_transition2 = 100 + (r_loop_transition2-(r_loop_transition2*(sqrt(2)/2)));

s_tran2 = pi*r_loop_transition2/4;

figure;
fplot(G_loop_transition2, [0 pi*r_loop_transition2/4])

%% Parabola

h_0 = h_after_transition2;
theta_0 = 45;
v0 = sqrt(2*g*(h_start - h_0));

y = @(x) (tand(theta_0)*x) - (g*(x^2))/(2*v0^2*cosd(theta_0)^2) + h_0;
dy_dx = @(x) (tand(theta_0) - ((g/((v0^2)*((cosd(theta_0))^2)))*x));
dy2_d2x = @(x) ((-1*g)/((v0^2)*(cosd(theta_0)^2)));

rho = @(x) ((1 + (dy_dx(x)^2))^(3/2))/abs(dy2_d2x(x));

s(1) = 0;
y_calc(1) = h_0;
x(1) = 0;
dx = .1;
v(1) = sqrt(2*g*(h_start-h_0));
G_up_down(1) = 0;

y_ground = @(x) (tand(theta_0)*x) - (g*(x^2))/(2*v0^2*cosd(theta_0)^2);

y_equal = fzero(y_ground,[20 1000]);

for i = 2:((y_equal/dx)+1)
    
    x(i) = x(i-1) + dx;
    y_calc(i)= y(x(i));
    dy = y_calc(i) - y_calc(i-1);
    ds(i) = sqrt(dx^2 + (dy)^2);
    s(i) = s(i-1) + ds(i);
    
    v(i) = sqrt(2*g*(h_start-y_calc(i)));
    
    theta(i) = atan(dy_dx(x(i)));
    G_up_down(i) = cos(theta(i))-(v(i)^2)/(rho(x(i))*g);

end

G_up_parabola = G_up_down;
s_parabola = s;

%% Linear portion after parabola

G_linear = cosd(theta_0);
h_0_linear = h_0;
h_f_linear = 10;

dh_linear = h_0_linear - h_f_linear;
s_linear = dh_linear/sind(theta_0);



%% Transition to Banked Turn 

h_transition5_start = 20;
r_loop_transition5 = 40/(2-sqrt(2));


G_loop_transition5 = @(s) (((2*(h_start-(h_transition5_start - r_loop_transition5 + r_loop_transition5*cos(s/r_loop_transition5))))/(r_loop_transition5)) - sin((s/r_loop_transition5) + (5*pi/4)));

s_tran5 = pi*r_loop_transition5/4;

s5 = linspace(0, pi*r_loop_transition5/4, 500);
Gs_5 = G_loop_transition5(s5);

figure;
fplot(G_loop_transition5, [0 pi*r_loop_transition5/4])


%% Banked Turn

v_0_banked = sqrt(2 * g * h_start);
theta_turn = 60;
r_banked = (v_0_banked^2 * cotd(theta_turn)) / g;
s_banked = (pi * r_banked) / 2;
G_v_banked = 1 / cosd(theta_turn);
G_lateral_banked = 0;
G_forward_banked = 0;


%% Braking Section

v_0_brake = sqrt(2 * g * h_start);
s_brake = 50;

a_brake = -v_0_brake^2 / (2 * s_brake);

s = linspace(0, s_brake, 100);
v = sqrt(v_0_brake^2 + 2 * a_brake * s);

G_forward_brake = a_brake / g;
G_vertical_brake = 1;
G_lateral_brake = 0;


%% G's Full Coaster
s_tot = 0;

s_vec_tran1 = linspace(0, s_tran1, 500);
s_tot = s_tot + s_tran1;
G_up_tran1 = G_loop_transition1(s_vec_tran1);
G_forward_tran1 = zeros(1,500);
G_lateral_tran1 = zeros(1,500);

s_vec_loop = linspace(0, s_loop, 500);
G_up_loop = G_loop(s_vec_loop);
G_forward_loop = zeros(1,500);
G_lateral_loop = zeros(1,500);
s_vec_loop = s_vec_loop + s_tot;
s_tot = s_tot + s_loop;

s_vec_straight = linspace(0, s_straight, 500);
G_up_straight = ones(1,500);
G_forward_straight = zeros(1,500);
G_lateral_straight = zeros(1,500);
s_vec_straight = s_vec_straight + s_tot;
s_tot = s_tot + s_straight;

s_vec_tran2 = linspace(0, s_tran2, 500);
G_up_tran2 = G_loop_transition2(s_vec_tran2);
G_forward_tran2 = zeros(1,500);
G_lateral_tran2 = zeros(1,500);
s_vec_tran2 = s_vec_tran2 + s_tot;
s_tot = s_tot + s_tran2;

s_parabola_tot = s_parabola(end);
G_forward_parabola = zeros(1,length(s_parabola));
G_lateral_parabola = zeros(1,length(s_parabola));
s_parabola = s_parabola + s_tot;
s_tot = s_tot + s_parabola_tot;

s_vec_linear = linspace(0, s_linear, 500);
G_up_linear = G_linear*ones(1,500);
G_forward_linear = zeros(1,500);
G_lateral_linear = zeros(1,500);
s_vec_linear = s_vec_linear + s_tot;
s_tot = s_tot + s_linear;

s_vec_tran5 = linspace(0, s_tran5, 500);
G_up_tran5 = G_loop_transition5(s_vec_tran5);
G_forward_tran5 = zeros(1,500);
G_lateral_tran5 = zeros(1,500);
s_vec_tran5 = s_vec_tran5 + s_tot;
s_tot = s_tot + s_tran5;

s_vec_banked = linspace(0, s_banked, 500);
G_up_banked = G_v_banked*ones(1,500);
G_forward_banked = zeros(1,500);
G_lateral_banked = zeros(1,500);
s_vec_banked = s_vec_banked + s_tot;
s_tot = s_tot + s_banked;

s_vec_brake = linspace(0, s_brake, 500);
G_up_brake = G_vertical_brake*ones(1,500);
G_forward_brake_vec = G_forward_brake*ones(1,500);
G_lateral_brake_vec = zeros(1,500);
s_vec_brake = s_vec_brake + s_tot;
s_tot = s_tot + s_brake;

s_vec_full_coaster = [s_vec_tran1, s_vec_loop, s_vec_straight, s_vec_tran2, s_parabola, s_vec_linear,s_vec_tran5, s_vec_banked, s_vec_brake];

G_up_full_coaster = [G_up_tran1, G_up_loop, G_up_straight, G_up_tran2, G_up_parabola, G_up_linear, G_up_tran5, G_up_banked, G_up_brake];
G_forward_full_coaster = [G_forward_tran1, G_forward_loop, G_forward_straight, G_forward_tran2, G_forward_parabola, G_forward_linear, G_forward_tran5, G_forward_banked, G_forward_brake_vec];
G_lateral_full_coaster = [G_lateral_tran1, G_lateral_loop, G_lateral_straight, G_lateral_tran2, G_lateral_parabola, G_lateral_linear, G_lateral_tran5, G_lateral_banked, G_lateral_brake_vec];



figure;
subplot(3,1,1)
plot(s_vec_full_coaster, G_up_full_coaster)

subplot(3,1,2)
plot(s_vec_full_coaster, G_forward_full_coaster)

subplot(3,1,3)
plot(s_vec_full_coaster, G_lateral_full_coaster)


