function outputs = equation_residual(inputs)
%% Overview
% This is a function to calculate (nondimensional) residual between two
% values.

% Inputs:
%     denominator "B" [var]
%     numerator "A" [var]

% Outputs:
%     residual "Psi" [-]

% Senior Functions:
%    iteration_efficiency_combustion_PRTM
%    iteration_efficiency_thrust_TRTEM
%    iteration_massflowrate_fuel_PRTM
%    iteration_massflowrate_fuel_TRTEM
%    iteration_pressure_exit

%% Test Data: a case with 25% residual
% inputs.numerator = 0.75;
% inputs.denominator = 1;

%% Assign Inputs to Symbols
A = inputs.numerator;
B = inputs.denominator;

%% The Equation
Psi = 1 - A./B;

%% Assign Symbols to Outputs
outputs.residual = Psi;
end