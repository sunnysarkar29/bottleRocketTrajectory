function [thrustVec] = createThrustVector(Conditions)
    global Cd;global VBottle; global Patm; global gamma; 
    global aThroat; global R; global PGageInitial; global VWaterInitial;
    global mAirInitial; global phaseChange;
    
    PTotal = Patm + PGageInitial;
    VAirInitial = VBottle - VWaterInitial;
    
    for i = 1:length(Conditions(:,1))
    
        mAir = Conditions(i,5);
        VAir = Conditions(i,6);
    
        if VAir < VBottle 
            % Water thrustVec Phase
            PAirInterior = PTotal * (VAirInitial / VAir) ^ gamma;
            thrustVec(i) = 2 * Cd * aThroat * (PAirInterior - Patm);
            phaseChange(1) = i;
        else
            % All Water is gone
            PEnd = PTotal * (VAirInitial / VBottle) ^ gamma;
            PAir = PEnd * (mAir / mAirInitial) ^ gamma;
            % Test Case: Patm - PAir
            rhoAir = mAir / VBottle;
            TAir = PAir / (rhoAir * R);
            if PAir > Patm
                % Pressurized Air thrustVec(i)
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
                thrustVec(i) = (-1 * mDotAir * ve) + (Pe - Patm) * aThroat;
                phaseChange(2) = i;
                
            else
                % Balistic Phase -> Only gravity acting on rocket
                thrustVec(i) = 0;
            end
        end
    end
end