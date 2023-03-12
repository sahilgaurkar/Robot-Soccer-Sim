classdef (StrictDefaults) soccerRobot < matlab.System
    % untitled Add summary here
    %
    % NOTE: When renaming the class name untitled, the file name
    % and constructor name must be updated to use the class name.
    %
    % This template includes most, but not all, possible properties, attributes,
    % and methods that you can implement for a System object in Simulink.

%% Properties

    % Public, tunable properties    
    properties
        % Preset
        teamName = 'None'; % 'Home' | 'Away'
        robotName = 'None'; % 'robot_1' to 'robot_n'
        robotRole = 'None'; % 'Attacker' | 'Defender' | 'GoalKeeper'
        
        % Robot Movement
        currentPose = [0, 0, 0]; % [X, Y, Angle]
        destinationPose = [0, 0, 0]; % [X, Y, Angle]
        currentVelocity = 0; % (mm/s)
        accleration = 0; % (mm/s^2) (Negative | Positive values)
        headingRate = 0; % (deg/s) (Negative | Positive values)

        % Command
        kick = 0; % true = 1 | false = 0
        kickPower = 0; % [0 - 100%] of maxKickPower
        
        % Feedback
        isBallKickable = 0; % true | false
    end

    % Public, non-tunable properties
    properties (Nontunable)
        bodyRadius = 10; % (mm)
        weight = 10; % (kg)
        kickableAreaRadius = 10; % (mm)
        maxMoveAccleration = 10; % (mm/s^2)
        maxMoveVelocity = 10;
        maxTurnRate = 10; % (deg/s)
        maxKickPower = 10; % Force (N)

    end

    properties (DiscreteState)

    end

    % Pre-computed constants
    properties (Access = private)

    end

    
%% Methods

    methods
        % Constructor
        function obj = soccerRobot(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj,nargin,varargin{:})
        end
    end

    methods (Access = protected)
        %% Common functions
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
        end

        function updatedRobotState = stepImpl(obj,robot)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
             updatedRobotState = [obj.isBallKickable,];
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end

        %% Backup/restore functions
        function s = saveObjectImpl(obj)
            % Set properties in structure s to values in object obj

            % Set public properties and states
            s = saveObjectImpl@matlab.System(obj);

            % Set private and protected properties
            %s.myproperty = obj.myproperty;
        end

        function loadObjectImpl(obj,s,wasLocked)
            % Set properties in object obj to values in structure s

            % Set private and protected properties
            % obj.myproperty = s.myproperty; 

            % Set public properties and states
            loadObjectImpl@matlab.System(obj,s,wasLocked);
        end

        %% Simulink functions
        function ds = getDiscreteStateImpl(obj)
            % Return structure of properties with DiscreteState attribute
            ds = struct([]);
        end

        function flag = isInputSizeMutableImpl(obj,index)
            % Return false if input size cannot change
            % between calls to the System object
            flag = false;
        end

        function out = getOutputSizeImpl(obj)
            % Return size for each output port
            out = [1 1];

            % Example: inherit size from first input port
            % out = propagatedInputSize(obj,1);
        end

        function icon = getIconImpl(obj)
            % Define icon for System block
            icon = mfilename("class"); % Use class name
            % icon = "My System"; % Example: text icon
            % icon = ["My","System"]; % Example: multi-line text icon
            % icon = matlab.system.display.Icon("myicon.jpg"); % Example: image file icon
        end
    end

    methods (Static, Access = protected)
        %% Simulink customization functions
        function header = getHeaderImpl
            % Define header panel for System block dialog
            header = matlab.system.display.Header(mfilename("class"));
        end


    end

    methods
        function obj = moveTo(obj,destinationPose)
            % moveTo is used to set destinationPose;
            %   Detailed explanation goes here
        
            obj.destinationPose = destinationPose;

        end

        function obj = kickBall(kickState, kickPower)
            % moveTo is used to set destinationPose;
            %   Detailed explanation goes here
        
            obj.kick = kickState;
            obj.kickPower = kickPower;
            
        end
    end
end
