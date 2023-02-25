classdef Robot
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %% All Units are in SI units
        %% Identification
        teamName = 'None'; % 'Home' | 'Away'
        robotName = 'None'; % 'robot_1' to 'robot_n'
        robotRole = 'None'; % 'Attacker' | 'Defender' | 'GoalKeeper'
        %% Properties
        bodyRadius = 0; % (mm)
        weight = 0; % (kg)
        kickableAreaRadius = 0; % (mm)
        maxMoveAccleration = 0; % (mm/s^2)
        maxMoveVelocity = 0;
        maxTurnRate = 0; % (deg/s)
        maxKickPower = 0; % Force (N)
        %% Robot Movement
        currentPose = [0, 0, 0]; % [X, Y, Angle]
        currentVelocity = 0; % (mm/s)
        destinationPose = [0, 0, 0]; % [X, Y, Angle]
        accleration = 0; % (mm/s^2) (Negative | Positive values)
        headingRate = 0; % (deg/s) (Negative | Positive values)
        %% Command
        kick = false; % true | false
        kickPower = 0; % [0 - 100%] of maxKickPower
        %% Feedback
        isBallKickable = false; % true | false
    end
    
    methods
        function obj = Robot(teamName, robotName, robotRole)
            % UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            
            obj.teamName = teamName;
            obj.robotName = robotName;
            obj.robotRole = robotRole;
        end

        function obj = setIdentification(obj, teamName, robotName, robotRole)
            % setIdentification is used to set Identifications Properties
            %   Detailed explanation goes here
            
            obj.teamName = teamName;
            obj.robotName = robotName;
            obj.robotRole = robotRole;
        end
        
        function obj = setProperties(obj,bodyRadius, weight, kickableAreaRadius, maxMoveAccleration, maxTurnRate, maxKickPower)
            % setProperties is used to set Robot Static Properties;
            %   Detailed explanation goes here
            
            obj.bodyRadius = bodyRadius;
            obj.weight = weight;
            obj.kickableAreaRadius = kickableAreaRadius;
            obj.maxMoveAccleration = maxMoveAccleration;
            obj.maxTurnRate = maxTurnRate;
            obj.maxKickPower = maxKickPower;

        end

        function obj = moveTo(obj,destinationPose)
            % moveTo is used to set destinationPose;
            %   Detailed explanation goes here
        
            obj.destinationPose = destinationPose;

        end

        function obj = kickBall(obj, kickPower)
            % moveTo is used to set destinationPose;
            %   Detailed explanation goes here
        
            obj.kick = true;
            obj.kickPower = kickPower;
            
        end
    end
end

