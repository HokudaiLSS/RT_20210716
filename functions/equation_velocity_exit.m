function outputs = equation_velocity_exit(inputs)
%% Overview
% The is a function for calculating the velocity of combustion gas exiting
% a converging-divering nozzle.

% Inputs:
%    ratio_pressure "Pr" [-] *** i.e., Pc/Pe
%    ratio_specificheat "y" [-]
%    velocity_characteristicexhaust "cstar" [m/s]

% Outputs:
%    velocity_exit "ue" [m/s]

% Senior Functions:
% calculation_thrust_TRTEM

%% Test Data
% inputs.ratio_pressure = 100;
% inputs.ratio_specificheat = 1.2;
% inputs.velocity_characteristicexhaust = 1600;

%% Assign Inputs to Symbols
Pr    = inputs.ratio_pressure;
y     = inputs.ratio_specificheat;
cstar = inputs.velocity_characteristicexhaust;

%% The Equation
ue = ...
    cstar .* sqrt((2*y.^2)./(y-1)) .* ...
    sqrt((2./(y+1)).^((y+1)./(y-1))) .* ...
    sqrt((1-(1./Pr).^((y-1)./y)));
 
%% Assign Symbols to Outputs
outputs.velocity_exit = ue;
end