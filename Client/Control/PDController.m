function [outputArg1,outputArg2] = PDController1(inputArg1,inputArg2)
%PDCONTROLLER1 Summary of this function goes here
%   Detailed explanation goes here

clc; clear; close all;
%Define Transfer Function

Kp = 1;
Kd = 1;
Ki = 0;

C = pid(Kp, Ki, Kd);
tf(C)


outputArg1 = inputArg1;
outputArg2 = inputArg2;
end

