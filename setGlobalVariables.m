function setGlobalVariables
    global g; global Cd; global rhoAirAtm; global ls; 
    global tspan; global VBottle; global Patm; global gamma; 
    global rhoWater; global dThroat; global dBottle; global aThroat;
    global aBottle; global R; global mBottle; global VWaterInitial; global TAirInitial;
    global xInitial; global zInitial; global VAirInitial;

    g = 9.8;                                % Gravity [m/s^2]
    Cd = 0.8;                               % discharge coefficient
    rhoAirAtm = 0.961;                      % Ambient air density [kg/m^3]
    ls = 0.5;                               % length of test stand [m]
    tspan = 0:0.001:5;                      % time [s]
    VBottle = 0.002;                        % volume of empty bottle [m^3]
    Patm = 12.1 * 6894.75729;               % atmospheric pressure [pa]
    gamma = 1.4;                            % ratio of specific heats for air
    rhoWater = 1000;                        % density of water [kg/m^3]
    dThroat = 0.021;                        % diameter of throat [m]
    dBottle = 0.105;                        % diameter of bottle [m]
    aThroat = pi * (dThroat / 2)^2;         % Area of Throat [m^2]
    aBottle = pi * (dBottle / 2)^2;         % Area of Bottle [m^2]
    R = 287;                                % gas constant of air [J/kgK]
    mBottle = 0.15;                         % mass of empty 2-liter bottle with cone and fins [kg]
    TAirInitial = 300;                      % initial temperature of air [K]
    xInitial = 0.0;                         % initial horizontal distance [m]
    zInitial = 0.25;                        % initial vertical height [m]
    VAirInitial = VBottle - VWaterInitial;
end