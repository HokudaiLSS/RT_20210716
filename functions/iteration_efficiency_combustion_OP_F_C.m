function outputs = iteration_efficiency_combustion_OP_F_C(inputs)
%% Overview
% The objectve of this function is to solve for the time-averaged
% combustion efficiency based on the overall fuel mass consumption for the
% PRT-M operation.

% Inputs:
%    database_CEA "CEADB" [m/s]
%    diameter_throat "dt" [m]
%    efficiency_combustion "estar" [-]
%    mass_fuelconsumption "mfu" [kg]
%    massflowrate_oxidizer "mdotox" [kg/s]
%    pressure_chamber "Pc" [Pa]
%    time_burn "t" [s]

% Outputs:
%    counter_bisectioniteration "iB" [#]
%    efficiency_combustion "estar" [-]
%    mass_fuelconsumption "mfu" [kg]
%    massflowrate_fuel "mdotfu" [kg/s]
%    massflowrate_propellant "mdotp" [kg/s]
%    ratio_oxidizertofuelmass "OF" [-]
%    residual_bisectioniteration "PsiB" [-]
%    value_bisectioniteration "estarBtracker" [kg/s]
%    velocity_characteristicexhaust "cstar" [m/s]

% Subordinate Functions & Structure:
%    equation_residual
%    integration_trapezoidal
%    iteration_massflowrate_fuel_PRTM
%        calculation_pressure_chamber_PRTM
%            equation_area_circle
%            equation_pressure_chamber
%            interpolation_linear
%        equation_abscissa_line
%        equation_residual

% Senior Functions: n/a

%% Test Data: a case where OF is outside the multiple solutions region
% load(strcat(strrep(pwd,'functions','databases'),'\CEA'))
% inputs.database_CEA = CEA.O2HDPE;
% inputs.diameter_throat = 23e-3;
% inputs.efficiency_combustion = 0.95;
% inputs.mass_fuelconsumption = 1.2;
% inputs.massflowrate_oxidizer = 500e-3*ones(7,1);
% inputs.pressure_chamber = 3e6*ones(7,1);
% inputs.time_burn = (0:1:6)';

%% Assign Inputs to Variables
CEADB  = inputs.database_CEA;
dt     = inputs.diameter_throat;
mdotox = inputs.massflowrate_oxidizer;
mfu    = inputs.mass_fuelconsumption;
Pc     = inputs.pressure_chamber;
t      = inputs.time_burn;

% computation 4: integration_trapezoidal
% output: mass_fuelconsumption "mfu"
ins_integ.abscissa = t;
ins_integ.ordinate = Pc;
outs_integ = integration_trapezoidal(ins_integ);
sum_pressure_chamber=outs_integ.area_total;

ins_integ.ordinate = mdotox;
outs_integ = integration_trapezoidal(ins_integ);
sum_massflowrate_oxidizer=outs_integ.area_total;

ins_eq_At.diameter = dt;
outs_eq_At = equation_area_circle(ins_eq_At);
At = outs_eq_At.area_circle;

cstar_average=sum_pressure_chamber*At/(sum_massflowrate_oxidizer+mfu);

display = [cstar_average];
fprintf('c* average = %6.1f m/s\n',display)

%% Conduct Follow-on Calculations
for k = 1:length(t)
    OF(k) = mdotox(k)*cstar_average/(Pc(k)*At- mdotox(k)*cstar_average);
    mdotfu(k)=mdotox(k)/OF(k);
    mdotp(k)=mdotfu(k)+mdotox(k);
end
    % computation 4: integration_trapezoidal
    % output: mass_fuelconsumption "mfu"
    ins_integ_mfu.abscissa = t;
    ins_integ_mfu.ordinate = mdotfu;
    ous_integ_mfu = integration_trapezoidal(ins_integ_mfu);
    mfucal = ous_integ_mfu.area_total;
    mfuhistory = ous_integ_mfu.integral_trapezoidal;
    
%% Assign Variables to Outputs
outputs.counter_bisectioniteration = i;
%outputs.efficiency_combustion = estar;
outputs.mass_fuelconsumption = mfucal;
outputs.mass_fuelconsumption_history = mfuhistory;
outputs.massflowrate_fuel = mdotfu;
outputs.massflowrate_propellant = mdotp;
outputs.ratio_oxidizertofuelmass = OF';
%outputs.residual_bisectioniteration = Psitracker;
%outputs.value_bisectioniteration = estartracker;
outputs.velocity_characteristicexhaust = cstar_average;
outputs.time = t;
end