clear
close all
clc

z_1 = @(t) -1*sqrt((25^2)-((t-25)^2)) + 125;
y_1 = @(t) t;
x_1 = @(t) 0;

x_2 = @(t) 0;
y_2 = @(t) 25 + 11*cos(t);
z_2 = @(t) 111 + 11*sin(t);

x_3 = @(t) 0;
y_3 = @(t) t;
z_3 = @(t) 100;

x_4 = @(t) 0;
y_4 = @(t) 50 + (20/(2-sqrt(2)))*cos(t);
z_4 = @(t) (100 + (20/(2-sqrt(2)))) + (20/(2-sqrt(2)))*sin(t);

v0 = sqrt(2*9.81*(125-110));
offset = (((20/(2-sqrt(2)))*(sqrt(2)/2))+50);

x_5 = @(t) 0;
y_5 = @(t) t;
z_5 = @(t) (tand(45)*(t-offset)) - (9.81*((t-offset)^2))/(2*v0^2*cosd(45)^2) + 110;

offset2 = 190 + ((20/(2-sqrt(2)))*(sqrt(2)/2));

x_6 = @(t) 0;
y_6 = @(t) t;
z_6 = @(t) -t + offset2;

offset3 = 170 + ((20/(2-sqrt(2)))*(sqrt(2)/2)) + ((40/(2-sqrt(2)))*(sqrt(2)/2));

x_7 = @(t) 0;
y_7 = @(t) offset3 + (40/(2-sqrt(2)))*cos(t);
z_7 = @(t) (40/(2-sqrt(2))) + (40/(2-sqrt(2)))*sin(t);

v_bottom = sqrt(2*9.81*(125));
r_bank = ((v_bottom^2)/9.81)*cotd(60);

x_8 = @(t) r_bank + r_bank*cos(t);
y_8 = @(t) offset3 + r_bank*sin(t);
z_8 = @(t) 0;


x_9 = @(t) t;
y_9 = @(t) offset3 + r_bank;
z_9 = @(t) 0;


figure;
fplot3(x_1,y_1,z_1,[0 25])
hold on
fplot3(x_2,y_2,z_2,[0 2*pi])
fplot3(x_3,y_3,z_3,[25 50])
fplot3(x_4,y_4,z_4,[3*pi/2 7*pi/4])
fplot3(x_5,y_5,z_5,[offset offset+30])
fplot3(x_6,y_6,z_6,[offset2-110 offset2-20])
fplot3(x_7,y_7,z_7,[5*pi/4 3*pi/2])
fplot3(x_8,y_8,z_8,[pi/2 pi])
fplot3(x_9,y_9,z_9,[r_bank r_bank + 50])
xlabel('x')
ylabel('y')
zlabel('z')
axis([0 400 0 400 0 130])





