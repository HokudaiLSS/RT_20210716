function outputs = iteration_massflowrate_fuel_PRTM(inputs)
%% Overview
% The objectve of this function is to solve for the fuel mass flow rate
% using the chamber pressure equation for the PRT-M iteration of combustion
% efficiency. Iterations are completed using the bi-section method.

% Inputs:
%    database_CEA "CEADB" [m/s]
%    diameter_throat "dt" [m]
%    efficiency_combustion "estar" [-]
%    massflowrate_oxidizer "mdotox" [kg/s]
%    pressure_chamber "Pc" [Pa]

% Outputs:
%    counter_bisectioniteration "iB" [#]
%    massflowrate_fuel "mdotfu" [kg/s]
%    massflowrate_propellant "mdotp" [kg/s]
%    ratio_oxidizertofuelmass "OF" [-]
%    residual_bisectioniteration "PsiB" [-]
%    value_bisectioniteration "mdotfuBtracker" [kg/s]
%    velocity_characteristicexhaust "cstar" [m/s]

% Subordinate Functions:
%    calculation_pressure_chamber_PRTM
%        equation_area_circle
%        equation_pressure_chamber
%        interpolation_linear
%    equation_residual

% Senior Functions:
%    iteration_massflowrate_fuel_PRTM

%% Test Data: a case where OF is outside the multiple solutions region
% load(strcat(strrep(pwd,'functions','databases'),'\CEA'))
% inputs.database_CEA = CEA.O2HDPE;
% inputs.diameter_throat = 0.023;
% inputs.efficiency_combustion = 0.95;
% inputs.massflowrate_fuel = 0.500/4;
% inputs.massflowrate_oxidizer = 0.500;
% inputs.pressure_chamber = 3e6;

%% Assign Inputs to Variables
CEADB  = inputs.database_CEA;
dt     = inputs.diameter_throat;
estar  = inputs.efficiency_combustion;
mdotox = inputs.massflowrate_oxidizer;
Pc     = inputs.pressure_chamber;

%% The Iteration
% iteration counters [#]
i = 0;
max = 100;

% initial residual definition
Psi = 8;

% bisection limits "PcL" & "PcU" [Pa]
mdotfuL = mdotox/300;
mdotfuU = 300*mdotox;
   
while abs(Psi) > 1e-3 && i <= max

    % computation c1-1: +
    % output: Bisection iteration counter "i" [#]   
    i = i + 1;

    % computation c1-2: *
    % output: massflowrate_fuel "mdotfu" [-]
    mdotfu = (mdotfuU + mdotfuL) / 2;

    % computation c1-3: calculation_pressure_chamber_PRTM
    % output: pressure_chamber calculation "Pccal" [N]
    ins_cal_Pccal.database_CEA = CEADB;
    ins_cal_Pccal.diameter_throat = dt;
    ins_cal_Pccal.efficiency_combustion = estar;
    ins_cal_Pccal.massflowrate_fuel = mdotfu;
    ins_cal_Pccal.massflowrate_oxidizer = mdotox;
    ins_cal_Pccal.pressure_chamber = Pc;
    ous_cal_Pccal = calculation_pressure_chamber_PRTM(ins_cal_Pccal);
    Pccal = ous_cal_Pccal.pressure_chamber;

    % computation c1-4: equation_residual
    % output: residual_pressure_chamber "PsiPc" [-]
    ins_eq_Psi.numerator = Pccal;
    ins_eq_Psi.denominator = Pc;
    outs_eq_Psi = equation_residual(ins_eq_Psi);
    PsiPc = outs_eq_Psi.residual;

    % update the Bisection residual term "Psi" [-]
    Psi = PsiPc; 

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
% computation s-1: calculation_pressure_chamber_PRTM
% output: massflowrate_propellant "mdotp" [kg/s]
% output: ratio_oxidizertofuelmass "OF" [-]
% output: velocity_characteristicexhaust "cstar" [m/s]
ins_cal_Pccal.massflowrate_fuel = mdotfu;
ous_cal_Pccal = calculation_pressure_chamber_PRTM(ins_cal_Pccal);
cstar = ous_cal_Pccal.velocity_characteristicexhaust;
mdotp = ous_cal_Pccal.massflowrate_propellant;
OF = ous_cal_Pccal.ratio_oxidizertofuelmass;

%% Assign Variables to Outputs
outputs.counter_bisectioniteration = i;
outputs.massflowrate_fuel = mdotfu;
outputs.massflowrate_propellant = mdotp;
outputs.ratio_oxidizertofuelmass = OF;
outputs.residual_bisectioniteration = Psitracker;
outputs.value_bisectioniteration = mdotfutracker;
outputs.velocity_characteristicexhaust = cstar;
end