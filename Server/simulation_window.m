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
        goal_depth
%         
%         goal_height
%         
%         
%         penalty_mark_distance

       
    end

    properties (DiscreteState)

    end

    % Pre-computed constants
    properties (Access = private)
        soccerFieldPlot
        leftGoalBottomPoint
        leftGoalTopPoint
        leftPenaltyAreaBottomPoint
        leftPenaltyAreaTopPoint
        
    end

    methods (Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants         
            
            obj.leftGoalBottomPoint = obj.border_strip_width + ((obj.pitch_width-obj.goal_width)/2);
            obj.leftGoalTopPoint = obj.border_strip_width + ((obj.pitch_width+obj.goal_width)/2);
            obj.leftPenaltyAreaBottomPoint=obj.border_strip_width+(obj.pitch_width - obj.penalty_area_width )/2;
            obj.leftPenaltyAreaTopPoint = obj.border_strip_width+(obj.pitch_width + obj.penalty_area_width )/2;

            figureTag = "RoboCupSoccerSim";
            if isempty(findobj('type','figure','tag',figureTag))
                figure('Tag',figureTag);
            end

        end

        function stepImpl(obj, robot_coordinates, ball_coordinates, scoreTeam1, scoreTeam2)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states
            clf;
            plotSoccerField(obj);

            %plot score board
            kick = int8(scoreTeam1);
            b = int8(scoreTeam2);
            formatSpec='Score: %d : %d';
            c=sprintf(formatSpec,kick,b);
            txt = c;
            text(5200,7500,txt);

            % plot ball position
            %plot(ball_coordinates(1),ball_coordinates(2),'o', ...
            %    'MarkerFaceColor',[.7 .7 .7],'Color','k');
            
            radie = 100;
            plotpos = [ball_coordinates(1)-radie ball_coordinates(2)-radie 2*radie 2*radie];
            rectangle('Position',plotpos,'Curvature',[1 1],'FaceColor','white');
            hold on
            theta = 0:2*pi/5:2*pi;
            r = radie*ones(1,6);
            [X,Y] = pol2cart(theta,r/2);
            plot(X+ball_coordinates(1),Y+ball_coordinates(2),'Color','k','LineWidth',1)
            hold on
            [X1,Y1] = pol2cart(theta,r);
            line([X;X1]+ball_coordinates(1),[Y;Y1]+ball_coordinates(2),'Color','k','LineWidth',1)


            % check for goal
            % checkGoal(obj, ball_coordinates);

            % plot robot positions
                      % plot robot positions
            radie = 100;
            if ~isempty(robot_coordinates)
                for i=1:size(robot_coordinates,1)
                    robot = robot_coordinates(i,:);
                    plot(robot(1), robot(2), 'o','MarkerSize', 20, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'b');
        
                    if i <=4
                        plotpos = [robot(1)-radie robot(2)-radie radie 2*radie];
                        rectangle('Position',plotpos,'Curvature',[0.8 0.8],'FaceColor','#008C45',...
                            'EdgeColor','none');
                        plotpos = [robot(1) robot(2)-radie radie 2*radie];
                        rectangle('Position',plotpos,'Curvature',[0.8 0.8],'FaceColor','#CD212A',...
                            'EdgeColor','none');
                        plotpos = [robot(1)-2*radie/6 robot(2)-radie 2*radie/3 2*radie];
                        rectangle('Position',plotpos,'FaceColor','#F4F5F0',...
                            'EdgeColor','none');
                        hold on;                        
                    else
                        plotpos = [robot(1)-radie robot(2)-radie 2*radie 2*radie];                     
                        rectangle('Position',plotpos,'Curvature',[0.75 0.75],'FaceColor','#004B87',...
                             'EdgeColor','none');
                        plotpos = [robot(1)-radie/4 robot(2)-radie radie/2 2*radie];
                        rectangle('Position',plotpos,'FaceColor','#FFCD00',...
                            'EdgeColor','none');
                        plotpos = [robot(1)-radie robot(2)-radie/4 2*radie radie/2];
                        rectangle('Position',plotpos,'FaceColor','#FFCD00',...
                             'EdgeColor','none');
                        hold on
                    end
                end
            end                   
            drawnow ;
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
            plot(x, y, 'LineWidth',3, 'Color','w');
            
            hold on;

            % plot vertical playable area of pitch
            plot([obj.border_strip_width obj.border_strip_width], ...
                [obj.border_strip_width (obj.border_strip_width)+(obj.pitch_width)], ...
                'LineWidth', 3, 'Color', 'w');
            plot([(obj.border_strip_width + obj.pitch_length) (obj.border_strip_width + obj.pitch_length)],...
                [obj.border_strip_width (obj.border_strip_width)+(obj.pitch_width)], ...
                'LineWidth', 3, 'Color', 'w');
            
            % plot horizontal playable area of pitch
            plot([(obj.border_strip_width) (obj.border_strip_width + obj.pitch_length)], ...
                [(obj.border_strip_width)+(obj.pitch_width) (obj.border_strip_width)+(obj.pitch_width)], ...
                'LineWidth', 3, 'Color', 'w');
            plot([(obj.border_strip_width) (obj.border_strip_width + obj.pitch_length)], ...
                [(obj.border_strip_width) (obj.border_strip_width)], ...
                'LineWidth', 3, 'Color', 'w');
            
            %plot left goal
            %plot vertical line
            plot([(obj.border_strip_width-obj.goal_depth) (obj.border_strip_width-obj.goal_depth)],...
                [obj.leftGoalBottomPoint obj.leftGoalTopPoint],'LineWidth',3,'Color','w')
            %plot horizontal line
            plot([(obj.border_strip_width-obj.goal_depth) obj.border_strip_width],...
                [obj.leftGoalBottomPoint obj.leftGoalBottomPoint],'LineWidth',3,'Color','w')
            plot([(obj.border_strip_width-obj.goal_depth) obj.border_strip_width],...
                [obj.leftGoalTopPoint obj.leftGoalTopPoint],'LineWidth',3,'Color','w')

            %plot right goal
            %plot vertical line
            plot([(obj.border_strip_width+obj.pitch_length+obj.goal_depth) (obj.border_strip_width+obj.pitch_length+obj.goal_depth)],...
                 [obj.leftGoalBottomPoint obj.leftGoalTopPoint],'LineWidth',3,'Color','w');
            %plot horizontal line
            plot([(obj.border_strip_width+obj.pitch_length) (obj.border_strip_width+obj.pitch_length+obj.goal_depth)],...
                 [obj.leftGoalBottomPoint obj.leftGoalBottomPoint],'LineWidth',3,'Color','w');
            plot([(obj.border_strip_width+obj.pitch_length) (obj.border_strip_width+obj.pitch_length+obj.goal_depth)],...
                 [obj.leftGoalTopPoint obj.leftGoalTopPoint],'LineWidth',3,'Color','w');

            %plot left penalty_area
            %plot horizontal line
            plot([obj.border_strip_width (obj.border_strip_width + obj.penalty_area_length)],...
                [obj.leftPenaltyAreaBottomPoint obj.leftPenaltyAreaBottomPoint],'LineWidth',3,'Color','w');
            plot([obj.border_strip_width (obj.border_strip_width + obj.penalty_area_length)],...
                [obj.leftPenaltyAreaTopPoint obj.leftPenaltyAreaTopPoint],'LineWidth',3,'Color','w');
            %plot vertical line
            plot([(obj.border_strip_width + obj.penalty_area_length) (obj.border_strip_width + obj.penalty_area_length)],...
                [obj.leftPenaltyAreaBottomPoint obj.leftPenaltyAreaTopPoint],'LineWidth',3,'Color','w')

            %plot right penalty_area
            %plot horizontal line
            plot([(obj.border_strip_width+obj.pitch_length) (obj.border_strip_width+obj.pitch_length - obj.penalty_area_length)],...
                [obj.leftPenaltyAreaBottomPoint obj.leftPenaltyAreaBottomPoint],'LineWidth',3,'Color','w');
            plot([(obj.border_strip_width+obj.pitch_length) (obj.border_strip_width+obj.pitch_length - obj.penalty_area_length)],...
                [obj.leftPenaltyAreaTopPoint obj.leftPenaltyAreaTopPoint],'LineWidth',3,'Color','w');
            %plot vertical line
            plot([(obj.border_strip_width+obj.pitch_length - obj.penalty_area_length) (obj.border_strip_width+obj.pitch_length - obj.penalty_area_length)],...
                [obj.leftPenaltyAreaBottomPoint obj.leftPenaltyAreaTopPoint],'LineWidth',3,'Color','w')
        end

        %function booleanVal = isGoal(obj, ball_coordinates)
        %    booleanVal = (ball_coordinates(1) <= obj.border_strip_width && ball_coordinates(2)>obj.leftGoalBottomPoint && ball_coordinates(2) < obj.leftGoalTopPoint);
        %end

       

    end
end
