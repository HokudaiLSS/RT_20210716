function outputs = iteration_massflowrate_fuel_TRTEM(inputs)
%% Overview
% The objectve of this is to solve for the fuel mass flow rate and
% combustion efficiency for the TRT-EM iteration for thrust efficiency. The
% Newton-Raphson method is programmed as the default iterative technique,
% but in the case where divergence occurs, iterations are completed using
% the bi-section iterative technique. In the case where multiple solutions
% are possible for OF, a linear patch of the c* curve is available for use.

% Inputs:
%    database_CEA "CEADB" [m/s]
%    diameter_exit "de" [m]
%    diameter_throat "dt" [m]
%    efficiency_thrust "eF" [-]
%    massflowrate_oxidizer "mdotox" [kg/s]
%    pressure_atmosphere "Pa" [Pa]
%    pressure_chamber "Pc" [Pa]
%    thrust "F" [N]

% Outputs:
%    counter_bisectioniteration "i" [#]
%    efficiency_combustion "estar" [-]
%    massflowrate_fuel "mdotfu" [kg/s]
%    massflowrate_propellant "mdotp" [kg/s]
%    pressure_exit "Pe" [Pa]
%    ratio_oxidizertofuelmass "OF" [-]
%    residual_bisectioniteration "Psi" [-]
%    specificimpulse "Isp" [s]
%    value_bisectioniteration "mdotfutracker" [kg/s]
%    velocity_characteristicexhaust "cstar" [m/s]
%    velocity_effectiveexhaust "ueff" [m/s]
%    velocity_exit "ue" [m/s]

% Subordinate Functions and Structure:
%    calculation_thrust_TRTEM
%        equation_area_circle
%        equation_coefficient_thrust
%        equation_specificimpulse
%        equation_thrust
%        equation_velocity_characteristicexhaust
%        equation_velocity_effectiveexhaust
%        equation_velocity_exit
%        interpolation_line
%        iteration_pressure_exit
%            equation_ratio_nozzleexpansion
%            equation_residual
%    equation_residual

% Senior Functions
%    iteration_efficiency_thrust_TRTEM

%% Test Data: a case where OF is outside the multiple solutions region
% load(strcat(strrep(pwd,'functions','databases'),'\CEA'))
% inputs.database_CEA = CEA.O2HDPE;
% inputs.diameter_exit = 2*23e-3;
% inputs.diameter_throat = 23e-3;
% inputs.efficiency_thrust = 0.95;
% inputs.massflowrate_fuel = 200e-3;
% inputs.massflowrate_oxidizer = 500e-3;
% inputs.pressure_atmosphere = 1e5;
% inputs.pressure_chamber = 3e6;
% inputs.switch_multiplesolutions = 'yes';
% inputs.thrust = 1800;

%% Assign Inputs to Variables
CEADB  = inputs.database_CEA;
de     = inputs.diameter_exit;
dt     = inputs.diameter_throat;
eF     = inputs.efficiency_thrust;
F      = inputs.thrust;
mdotox = inputs.massflowrate_oxidizer;
Pa     = inputs.pressure_atmosphere;
Pc     = inputs.pressure_chamber;

%% The Iteration
% iteration counters [#]
i = 0;
max = 100;

% initial residual definitions
Psi = 8;

% bisection limits "PcL" & "PcU" [Pa]
mdotfuL = mdotox/300;
mdotfuU = 300*mdotox;

while abs(Psi) > 1e-3 && i <= max

    % computation 1: +
    % output: Bisection iteration counter "iB" [#]   
    i = i + 1;

    % computation 2: *
    % output: massflowrate_fuel "mdotfu" [-]
    mdotfu = (mdotfuU + mdotfuL) / 2;
    
    % computation 3: calculation_thrust_TRTEM
    % output: thrust calculation "Fcal" [N]
    ins_cal_F.database_CEA = CEADB;
    ins_cal_F.diameter_exit = de;
    ins_cal_F.diameter_throat = dt;
    ins_cal_F.efficiency_thrust = eF;
    ins_cal_F.massflowrate_fuel = mdotfu;
    ins_cal_F.massflowrate_oxidizer = mdotox;
    ins_cal_F.pressure_atmosphere = Pa;
    ins_cal_F.pressure_chamber = Pc;
    ous_cal_F = calculation_thrust_TRTEM(ins_cal_F);
    Fcal = ous_cal_F.thrust;

    % computation 4: equation_residual
    % output: residual_thrust "PsiF" [-]
    ins_eq_Psi.denominator = F;
    ins_eq_Psi.numerator = Fcal;
    outs_eq_Psi = equation_residual(ins_eq_Psi);
    PsiF = outs_eq_Psi.residual;  

    % update the Bisection residual term "Psi" [-]
    Psi = PsiF; 

    % update the Bisection trackers
    mdotfutracker(i,1) = mdotfu;
    Psitracker(i,1) = Psi;

    if Psi < 0
        mdotfuU = mdotfu;
    else
        mdotfuL = mdotfu;
    end        
end    

%% Conduct Follow-on Calculations
% computation 5: calculation_thrust_TRTEM
% output: coefficient_thrust "CF" [-]
% output: efficiency_combustion "estar" [-]
% output: massflowrate_propellant "mdotp" [kg/s]
% output: pressure_exit "Pe" [Pa]
% output: ratio_oxidizertofuelmass "OF" [-]
% output: specificimpulse "Isp" [s]
% output: velocity_characteristicexhaust "cstar" [m/s]
% output: velocity_effectiveexhaust "ueff" [m/s]
% output: velocity_exit "ue" [m/s]
ins_cal_F.massflowrate_fuel = mdotfu;
ous_cal_F = calculation_thrust_TRTEM(ins_cal_F);
Ae = ous_cal_F.area_exit;
At = ous_cal_F.area_throat;
CF = ous_cal_F.coefficient_thrust;
cstar = ous_cal_F.velocity_characteristicexhaust;
estar = ous_cal_F.efficiency_combustion;
Isp = ous_cal_F.specificimpulse;
mdotp = ous_cal_F.massflowrate_propellant;
OF = ous_cal_F.ratio_oxidizertofuelmass;
Pe = ous_cal_F.pressure_exit;
ue = ous_cal_F.velocity_exit;
ueff = ous_cal_F.velocity_effectiveexhaust;

%% Assign Variables to Outputs
outputs.area_exit = Ae;
outputs.area_throat = At;
outputs.coefficient_thrust = CF;
outputs.counter_bisectioniteration = i;
outputs.efficiency_combustion = estar;
outputs.massflowrate_fuel = mdotfu;
outputs.massflowrate_propellant = mdotp;
outputs.pressure_exit = Pe;
outputs.ratio_oxidizertofuelmass = OF;
outputs.residual_bisectioniteration = Psitracker;
outputs.specificimpulse = Isp;
outputs.value_bisectioniteration = mdotfutracker;
outputs.velocity_characteristicexhaust = cstar;
outputs.velocity_effectiveexhaust = ueff;
outputs.velocity_exit = ue;
end