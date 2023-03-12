
clc; close all; clear;

bot = Robot('Home', 'Bot_1', 'Attacker');
bot.currentPose = [0, 0, 0];
bot.destinationPose = [1000, -1000, 90];
bot.accleration = 0;
bot.headingRate = 0;
bot.currentVelocity = 0;

bot.maxMoveAccleration = 100;
bot.maxMoveVelocity = 300;
bot.maxTurnRate = 45;


%% Accleration Controller define the PID controller parameters
Kp = 0.0011;  %0.010; % Proportional gain
Ki = 1.3291e-06; % Integral gain
Kd = 0.1998;  %0.3458; % Derivative gain
Tf = 0.4828 ; %0.3400;
Ts = 0.1; % 100 ms Set the sample time for the controller

% Initialize the PID controller
CAccleration = pid(Kp, Ki, Kd, Tf, Ts);


%% Heading Controller Define the PID controller parameters
Kp = 1.7036; % Proportional gain
Ki = 0; % Integral gain
Kd = 0; % Derivative gain
Tf = 0;
Ts = 0.1; % 100 ms Set the sample time for the controller

% Initialize the PID controller
CHeading = pid(Kp, Ki, Kd, Tf, Ts, 'IFormula','Trapezoidal');



% Initialize the robot's motion variables
bot.currentVelocity = 0; % current velocity of the robot
current_angular_velocity = 0; % current angular velocity of the robot (in degrees per second)

% Define the simulation time and time step
sim_time = 100; % 10 seconds
time_step = 0.1; % 10 ms


% Loop through the simulation time
%for t = 1:time_step:sim_time


ErrorHeading = atan2d(bot.destinationPose(2) - bot.currentPose(2), bot.destinationPose(1) - bot.currentPose(1)) - bot.currentPose(3);


while(bot.currentPose ~= bot.destinationPose)

    %% Get Error
    errorHeading = atan2d(bot.destinationPose(2) - bot.currentPose(2), bot.destinationPose(1) - bot.currentPose(1)) - bot.currentPose(3);
    %errorHeading = wrapTo360(errorHeading);
    errorPosition = bot.destinationPose(1:2) - bot.currentPose(1:2);
    errorDistance = pdist2(bot.destinationPose(1:2), bot.currentPose(1:2), 'euclidean');

    if (abs(errorHeading) > 0.0001) && (abs(errorDistance) > 0.0001)
        % Calculate the Heading Rate and Accleration using the PD
        headingRateOutput = step(errorHeading*CHeading, time_step);
        bot.headingRate = headingRateOutput(1);
    else
        if abs(errorDistance) > 0.0001
        bot.headingRate = 0;
        acclerationOutput = step(errorDistance * CAccleration, 60);
        bot.currentVelocity = acclerationOutput(1);
        else
        bot.currentVelocity = 0;
        errorHeading = bot.destinationPose(3) - bot.currentPose(3);
        headingRateOutput = step(errorHeading*CHeading, time_step);
        bot.headingRate = headingRateOutput(1);
        end
    end

    bot;



    %% Update Position based on Accleration and Heading Angle
    bot = doubleIntegrate(bot, time_step);




end


function obj = doubleIntegrate(obj, deltaT)

if obj.headingRate < obj.maxTurnRate
    % Set Heading Rate
    obj.headingRate = obj.headingRate;
else
    % Set Heading Rate
    obj.headingRate = obj.maxTurnRate;
end


%% integrate heading rate to get current Heading
if obj.headingRate < obj.maxTurnRate
    obj.currentPose(3) = obj.currentPose(3) + obj.headingRate * deltaT;
else
    obj.currentPose(3) = obj.currentPose(3) + obj.maxTurnRate * deltaT;
end

%obj.currentVelocity = obj.currentVelocity + obj.accleration * deltaT;


obj.currentPose(1) = obj.currentPose(1) + obj.currentVelocity * cosd(obj.currentPose(3)) * deltaT;
obj.currentPose(2) = obj.currentPose(2) + obj.currentVelocity * sind(obj.currentPose(3)) * deltaT;




accleration = obj.accleration;
velocity = obj.currentVelocity;
position = obj.currentPose(1:2);
headingRate = obj.headingRate;
Heading = obj.currentPose(3);

plot(obj.currentPose(1), obj.currentPose(2), 'ro');
hold on;
plot(obj.destinationPose(1), obj.destinationPose(2), 'bx');
xlabel('X Position');
ylabel('Y Position');
title('Robot Position');
drawnow;


end
