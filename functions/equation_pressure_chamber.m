function outputs = equation_pressure_chamber(inputs)
%% Overview
%   The experimental calculation of chamber pressure based on the c*
%   equation

% Inputs:
%    area_throat "At" [m^2]
%    massflowrate_propellant "mdotp" [kg/s] 
%    velocity_characteristicexhaust "cstar" [m/s]

% Output
%    pressure_chamber "Pc"[Pa]

% Senior Functions:
%    calculation_pressure_chamber_PRTM

%% Test Data: 2 kN thrust class motor operating around 3 MPa
% inputs.area_throat = (pi/4) * 0.023^2;
% inputs.massflowrate_propellant = 0.750;
% inputs.velocity_characteristicexhaust = 1600;

%% Assign Inputs to Symbols
At    = inputs.area_throat;
cstar = inputs.velocity_characteristicexhaust;
mdotp = inputs.massflowrate_propellant;

%% The Equation
Pc = cstar .* mdotp ./ At;

%% Assign Symbols to Outputs
outputs.pressure_chamber = Pc;
end