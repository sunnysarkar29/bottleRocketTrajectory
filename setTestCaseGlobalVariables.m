function setTestCaseGlobalVariables
    global vInitial; global thetaInitial; global CD; global PGageInitial; 
    global VWaterInitial;
    vInitial = 0.0;                         % initial velocity of rocket [m/s]
    thetaInitial = 45;                      % initial angle of rocket
    PGageInitial = 50 * 6894.75729;        % initial gage pressure of air in bottle [pa]
    VWaterInitial = 0.001;                  % initial volume of water inside bottle [m^3]
    CD = 0.5;                               % drag coefficient 
end