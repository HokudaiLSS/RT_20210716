function outputs = calculation_pressure_chamber_PRTM(inputs)
%% Overview
% This is a function for calculating the chamber pressure for the PRT-M
% iteration for fuel mass flow rate.

% Inputs
%    database_CEA "CEADB" [m/s]
%    diameter_throat "dt" [m]
%    efficiency_combustion "estar" [-]
%    massflowrate_fuel "mdotfu" [kg/s]
%    massflowrate_oxidizer "mdotox" [kg/s]
%    pressure_chamber "Pc" [Pa]

% Outputs
%    massflowrate_propellant "mdotp" [kg/s]
%    pressure_chamber "Pc" [Pa]
%    ratio_oxidizertofuelmass = OF;
%    velocity_characteristicexhaust "cstar" [m/s]

% Subordinate Functions:
%    equation_area_circle
%    equation_pressure_chamber
%    interpolation_linear

% Senior Functions:
%    iteration_massflowrate_fuel_PRTM

%% Test Data
% load(strcat(strrep(pwd,'functions','databases'),'\CEA'))
% inputs.database_CEA = CEA.O2HDPE;
% inputs.diameter_throat = 23e-3;
% inputs.efficiency_combustion = 0.95;
% inputs.massflowrate_fuel = 250e-3;
% inputs.massflowrate_oxidizer = 500e-3;
% inputs.pressure_chamber = 3e6;

%% Assign Inputs to Symbols
CEADB  = inputs.database_CEA;
dt     = inputs.diameter_throat;
estar  = inputs.efficiency_combustion;
mdotfu = inputs.massflowrate_fuel;
mdotox = inputs.massflowrate_oxidizer;
Pc     = inputs.pressure_chamber;

%% The Computations
% computation 1: equation_area_circle
% output: area_throat "At" [m^2]
ins_eq_At.diameter = dt;
outs_eq_At = equation_area_circle(ins_eq_At);
At = outs_eq_At.area_circle;

% computation 2: +
% output: massflowrate_propellant "mdotp" [kg/s]
mdotp = mdotfu + mdotox;

% computation 3: /
% output: ratio_oxidizertofuelmass "OF" [-]
OF = mdotox./mdotfu;

% computation 4: interpolation_linear
% output: velocity_characteristicexhaust theoretical "cstarth" [m/s]
ins_interp_cstarth = CEADB.domain;
ins_interp_cstarth.abscissa = OF;
ins_interp_cstarth.ordinate = 1e-6*Pc;
ins_interp_cstarth.value = CEADB.velocity_characteristicexhaust.value;
outs_interp_cstarth = interpolation_linear(ins_interp_cstarth);
cstarth = outs_interp_cstarth.interpolation_linear;

% computation 5: *
% output: velocity_characteristicexhaust "cstar" [m/s]
cstar = estar.*cstarth;

% computation 6: equation_pressure_chamber
% output: pressure_chamber "Pc" [Pc]
ins_eq_Pc.area_throat = At;
ins_eq_Pc.massflowrate_propellant = mdotp;
ins_eq_Pc.velocity_characteristicexhaust = cstar;
ous_eq_Pc = equation_pressure_chamber(ins_eq_Pc);
Pc = ous_eq_Pc.pressure_chamber; 

%% Assign Symbols to Outputs
outputs.massflowrate_propellant = mdotp;
outputs.pressure_chamber = Pc;
outputs.ratio_oxidizertofuelmass = OF;
outputs.velocity_characteristicexhaust = cstarth;
end