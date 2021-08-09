function outputs = equation_thrust(inputs)
%% Overview
% This is a function for calculating thrust

% Inputs:
%    area_exit "Ae" [m^2]
%    efficiency_thrust "eF" [-]
%    massflowrate_propellant "mdotp" [kg/s]
%    pressure_atmosphere "Pa" [Pa]
%    pressure_exit "Pe" [Pa]
%    velocity_exit "ue" [m/s]

% Outputs:
%    thrust "F" [N]

% Senior Functions:
%    calculation_thrust_TRTEM

%% Test Data: roughly based on a 2 kN thrust class CAMUI test
% inputs.area_exit = 5 * (pi/4) * (0.023)^2;
% inputs.efficiency_thrust = 0.95;
% inputs.massflowrate_propellant = 0.750;
% inputs.pressure_atmosphere = 1e5;
% inputs.pressure_exit = 1e5;
% inputs.velocity_exit = 2300;

%% Assign Inputs to Symbols
Ae = inputs.area_exit;
eF = inputs.efficiency_thrust;
mdotp = inputs.massflowrate_propellant;
Pa = inputs.pressure_atmosphere;
Pe = inputs.pressure_exit;
ue = inputs.velocity_exit;

%% The Equation
F = eF.*mdotp.* ue + (Pe-Pa).*Ae;

%% Assign Symbols to Outputs
outputs.thrust = F;
end