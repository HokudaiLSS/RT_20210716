function outputs = equation_velocity_characteristicexhaust(inputs)
%% Overview
% This is a function for calculating characteristic exhaust velocity based
% on chamber pressure, propellant mass flow rate and throat area.

% Inputs:
%    area_throat "At" [m^2]
%    massflowrate_propellant "mdotp" [kg/s]
%    pressure_chamber "Pc" [Pa]

% Outputs:
%    velocity_characteristicexhaust "cstar" [m/s]

% Senior Functions:
%    calculation_thrust_TRTEM

%% Test Data
% inputs.area_throat = (pi/4) * (23e-3)^2;
% inputs.massflowrate_propellant = 750e-3;
% inputs.pressure_chamber = 3e6;

%% Assign Inputs to Symbols
At    = inputs.area_throat;
mdotp = inputs.massflowrate_propellant;
Pc    = inputs.pressure_chamber;

%% The Equation
cstar = Pc .* At ./ mdotp;

%% Assign Symbols to Outputs
outputs.velocity_characteristicexhaust = cstar;
end