%% Housekeeping
close all; clear; clc;

%% Setup

setGlobalVariables; 
setTestCaseGlobalVariables; 
% setTargetInital;
global tspan; global VBottle; global Patm; global rhoWater; global R;
global mBottle; global PGageInitial; global VWaterInitial; global TAirInitial;
global vInitial; global thetaInitial; global xInitial; global zInitial;
global mAirInitial; global PTotal; global phaseChange;

%% Verifiaction Test Setup
thrust = 0;

PTotal = Patm + PGageInitial;
VAirInitial = VBottle - VWaterInitial;
mAirInitial = (PTotal * VAirInitial) / (R * TAirInitial);

xVel = vInitial * cosd(thetaInitial);
zVel = vInitial * sind(thetaInitial);
xHeading = cosd(thetaInitial);
yHeading = sind(thetaInitial);

mRocketInitial = mBottle + (rhoWater * VWaterInitial) + mAirInitial;

initialConditions = [xInitial zInitial xVel zVel mAirInitial VAirInitial mRocketInitial]';
initialConditions = double(initialConditions);

[t, conditions] = ode45(@g_fun, tspan, initialConditions);

for i = 1:length(conditions(:,1))
    if conditions(i,2) < 0
        conditions = conditions(1:(i-1),:);
        t = t(1:i-1);
        break
    end
end

thrustVec = createThrustVector(conditions);

fprintf('The max height is %3.3d\n', double(max(conditions(:,2))))
fprintf('The max distance is %3.3d\n', double(max(conditions(:,1))))

trajectoryAndThrustFigure = figure;
subplot(2,1,1)
plot(conditions(:,1), conditions(:,2), 'r')
xlabel('Distance [m]')
ylabel('Height [m]')
title('Rocket Trajectory')

t(phaseChange(1))

t(phaseChange(2)) - t(phaseChange(1))

subplot(2,1,2)
hold on
plot(t, thrustVec, 'r')
xlabel('Time [s]')
ylabel('Thrust [N]')
title('Thrust over Time')
xline(t(phaseChange(1)), 'm');
xline(t(phaseChange(2)), 'b');
xlim([0 0.5])
hold off

saveas(trajectoryAndThrustFigure, 'trajectoryAndThrustFigure.jpg');
