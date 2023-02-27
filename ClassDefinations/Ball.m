classdef Ball
    %BALL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %% Property
        mass = 0;
        fricCoeff = 0;
        radius = 0;
        %% Command
        appliedForce = 0;
        heading = 0;
        %% Status
        currentAccleration = 0;
        currentSpeed = 0;
        currentPose = [0, 0, 0];
        lastCommandBy = {'None', 'None'}; %teamName, robotName
        isFoul = false;

        %% Game State
        gameState = 0;
        % 0 = pause/stop
        % 1 = normal
        % 2 = freeKick
        % 3 = cornerKick
        % 4 = goalieFreeKick
        % 5 = kickIn.
        % 6 = penalty

    end
    
    methods
        function obj = Ball(mass, radius)
            %   BALL Construct an instance of this class
            %   Detailed explanation goes here
            obj.mass = mass;
            obj.radius = radius;
        end
        
        function obj = setCommand(obj, appliedForce, heading)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.appliedForce = appliedForce;
            obj.heading = heading;
        end

        function outputArg1 = getCurrentPose(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg1 = obj.currentPose;
        end
    end
end

