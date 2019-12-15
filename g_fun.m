function [results] = g_fun(t,Initial)
    %Project2Equations defines the differential equations for the flight of
    % the bottle rocket
    %% Define the global variables
    global g; global Cd; global rhoAirAtm; global ls; 
    global VBottle; global Patm; global gamma; 
    global rhoWater; global aThroat;
    global aBottle; global R;
    global thetaInitial; global xInitial; global zInitial;
    global mAirInitial; global CD; global PTotal;
    global VAirInitial;
    
    %% Read in initial values
    xPos = Initial(1);
    zPos = Initial(2);
    xVel = Initial(3);
    zVel = Initial(4);
    mAir = Initial(5);
    VAir = Initial(6);
    mRocket = Initial(7);

    %% Quick Maths that help set up ODE
    xHeading = cosd(thetaInitial);
    zHeading = sind(thetaInitial);
    
    vMag = sqrt(xVel ^ 2 + zVel ^ 2);
    
    Drag = (rhoAirAtm / 2) * (vMag ^ 2) * CD * aBottle;

    %% Bottle Rocket Thermodynamics
    
    if VAir < VBottle 
        % Water Thrust Phase
        PAirInterior = PTotal * (VAirInitial / VAir) ^ gamma;
        Thrust = 2 * Cd * aThroat * (PAirInterior - Patm);
        VDotAir = Cd * aThroat * sqrt((2 / rhoWater) * (PTotal * ((VAirInitial / VAir) ^ gamma) - Patm));
        mDotRocket = - Cd * aThroat * sqrt(2 * rhoWater * (PAirInterior - Patm));
        mDotAir = 0;
    
    else
        % All Water is gone
        PEnd = PTotal * (VAirInitial / VBottle) ^ gamma;
        PAir = PEnd * (mAir / mAirInitial) ^ gamma;
        % Test Case: Patm - PAir
        rhoAir = mAir / VBottle;
        TAir = PAir / (rhoAir * R);
        if PAir > Patm
            % Pressurized Air Thrust
            PCr = PAir * (2 / (gamma + 1)) ^ (gamma / (gamma - 1));
                
                if PCr > Patm 
                    % If p* > pa, the flow is choked (exit Mach number Me = 1)
                    Pe = PCr;
                    Te = (2 / (gamma + 1)) * TAir;
                    rhoExit = Pe / (R * Te);
                    ve = sqrt(gamma * R * Te);

                else
                    % If p* < pa, the flow is not choked 
                    Pe = Patm;
                    Me = sqrt((2 / (gamma - 1)) * (((PAir / Patm) ^ ((gamma - 1) / gamma)) - 1));
                    Te = TAir / (1 + ((gamma - 1) / 2) * Me ^ 2);
                    rhoExit = Pe / (R * Te);
                    ve = Me * sqrt(gamma * R * Te);
                    
                end

            mDotAir = -1* (Cd * rhoExit * aThroat * ve);
            Thrust = (-1 * mDotAir * ve) + (Pe - Patm) * aThroat;
            mDotRocket = mDotAir;
            VDotAir = 0; % -> No Air Flowing out

        else
            % Balistic Phase -> Only gravity acting on rocket
            Thrust = 0;
            VDotAir = 0;
            mDotRocket = 0;
            mDotAir = 0;
        end
    end
    
    %% Compute/Setup Integration
    xDot = xVel;
    zDot = zVel;
        
    if sqrt((xPos - xInitial) ^ 2 + (zPos - zInitial) ^ 2) > ls
        % If Rocket is still on stand, heading does not change
        xHeading = xDot / vMag;
        zHeading = zDot / vMag;
    end
    
    xVelDot = (Thrust - Drag) * (xHeading / mRocket); 
    zVelDot = (Thrust - Drag) * (zHeading / mRocket) - g; % -> DON'T FORGET
    %GRAVITY, WILL CAUSE MANY MORE HOURS OF WORK THAN NEEDED
    
    results = [xDot zDot xVelDot zVelDot mDotAir VDotAir mDotRocket]';
end