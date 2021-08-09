function outputs = equation_coefficient_thrust(inputs)
%% Overview
% This is a function for calculating thrust coefficient based on thrust,
% propellant mass flow rate and characteristic exhaust velocity.

% Inputs:
%    massflowrate_propellant "mdotp" [kg/s]
%    thrust "F" [N]
%    velocity_characteristicexhaust "cstar" [m/s]

% Outputs:
%    thrustcoefficient "CF" [-]

% Senior Functions:
%    calculation_thrust_TRTEM

%% Test Data
% inputs.massflowrate_propellant = 0.750;
% inputs.thrust = 2000;
% inputs.velocity_characteristicexhaust = 1500;

%% Assign Inputs to Symbols
cstar = inputs.velocity_characteristicexhaust;
mdotp = inputs.massflowrate_propellant;
F     = inputs.thrust;

%% The Equation
CF = F ./ (mdotp.*cstar);

%% Assign Symbols to Outputs
outputs.coefficient_thrust = CF;
end