
clc; clear; close all;

bot = Robot('Home', 'Bot_1', 'Attacker');
bot.currentPose = [0, 0, 0];
bot.destinationPose = [5, 5, 45];
bot.accleration = 1;
bot.headingRate = 45;

bot.maxMoveAccleration = 50;
bot.maxMoveVelocity = 5;
bot.maxTurnRate = 45;


% Define the PID controller parameters
Kp = 0.0008; % Proportional gain
Ki = 0; % Integral gain
Kd = 0.302376; % Derivative gain
N = 1.893;

% Initialize the PID controller
pid_controller = pid(Kp, Ki, Kd);

% Set the sample time for the controller
T = 0.01; % 10 ms
pid_controller.Ts = T;

% Initialize the robot's motion variables
bot.currentVelocity = 0; % current velocity of the robot
current_angular_velocity = 0; % current angular velocity of the robot (in degrees per second)

% Define the simulation time and time step
sim_time = 10; % 10 seconds
time_step = 1; % 10 ms


% Loop through the simulation time
for t = 1:time_step:sim_time

    % Calculate the error between the current position/heading and the desired position/heading
    errorDistance = norm(bot.destinationPose(:,1:2) - bot.currentPose(:,1:2));
    errorHeading = bot.destinationPose(3) - bot.currentPose(3);




    % Calculate the desired acceleration and heading rate using the PID controller
    %acceleration = pid_controller(errorDistance);
    


    %% Update Position based on Accleration and Heading Angle
    bot = doubleIntegrate(bot, time_step);
%     plot(bot.currentPose(1), bot.currentPose(2), 'xb')
%     hold on
    

end


function obj = doubleIntegrate(obj, deltaT)

if obj.headingRate < obj.maxTurnRate
    obj.currentPose(3) = obj.currentPose(3) + obj.headingRate * deltaT;
else
    obj.currentPose(3) = obj.currentPose(3) + obj.maxTurnRate * deltaT;
end

if obj.currentVelocity < obj.maxMoveVelocity
    obj.currentVelocity = obj.currentVelocity + obj.accleration * deltaT;
else
    obj.currentVelocity = obj.maxMoveVelocity;
end

obj.currentPose(1) = obj.currentPose(1) + obj.currentVelocity* cosd(obj.currentPose(3)) * deltaT;
obj.currentPose(2) = obj.currentPose(2) + obj.currentVelocity* sind(obj.currentPose(3)) * deltaT;

end
