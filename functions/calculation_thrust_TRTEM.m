function outputs = calculation_thrust_TRTEM(inputs)
%% Overview
% This is a function for calculating thrust producted by the flow of
% combustion gas through a converging and diverging nozzle for the TRT-EM
% iteration for fuel mass flow rate.

% Inputs
%    database_CEA "CEADB" [m/s]
%    diameter_exit "de" [m]
%    diameter_throat "dt" [m]
%    efficiency_thrust "eF" [-]
%    massflowrate_fuel "mdotfu" [kg/s]
%    massflowrate_oxidizer "mdotox" [kg/s]
%    pressure_atmosphere "Pa" [Pa]
%    pressure_chamber "Pc" [Pa]

% Outputs
%    area_exit "Ae" [m^2]
%    area_throat "At" [m^2]
%    coefficient_thrust "CF" [-]
%    efficiency_combustion "estar" [-]
%    massflowrate_propellant "mdotp" [kg/s]
%    pressure_exit "Pe" [Pa]
%    pressure_ratio "Pr" [-]
%    specificimpulse "Isp" [s]
%    thrust "F" [N]
%    thrustcoefficient "F" [N]
%    velocity_characteristicexhaust "cstar" [m/s]
%    velocity_exit "ue" [m/s]
%    velocity_effectiveexhaust "ueff" [m/s]

% Subordinate Functions and Structure
%    equation_area_circle
%    equation_coefficient_thrust
%    equation_specificimpulse
%    equation_thrust
%    equation_velocity_characteristicexhaust
%    equation_velocity_effectiveexhaust
%    equation_velocity_exit
%    interpolation_linear
%    iteration_pressure_exit
%        equation_ratio_nozzleexpansion
%        equation_residual

% Senior Functions:
%    iteration_massflowrate_fuel_TRTEM

%% Test Data
% load(strcat(strrep(pwd,'functions','databases'),'\CEA'))
% inputs.database_CEA = CEA.O2HDPE;
% inputs.diameter_exit = 2*23e-3;
% inputs.diameter_throat = 23e-3;
% inputs.efficiency_thrust = 0.95;
% inputs.massflowrate_fuel = 250e-3;
% inputs.massflowrate_oxidizer = 500e-3;
% inputs.pressure_atmosphere = 1e5;
% inputs.pressure_chamber = 3e6;

%% Assign Inputs to Symbols
CEADB  = inputs.database_CEA;
de     = inputs.diameter_exit;
dt     = inputs.diameter_throat;
eF     = inputs.efficiency_thrust;
mdotfu = inputs.massflowrate_fuel;
mdotox = inputs.massflowrate_oxidizer;
Pa     = inputs.pressure_atmosphere;
Pc     = inputs.pressure_chamber;

%% The Computations
% computation 1: +
% output: massflowrate_propellant "mdotp" [kg/s]
mdotp = mdotfu + mdotox;

% computation 2: /
% output: ratio_oxidizertofuelmass "OF" [-]
OF = mdotox./mdotfu;

% computation 3: interpolation_line
% output: velocity_characteristicexhaust theoretical "cstarth" [m/s]
ins_interp_cstarth = CEADB.domain;
ins_interp_cstarth.abscissa = OF;
ins_interp_cstarth.ordinate = 1e-6*Pc;
ins_interp_cstarth.value = CEADB.velocity_characteristicexhaust.value;
outs_interp_cstarth = interpolation_linear(ins_interp_cstarth);
cstarth = outs_interp_cstarth.interpolation_linear;

% computation 4: interpolation_line
% output: ratio_specificheat "y" [-]
ins_interp_y = CEADB.domain;
ins_interp_y.abscissa = OF;
ins_interp_y.ordinate = 1e-6*Pc;
ins_interp_y.value = CEADB.ratio_specificheat.value;
outs_interp_y = interpolation_linear(ins_interp_y);
y = outs_interp_y.interpolation_linear; 

% computation 5: equation_area_circle
% output: area_throat "At" [m^2]
ins_eq_At.diameter = dt;
outs_eq_At = equation_area_circle(ins_eq_At);
At = outs_eq_At.area_circle;

% computation 6: equation_velocity_characteristicexhaust
% output: velocity_characteristicexhaust "cstar" [m/s]
ins_eq_cstar.area_throat = At;
ins_eq_cstar.massflowrate_propellant = mdotp;
ins_eq_cstar.pressure_chamber = Pc;
ous_eq_cstar = equation_velocity_characteristicexhaust(ins_eq_cstar);
cstar = ous_eq_cstar.velocity_characteristicexhaust; 

% computation 7: /
% output: efficiency_combustion "estar" [-]
estar = cstar./cstarth;

% computation 8: equation_area_circle
% output: area_exit "Ae" [m^2]
ins_eq_Ae.diameter = de;
outs_eq_Ae = equation_area_circle(ins_eq_Ae);
Ae = outs_eq_Ae.area_circle;

% computation 9: /
% output: expansion_ratio "e" [-]
e = Ae/At;

% computation 10: iteration_pressure_exit
% output: pressure_exit "Pe" [Pa]
ins_iter_Pe.pressure_chamber = Pc;
ins_iter_Pe.ratio_nozzleexpansion = e;
ins_iter_Pe.ratio_specificheat = y;
outs_iter_Pe = iteration_pressure_exit(ins_iter_Pe);
Pe = outs_iter_Pe.pressure_exit;
    
% computation 11: /
% output: ratio_pressure "Pr" [-]
Pr = Pc./Pe;

% computation 12: equation_velocity_exit
% output: velocity_exit "ue" [m/s]
ins_eq_ue.ratio_pressure = Pr; 
ins_eq_ue.ratio_specificheat = y;
ins_eq_ue.velocity_characteristicexhaust = cstarth;        
outs_eq_ue = equation_velocity_exit(ins_eq_ue);
ue = outs_eq_ue.velocity_exit;

% computation 13: equation_thrust
% output: thrust "F" [N]
ins_eq_F.area_exit = Ae;
ins_eq_F.efficiency_thrust = eF;
ins_eq_F.pressure_atmosphere = Pa;
ins_eq_F.massflowrate_propellant = mdotp;
ins_eq_F.pressure_exit = Pe;
ins_eq_F.velocity_exit = ue;
outs_eq_F = equation_thrust(ins_eq_F);
F = outs_eq_F.thrust;

% computation 14: equation_velocity_effectiveexhaust
% output: velocity_effectiveexhaust "ueff" [m/s]
ins_eq_ueff.massflowrate_propellant = mdotp;
ins_eq_ueff.thrust = F;
outs_eq_ueff = equation_velocity_effectiveexhaust(ins_eq_ueff);
ueff = outs_eq_ueff.velocity_effectiveexhaust;

% computation 15: equation_specificimpulse
% output: specificimpulse "Isp" [s]
ins_eq_Isp.massflowrate_propellant = mdotp;
ins_eq_Isp.thrust = F;
outs_eq_Isp = equation_specificimpulse(ins_eq_Isp);
Isp = outs_eq_Isp.specificimpulse;

% computation 16: equation_coefficient_thrust
% output: thrustcoefficient "CF" [-]
ins_eq_CF.massflowrate_propellant = mdotp;
ins_eq_CF.thrust = F;
ins_eq_CF.velocity_characteristicexhaust = cstar;
outs_eq_CF = equation_coefficient_thrust(ins_eq_CF);
CF = outs_eq_CF.coefficient_thrust;

%% Assign Symbols to Outputs
outputs.area_exit = At;
outputs.area_throat = At;
outputs.coefficient_thrust = CF;
outputs.efficiency_combustion = estar;
outputs.massflowrate_propellant = mdotp;
outputs.pressure_exit = Pe;
outputs.pressure_ratio = Pr;
outputs.ratio_oxidizertofuelmass = OF;
outputs.ratio_specificheat = y;
outputs.specificimpulse = Isp;
outputs.thrust = F;
outputs.velocity_characteristicexhaust = cstarth;
outputs.velocity_effectiveexhaust = ueff;
outputs.velocity_exit = ue;
end