


clc; clear; close all;

% SI Units are used
maxVelocity = 310; % mm/s
maxHeadingRate = 45; % deg/s

%Define Transfer Function
% Example System

m = 1;
b = 10;
k = 20;
F = 1;

s = tf('s');
P = 1/(s^2 + 10*s + 20);
step(P)



Kp = 300;
Kd = 10;
Ki = 0;

C = pid(Kp, 0, Kd);
T = feedback(C*P, 1)

t = 0:0.01:2;
step(T,t)

