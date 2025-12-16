clc, clear, close all;

%% Equation Input
k_g = 33.3;             % no units
k_m = 0.0401;           % V/(rad/sec) or Nm/amp
k_p0 = [20 22];            % k1 - Proportional Gain
J_hub = 0.0005;         % kgm^2
J_extra = (0.2*.2794^2);% kgm^2
J_load = 0.0015;        % kgm^2
J = J_hub + J_extra + J_load; % kgm^2
R_m = 19.2;             % ohms
k_D0 = [1.5 1.5];           %k3 - Derivative Gain

n1 = (k_p0*k_g*k_m) / (J*R_m);

%Number of sets
sets = 2;

d2 = ones([1,sets]);
d1 = ((k_g^2 * k_m^2) / (J*R_m)) + ((k_D0*k_g*k_m) / (J*R_m));
d0 = (k_p0*k_g*k_m) / (J*R_m);

%% Var Dec
x = cell(1,sets);
t = cell(1,sets);
time = 0:.01:10;
u_t = ones(size(time)) * .5;
u_t(time>=5) = -.5;

%% Closed Loop System
num = n1;
den = [d2' d1' d0'];
config = RespConfig("Amplitude",.5);

figure(1) 
hold on;
for i = 1:sets
    sysTF = tf(num(i), den(i,:));
    [x{i}, t{i}] = lsim(sysTF, u_t, time);
    model_x{i} = x{i};
    model_t{i} = t{i};
end

plot(t{i}, x{i}, 'LineWidth',1.25); %['Set ', num2str(i)]
plot(time, u_t, 'LineWidth',1.5,'Color',[0.8500 0.3250 0.0980]);
xlabel('Time (s)');
ylabel('Position (rad)');
title('Modeled Position vs Time for K1 = 20 and k3 = 1.5')
yline(-.6, 'Color','k', 'LineStyle',':', 'LineWidth',1.5);
yline(-.4, 'Color','k', 'LineStyle',':', 'LineWidth',1.5);
yline(-.525, 'Color','r','LineStyle',':', 'LineWidth',1.5);
yline(-.475, 'Color','r','LineStyle',':', 'LineWidth',1.5);

yline(.6, 'Color','k', 'LineStyle',':', 'LineWidth',1.5);
yline(.4, 'Color','k', 'LineStyle',':', 'LineWidth',1.5);
yline(.525, 'Color','r','LineStyle',':', 'LineWidth',1.5);
yline(.475, 'Color','r','LineStyle',':', 'LineWidth',1.5);
legend('Response', 'Input', '20% Error','','5% Error');
    
legend Location east;
grid on;
hold off;

%% 2.4 C: Step Response from Hardware With Given K1 = 20 & k3 = 1.5
filename = 'lab3_harveytest1'; %k1 = 20; k3 = 1.5
data = readmatrix(filename);
data_time = data(:,1)./1000;
data_response = data(:,2);
data_input = data(:,6);
data_response = data_response(data_time>=1265);
data_input = data_input(data_time>=1265);
data_time = data_time(data_time>=1265) - 1265;

figure(11)
hold on;
plot(data_time, data_response, 'LineWidth', 1.5);
plot(data_time, data_input, 'LineWidth',1.5);

title('Experimental Position vs Time for K1 = 20 and k3 = 1.5')
xlabel('Time (s)');
ylabel('Position (rad)');

yline(-.6, 'Color','k', 'LineStyle',':', 'LineWidth',1.5);
yline(-.4, 'Color','k', 'LineStyle',':', 'LineWidth',1.5);
yline(-.525, 'Color','r','LineStyle',':', 'LineWidth',1.5);
yline(-.475, 'Color','r','LineStyle',':', 'LineWidth',1.5);

yline(.6, 'Color','k', 'LineStyle',':', 'LineWidth',1.5);
yline(.4, 'Color','k', 'LineStyle',':', 'LineWidth',1.5);
yline(.525, 'Color','r','LineStyle',':', 'LineWidth',1.5);
yline(.475, 'Color','r','LineStyle',':', 'LineWidth',1.5);

xlim([0,10]);
legend('Hardware Response', 'Step Input', '20% Error','','5% Error');
legend Location east;
grid on;
hold off;

%% 2.4 D: Matlab Response vs Hardware Response

figure(12);

hold on;
plot(data_time, data_response, 'LineWidth', 1.5);
plot(model_t{1}, model_x{1}, 'LineWidth',1.5)
plot(data_time, data_input, 'LineWidth',1.5);

title('Experimental Responce vs MATLAB Model for K1 = 20 and k3 = 1.5')
xlabel('Time (s)');
ylabel('Position (rad)');

yline(-.6, 'Color','k', 'LineStyle',':', 'LineWidth',1.5);
yline(-.4, 'Color','k', 'LineStyle',':', 'LineWidth',1.5);
yline(-.525, 'Color','r','LineStyle',':', 'LineWidth',1.5);
yline(-.475, 'Color','r','LineStyle',':', 'LineWidth',1.5);

yline(.6, 'Color','k', 'LineStyle',':', 'LineWidth',1.5);
yline(.4, 'Color','k', 'LineStyle',':', 'LineWidth',1.5);
yline(.525, 'Color','r','LineStyle',':', 'LineWidth',1.5);
yline(.475, 'Color','r','LineStyle',':', 'LineWidth',1.5);

xlim([0,10]);
legend('Hardware Response', 'Model Responce','Step Input', '20% Error','','5% Error');
legend Location east;
grid on;
hold off;

%% 3.1 Experimental vs Model for k1 = 25 & k3 = 1.5
filename = 'lab3_harveytest3'; %k1 = 25; k3 = 1.5
final_data = readmatrix(filename);
final_data_time = final_data(:,1)./1000;
final_data_response = final_data(:,2);
final_data_input = final_data(:,6);
final_data_response = final_data_response(final_data_time>=1515);
final_data_input = final_data_input(final_data_time>=1515);
final_data_time = final_data_time(final_data_time>=1515) - 1515;

figure(13)
hold on;
plot(final_data_time, final_data_response, 'LineWidth', 1.5);
plot(model_t{2}, model_x{2},'LineWidth',1.5)
plot(final_data_time, final_data_input, 'LineWidth',1.5);


title('Experimental Responce vs MATLAB Model for K1 = 25 and k3 = 1.5')
xlabel('Time (s)');
ylabel('Position (rad)');

yline(-.6, 'Color','k', 'LineStyle',':', 'LineWidth',1.5);
yline(-.4, 'Color','k', 'LineStyle',':', 'LineWidth',1.5);
yline(-.525, 'Color','r','LineStyle',':', 'LineWidth',1.5);
yline(-.475, 'Color','r','LineStyle',':', 'LineWidth',1.5);

yline(.6, 'Color','k', 'LineStyle',':', 'LineWidth',1.5);
yline(.4, 'Color','k', 'LineStyle',':', 'LineWidth',1.5);
yline(.525, 'Color','r','LineStyle',':', 'LineWidth',1.5);
yline(.475, 'Color','r','LineStyle',':', 'LineWidth',1.5);

xlim([0,10]);
legend('Hardware Response', 'Model Responce','Step Input', '20% Error','','5% Error');
legend Location east;
grid on;
hold off;
