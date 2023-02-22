clc; clear; close all;
%Define Transfer Function

Kp = 1;
Kd = 1;
Ki = 0;

C = pid(Kp, Ki, Kd);
tf(C)