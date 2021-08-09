function outputs = equation_area_circle(inputs)
%% Overview
% This is the equation for calculating the area of a circle using the
% diameter of the circle as the input parameter.

% Inputs
%    diameter "D" [m]

% Outputs
%    area_circle "A" [m^2]

% Senior Functions:
%    calculation_pressure_chamber_PRTM
%    calculation_thrust_TRTEM

%% Test Data
% inputs.diameter = 2;

%% Assign Inputs to Symbols
D = inputs.diameter;

%% The Equation
A = (pi/4) .* D.^2;

%% Assign Symbols to Outputs
outputs.area_circle = A;
end