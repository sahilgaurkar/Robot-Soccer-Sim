classdef simulation_window < matlab.System
    % untitled Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties
       
        pitch_length
        pitch_width
        centre_circle_diameter
        border_strip_width

        goal_area_length
        goal_area_width

        penalty_area_length
        penalty_area_width

        goal_width

%         goal_depth
%         
%         goal_height
%         
%         
%         penalty_mark_distance

       
        
%         penalty_area_length
%         penalty_area_width
%         
    end

    properties (DiscreteState)

    end

    % Pre-computed constants
    properties (Access = private)
        soccerFieldPlot
        leftGoalBottomPoint
        leftGoalTopPoint
        
    end

    methods (Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants         
            
            obj.leftGoalBottomPoint = obj.border_strip_width + ((obj.pitch_width-obj.goal_width)/2);
            obj.leftGoalTopPoint = obj.border_strip_width + ((obj.pitch_width+obj.goal_width)/2);
            

            figureTag = "RoboCupSoccerSim";
            if isempty(findobj('type','figure','tag',figureTag))
                figure('Tag',figureTag);
            end

        end

        function stepImpl(obj, robot_coordinates, ball_coordinates)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states
            clf;
            plotSoccerField(obj);

            % plot ball position
            plot(ball_coordinates(1),ball_coordinates(2),'o', ...
                'MarkerFaceColor',[.7 .7 .7],'MarkerEdgeColor', 'b');

            % check for goal
            % checkGoal(obj, ball_coordinates);

            % plot robot positions
            if ~isempty(robot_coordinates)
                for i=1:size(robot_coordinates,1)
                    robot = robot_coordinates(i,:);
                    plot(robot(1), robot(2), 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b');
                    hold on;
                end
            end

%             for i=1:length(robot_coordinates)
%                 robot = robot_coordinates(i,:);
%                 plot(robot(1),robot(2),'o','MarkerFaceColor','b','MarkerEdgeColor','b');
%                 hold on;
%             end                         
            drawnow limitrate;
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end

        function plotSoccerField(obj)

            % Create figure
            figureTag = "RoboCupSoccerSim";
            if isempty(findobj('type','figure','tag',figureTag))
                figure('Tag',figureTag);
            end
            
            % plot field
            set(gca, 'Color', 'g');
            field_length = (2*obj.border_strip_width) + obj.pitch_length;
            field_width = (2*obj.border_strip_width) + obj.pitch_width; 
            xlim([0 field_length]);
            ylim([0 field_width]);
            
            hold on;
            
            % plot centre line
            xline(field_length/2, 'LineWidth',5, 'Color','w');
            
            hold on;

            % plot centre circle
            theta = 0:pi/100:2*pi;
            center_circle_radius = (obj.centre_circle_diameter)/2;
            x = center_circle_radius * cos(theta) + (field_length)/2;
            y = center_circle_radius * sin(theta) + (field_width)/2;
            plot(x, y, 'LineWidth',5, 'Color','w');
            
            hold on;

            % plot vertical playable area of pitch
            plot([obj.border_strip_width obj.border_strip_width], ...
                [obj.border_strip_width (obj.border_strip_width)+(obj.pitch_width)], ...
                'LineWidth', 5, 'Color', 'w');
            plot([(obj.border_strip_width + obj.pitch_length) (obj.border_strip_width + obj.pitch_length)],...
                [obj.border_strip_width (obj.border_strip_width)+(obj.pitch_width)], ...
                'LineWidth', 5, 'Color', 'w');
            
            % plot horizontal playable area of pitch
            plot([(obj.border_strip_width) (obj.border_strip_width + obj.pitch_length)], ...
                [(obj.border_strip_width)+(obj.pitch_width) (obj.border_strip_width)+(obj.pitch_width)], ...
                'LineWidth', 5, 'Color', 'w');
            plot([(obj.border_strip_width) (obj.border_strip_width + obj.pitch_length)], ...
                [(obj.border_strip_width) (obj.border_strip_width)], ...
                'LineWidth', 5, 'Color', 'w');
            

        end

        function booleanVal = isGoal(obj, ball_coordinates)
            booleanVal = (ball_coordinates(1) <= obj.border_strip_width && ball_coordinates(2)>obj.leftGoalBottomPoint && ball_coordinates(2) < obj.leftGoalTopPoint);
        end

       

    end
end
