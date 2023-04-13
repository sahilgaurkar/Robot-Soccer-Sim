classdef monitor_sub < matlab.System
    % untitled Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties
       
    end

    properties (DiscreteState)

    end

    % Pre-computed constants
    properties (Access = private)

        pitch_length
        pitch_width
        centre_circle_diameter
        border_strip_width

        goal_area_length
        goal_area_width

        penalty_area_length
        penalty_area_width

        goal_width
        goal_depth


        soccerFieldPlot
        leftGoalBottomPoint
        leftGoalTopPoint
        leftPenaltyAreaBottomPoint
        leftPenaltyAreaTopPoint
    end

    methods (Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants        
            obj.pitch_length = 9000;
            obj.pitch_width = 6000;
            obj.centre_circle_diameter = 1500;
            obj.border_strip_width = 1000;
    
            obj.goal_area_length = 1000;
            obj.goal_area_width = 1000;
    
            obj.penalty_area_length = 1000;
            obj.penalty_area_width = 3000;
    
            obj.goal_width = 1000;
            obj.goal_depth = 500;



            obj.leftGoalBottomPoint = obj.border_strip_width + ((obj.pitch_width-obj.goal_width)/2);
            obj.leftGoalTopPoint = obj.border_strip_width + ((obj.pitch_width+obj.goal_width)/2);
            obj.leftPenaltyAreaBottomPoint=obj.border_strip_width+(obj.pitch_width - obj.penalty_area_width )/2;
            obj.leftPenaltyAreaTopPoint = obj.border_strip_width+(obj.pitch_width + obj.penalty_area_width )/2;

            figureTag = "RoboCupSoccerSim";
            if isempty(findobj('type','figure','tag',figureTag))
                figure('Tag',figureTag, 'Position', [450, 200, 900, 600],'Resize','off');
            end
        end

        function stepImpl(obj, robot_coordinates, ball_coordinates, scoreTeam1, scoreTeam2)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            clf;
            plotSoccerField(obj);



            % Create a rectangle for the score board
            rectangle('Position', [-1500, 3330, 3000, 500],  'EdgeColor', 'w', 'LineWidth', 3, 'FaceColor', 'w');
            
            % Plot score board
            a = int8(scoreTeam1);
            b = int8(scoreTeam2);
            
            % Left team score (red)
            redScoreText = sprintf('%d', a);
            text(-1000, 3600, redScoreText, 'FontSize', 16, 'FontWeight', 'bold', 'Color', 'r');
            
            % Right team score (blue)
            blueScoreText = sprintf('%d', b);
            text(750, 3600, blueScoreText, 'FontSize', 16, 'FontWeight', 'bold', 'Color', 'b');
            
            % Center colon (black)
            colonText = ':';
            text(-40, 3600, colonText, 'FontSize', 16, 'FontWeight', 'bold', 'Color', 'k');



%             theta = linspace(0, 2*pi, 360);   
%             robot_radius = 100;
            
            % plot ball
             plot(ball_coordinates(1), ball_coordinates(2), 'o','MarkerSize', 13, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'k');

            for i=1:size(robot_coordinates, 1)
                robot = robot_coordinates(i,:);  
                    robot_x = robot(1);
                    robot_y = robot(2);
                    heading = robot(3);

                    heading_line_length = 350; % L
                
                    heading_line_x = cos((heading*pi)/180) * heading_line_length;
                    heading_line_y = sin((heading*pi)/180) * heading_line_length;
                
                    % Draw circle around current location of robot
                    %plot((robot_rep_x + robot_x), (robot_rep_y + robot_y), 'Color', 'b');

                    plot(robot(1), robot(2), 'o','MarkerSize', 14, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k');
                    % Draw line from center of robot in the direction of the current heading
                    line([robot_x,  robot_x + heading_line_x], [robot_y, robot_y + heading_line_y], 'color', 'k');
            end
            drawnow;
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end

       function plotSoccerField(obj)
            figureTag = "RoboCupSoccerSim";
            if isempty(findobj('type','figure','tag',figureTag))
                figure('Tag',figureTag);
            end
            
            % plot field
            set(gca, 'Color', 'g');
            field_length = (2*obj.border_strip_width) + obj.pitch_length;
            field_width = (2*obj.border_strip_width) + obj.pitch_width; 
            xlim([-field_length/2 field_length/2]);
            ylim([-field_width/2 field_width/2]);
            
            hold on;
            
            % plot centre line
            xline(0, 'LineWidth',5, 'Color','w');
            
%             hold on;

            % plot centre circle
            theta = 0:pi/100:2*pi;
            center_circle_radius = (obj.centre_circle_diameter)/2;
            x = center_circle_radius * cos(theta);
            y = center_circle_radius * sin(theta);
            plot(x, y, 'LineWidth',3, 'Color','w');
            
            hold on;

            % plot vertical playable area of pitch
            plot([-(obj.pitch_length/2) -(obj.pitch_length/2)], ...
                [-(obj.pitch_width/2) (obj.pitch_width/2)], ...
                'LineWidth', 3, 'Color', 'w');
            plot([(obj.pitch_length/2) (obj.pitch_length/2)],...
                [-(obj.pitch_width/2) (obj.pitch_width/2)], ...
                'LineWidth', 3, 'Color', 'w');
            
            % plot horizontal playable area of pitch
            plot([-(obj.pitch_length/2) (obj.pitch_length/2)], ...
                [-(obj.pitch_width/2) -(obj.pitch_width/2)], ...
                'LineWidth', 3, 'Color', 'w');
            plot([-(obj.pitch_length/2) (obj.pitch_length/2)], ...
                [(obj.pitch_width/2) (obj.pitch_width/2)], ...
                'LineWidth', 3, 'Color', 'w');
            
            %plot left goal
            %plot vertical line
            plot([(-(obj.pitch_length/2)-obj.goal_depth) (-(obj.pitch_length/2)-obj.goal_depth)],...
                [-obj.goal_width/2 obj.goal_width/2],'LineWidth',3,'Color','w')
            %plot horizontal line
            plot([(-(obj.pitch_length/2)) (-(obj.pitch_length/2)-obj.goal_depth)],...
                [obj.goal_width/2 obj.goal_width/2],'LineWidth',3,'Color','w')
            plot([(-(obj.pitch_length/2)) (-(obj.pitch_length/2)-obj.goal_depth)],...
                [-obj.goal_width/2 -obj.goal_width/2],'LineWidth',3,'Color','w')

            %plot right goal
            %plot vertical line
            plot([(obj.pitch_length/2 + obj.goal_depth) (obj.pitch_length/2 + obj.goal_depth)],...
                 [-obj.goal_width/2 obj.goal_width/2],'LineWidth',3,'Color','w');
            %plot horizontal line
            plot([(obj.pitch_length/2) (obj.pitch_length/2 + obj.goal_depth)],...
                 [-obj.goal_width/2 -obj.goal_width/2],'LineWidth',3,'Color','w');
            plot([(obj.pitch_length/2) (obj.pitch_length/2 + obj.goal_depth)],...
                 [obj.goal_width/2 obj.goal_width/2],'LineWidth',3,'Color','w');

            %plot left penalty_area
            %plot horizontal line
            plot([-(obj.pitch_length/2)  -(obj.pitch_length/2 - obj.penalty_area_length)],...
                [-obj.penalty_area_width/2 -obj.penalty_area_width/2],'LineWidth',3,'Color','w');
            plot([-(obj.pitch_length/2)  -(obj.pitch_length/2 - obj.penalty_area_length)],...
                [obj.penalty_area_width/2 obj.penalty_area_width/2],'LineWidth',3,'Color','w');
            %plot vertical line
            plot([-(obj.pitch_length/2 - obj.penalty_area_length) -(obj.pitch_length/2 - obj.penalty_area_length)],...
                [-obj.penalty_area_width/2 obj.penalty_area_width/2],'LineWidth',3,'Color','w')

            %plot right penalty_area
            %plot horizontal line
            plot([(obj.pitch_length/2)  (obj.pitch_length/2 - obj.penalty_area_length)],...
                [-obj.penalty_area_width/2 -obj.penalty_area_width/2],'LineWidth',3,'Color','w');
            plot([(obj.pitch_length/2)  (obj.pitch_length/2 - obj.penalty_area_length)],...
                [obj.penalty_area_width/2 obj.penalty_area_width/2],'LineWidth',3,'Color','w');
            %plot vertical line
            plot([(obj.pitch_length/2 - obj.penalty_area_length) (obj.pitch_length/2 - obj.penalty_area_length)],...
                [-obj.penalty_area_width/2 obj.penalty_area_width/2],'LineWidth',3,'Color','w')
        end
    end
end

