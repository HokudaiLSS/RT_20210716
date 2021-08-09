function outputs = equation_velocity_effectiveexhaust(inputs)
%% Overview
% This is a function for calculating effective exhaust velocity

% Inputs:
%    massflowrate_propellant "mdotp" [kg/s]
%    thrust "F" [N]

% Outputs:
%    velocity_effectiveexhaust "ueff" [m/s]

% Senior Functions
%    calculation_thrust_TRTEM

%% Test Data
% inputs.massflowrate_propellant = 0.750;
% inputs.thrust = 2000;

%% Assign Inputs to Symbols
mdotp = inputs.massflowrate_propellant;
F     = inputs.thrust;

%% The Equation
ueff = F ./ mdotp;

%% Assign Symbols to Outputs
outputs.velocity_effectiveexhaust = ueff;
end