function outputs = iteration_pressure_exit(inputs)
%% Overview
% This function uses the bisection iterative technique to determine exit
% pressure based on area ratio, chamber pressure and specific heat ratio of
% the moving gas.

% Inputs:
%    pressure_chamber [Pa]
%    ratio_nozzleexpansion [-]
%    ratio_specificheat [-]

% Output:
%    pressure_exit [Pa]

% Subordinate Functions:
%    equation_ratio_nozzleexpansion
%    equation_residual

% Senior Functions:
%    calculation_thrust_TRTEM

%% Test Data
% inputs.pressure_chamber = 3e6;
% inputs.ratio_nozzleexpansion = 5;
% inputs.ratio_specificheat = 1.2;

%% Assign Inputs to Symbols
e = inputs.ratio_nozzleexpansion;
Pc = inputs.pressure_chamber;
y = inputs.ratio_specificheat;

%% The Iteration
% iteration counter
i = 0;
max = 30;

% initial bisection limits
PeL = 0;
PeU = Pc;

% initial residual definition
Psie = 8;

while abs(real(Psie)) > 1e-3 && i < max
    
    % computation 1: +
    % output: counter
    i = i + 1;
    
    % computation 2: mean
    % output: diameter_steinerarbelos
    Pe = (PeU + PeL) / 2;  
    
    % computation 3: /
    % output: ratio_pressure "Pr" [-]
    Pr = Pc/Pe;
    
    % computation 4: equation_ratio_nozzleexpansion
    % output: ratio_nozzleexpansion calculation "ecal" [-]
    ins_eq_e.ratio_pressure = Pr;
    ins_eq_e.ratio_specificheat = y;   
    outs_eq_e = equation_ratio_nozzleexpansion(ins_eq_e);
    ecal = outs_eq_e.ratio_nozzleexpansion;
    
    % computation 5: equation_residual
    % output: residual_nozzleexpansionarea "Psie" [-]
    ins_eq_Psi.numerator = ecal;
    ins_eq_Psi.denominator = e;
    outs_eq_Psi = equation_residual(ins_eq_Psi);
    Psie = outs_eq_Psi.residual;
       
    if Psie > 0
        PeU = Pe;
    else 
        PeL = Pe;
    end
end

%% Assign Symbols to Outputs
outputs.pressure_exit = Pe;
end