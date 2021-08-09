function outputs = equation_ratio_nozzleexpansion(inputs)
%% Overview
% The objective of this function is to calculate the expansion ratio of a
% nozzle based on the inlet and exit pressure, and specific heat ratio

% Inputs:
%    ratio_pressure "Pr" [Pa] *** i.e., Pc/Pe
%    ratio_specificheat "y" [-]

% Outputs:
%    ratio_nozzleexpansion "e" [-]

% Senior Functions:
%    iteration_pressure_exit

%% Test Data
% inputs.ratio_pressure = 100;
% inputs.ratio_specificheat = 1.2;

%% Assign Inputs to Symbols
Pr = inputs.ratio_pressure;
y  = inputs.ratio_specificheat;

%% The Equation
e = 1 ./ (((y+1)./2) .^ (1./(y-1)) .* (1./Pr) .^ (1./y) .* ...
    sqrt((y+1)./(y-1)) .* sqrt( 1 - (1./Pr).^((y-1)./y) ));

%% Assign Symbols to Outputs
outputs.ratio_nozzleexpansion = e;
end