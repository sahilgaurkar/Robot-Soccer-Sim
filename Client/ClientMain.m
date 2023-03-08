%% Client Parameters
shootDistThres = 10; % Threshold distance from the goal to kick ball [m]

%% Initialize Robots
ball = Ball(1,1);
team1{1} = Robot('Home','h1','Attacker');
team1{2} = Robot('Home','h2','Defender');
team1{3} = Robot('Home','h3','Supporter');
team1{4} = Robot('Home','h4','Goalkeeper');

team2{1} = Robot('Away','a1','Attacker');
team2{2} = Robot('Away','a2','Defender');
team2{3} = Robot('Away','a3','supporter');
team2{4} = Robot('Away','a4','Goalkeeper');

%% FOR TESTING CODE
a = [[1,1]; [2,2]; [3,3]];
b = [[0,0]; [1,1]; [2,2]];
% dist = [];
for idx=1:1:3
dist(idx) = distToGoal(b(idx,:), a(idx,:));
end
dist