%% Proportional Navigation Simulation
%% Define initial conditions
% Pursuer
% xp, yp are the coordinates of the pursuer.
% psip is the yaw angle of the pursuer.
% Vp is the speed of the pursuer.
xp = 0;
yp = 0;
psip = 90;
Vp = 5;
% Evader
% xe, ye are the coordinates of the evader.
% psip is the yaw angle of the evader.
% Ve is the speed of the evader.
xe = 100;
ye = 50;
psie = 100;
Ve = 2;
% Simulation Parameters
d2r = pi / 180.0;
dt = 0.01;
% Proportional Navigation initialisation
N = 3.5;
% Initialise containers for storing trajectory data
xpv = xp;
ypv = yp;
xev = xe;
yev = ye;
Vcc = 0;
Ncc = 0;
% Set the loop termination boolean to false
terminate = false;
t = 0;
while(~terminate)		    % while terminate == false, continue.
    % Calculate the current range
	R = sqrt((xe-xp)^2 + (ye-yp)^2);
    if(t==0)
        R0 = R;
    end
    t = t+dt;
	% Check the termination condition
    if(R < 10 || t > 10)	    % Close to the evader?
		if(Rd > 0)		    % Flown past the evader?
			terminate = true;
		end
    end
	% Calculate the pursuer and evader velocities in world coordinates
    % Use xpd, ypd, xed, yed as variable names.
	% xpd, ypd are the velocities of the pursuer on the x and y axes.
    % xed, yed are the velocities of the evader on the x and y axes.
    
    % ------ INSERT YOUR CODE HERE ------
    
    xpd = Vp * cos(psip * d2r);
    ypd = Vp * sin(psip * d2r);
    
    xed = Ve * cos(psie * d2r);
    yed = Ve * sin(psie * d2r);
    
    
    M1 = [xpd,ypd,xed,yed];
	% Now calculate the closing velocity (Vc).
    % Use Rd, Vc as variable names. where, Rd is the derivative of R.
	
    % ------ INSERT YOUR CODE HERE ------
    
    Rd = ((xe-xp) * (xed-xpd) + (ye-yp) * (yed-ypd)) / R;
    Vc = -Rd;
    
	% To calculate lambda, switch to pursuer axes. First, calculate the
	% coordinate transformation matrix from world to pursuer axes. This
	% is a rotation around psip.
    % we can use a coordinate transformation matrix Cwp to move from world to pursuer axes.
    % Now calculate the matrix Cwp.
	    
    % ------ INSERT YOUR CODE HERE ------
    Cwp = [cos(psip * d2r), sin(psip * d2r); -sin(psip * d2r), cos(psip * d2r)];
    
	% Next, calculate the relative position and velocities in World coordinates
        % Use the variable names xr and xdr for the position & velocity vectors.
        % xr is the relative vector of the pursuer and evader
	xr = [xe-xp;ye-yp]; 
	xrd = [xed-xpd;yed-ypd];
	% Now convert both to Pursuer axes
    % Use xrp, xrdp as variable names.
	xrp = Cwp * xr;
	xrdp = Cwp * xrd;	
	% We now have sufficient information to calculate the sightline angle lam and its derivative, lamd
	% Use lam, lamd as variable names.
    % If the tangent function is to be used, please use the matlab function 'atan2' rather than 'atan'.
    
    % ------ INSERT YOUR CODE HERE ------
    
    lam = atan2(xrp(2),xrp(1));
    lamd = (xrdp(2)*xrp(1)-xrdp(1)*xrp(2))/(xrp(1)^2/(cos(lam)^2));
    
	% Now calculate the lateral acceleration
	nc = N*lamd*Vc;
	% With constant velocity, lateral acceleration comes from turn rate.
    % It is held when psipd is small: psipd = sin(psipd);
	psipd = nc/Vp;
	% We can now integrate the equations of motion for both vehicles,
	% Use xp, yp, xe, ye, psip as variable names.
    
    % ------ INSERT YOUR CODE HERE ------
    
    xp = xp + dt * xpd;
    yp = yp + dt * ypd;
    xe = xe + dt * xed;
    ye = ye + dt * yed;
    psip = psip + dt * psipd / d2r;
    
    t=t+dt;
	% and store these values for later inspection
	xpv = [xpv xp]; %#ok<*AGROW>
	ypv = [ypv yp];
	xev = [xev xe];
	yev = [yev ye];
    Vcc = [Vcc Vc];
    Ncc = [Ncc nc];
end
   
M2 = [lam,lamd];
M3 = [xp,yp,xe,ye,psip];
plot(ypv,xpv);
hold on;
plot(yev,xev,'r')
grid('on')
legend('Pursuer','Evader','fontsize',4);
