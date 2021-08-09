function outputs = equation_specificimpulse(inputs)
%% Overview
% This is a function for calculating effective exhaust velocity

% Inputs:
%    massflowrate_propellant [kg/s]
%    thrust [N]

% Outputs:
%    specificimpulse [s]

% Senior Functions:
%    calculation_thrust_TRTEM

%% Test Data
% inputs.massflowrate_propellant = 0.750;
% inputs.thrust = 2000;

%% Assign Inputs to Symbols
mdotp = inputs.massflowrate_propellant;
F = inputs.thrust;

%% The Equation
Isp = F ./ (9.807*mdotp);
% ***9.807 is gravitational acceleration on Earth's surface
%% Assign Symbols to Outputs
outputs.specificimpulse = Isp;
end