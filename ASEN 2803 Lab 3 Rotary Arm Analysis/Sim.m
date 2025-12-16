%% Equation Input
k_g = 33.3; % no units
k_m = 0.0401; % V/(rad/sec) or Nm/amp
k_p0 = 25;
J_hub = 0.0005; % kgm^2
J_extra = (0.2*.2794^2); % kgm^2
J_load = 0.0015; % kgm^2
J = J_hub + J_extra + J_load; % kgm^2
R_m = 19.2; % ohms
k_D0 = 1.5;

n1 = (k_p0*k_g*k_m) / (J*R_m);

d2 = 1;
d1 = ((k_g^2 * k_m^2) / (J*R_m)) + ((k_D0*k_g*k_m) / (J*R_m));
d0 = (k_p0*k_g*k_m) / (J*R_m);

%% Closed Loop System
num = n1;
den = [d2 d1 d0];
sysTF = tf(num, den);

%% Step Response
[x, t] = step(sysTF);

%% Plot

figure;
plot(t, x);
