function outputs = iteration_efficiency_combustion_OP_F_CE(inputs,outputs_OP_F_C)
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

%% The Iteration
% iteration counters [#]
i = 0;
max = 20;

% initial residual definitions
Psi = 8;

% bisection limits "PcL" & "PcU" [Pa]
estarL = 0.4;
estarU = 1.4;

% allocate space for solution vectors
cstar = zeros(size(t));
mdotfu = zeros(size(t));
mdotp = zeros(size(t));
OF = zeros(size(t));

while abs(Psi) > 1e-5 && i <= max

    % computation 1: +
    % output: Bisection iteration counter "iB" [#]   
    i = i + 1;

    % computation 2: *
    % output: efficiency_combustion "estar" [-]
    estar = (estarU + estarL) / 2;       

    for k = 1:length(t) 
        % computation 3: iteration_massflowrate_fuel_PRTM
        ins_interp_cstarth = CEADB.domain;
        ins_interp_cstarth.abscissa = outputs_OP_F_C.ratio_oxidizertofuelmass(k);
        ins_interp_cstarth.ordinate = 1e-6*Pc(k);
        ins_interp_cstarth.value = CEADB.velocity_characteristicexhaust.value;
        outs_interp_cstarth = interpolation_linear(ins_interp_cstarth);
        cstarth = outs_interp_cstarth.interpolation_linear;
        ins_eq_At.diameter = dt;
        outs_eq_At = equation_area_circle(ins_eq_At);
        At = outs_eq_At.area_circle;
        % computation 5: *
        % output: velocity_characteristicexhaust "cstar" [m/s]
        cstar = estar.*cstarth;
        mdotfu(k)=Pc(k)*At/(cstar)- mdotox(k);
        OF(k)=mdotox(k)/mdotfu(k);
        if mdotfu(k) < 0
            mdotfu(k)=0;
            OF(k)=0;
        end
    end

    % computation 4: integration_trapezoidal
    % output: mass_fuelconsumption "mfu"
    ins_integ_mfu.abscissa = t;
    ins_integ_mfu.ordinate = mdotfu;
    ous_integ_mfu = integration_trapezoidal(ins_integ_mfu);
    %mfucal =trapz(inputs.time_burn(:,1), mdotfu);
    mfucal = ous_integ_mfu.area_total;
    mfuhistory = ous_integ_mfu.integral_trapezoidal;

    % computation 5: equation_residual
    % output: residual_fuelmassconsumption left "PsimfuL" [-]
    ins_eq_Psi.denominator = mfu;
    ins_eq_Psi.numerator = mfucal;
    outs_eq_Psi = equation_residual(ins_eq_Psi);
    Psimfu = outs_eq_Psi.residual;

    % update the Bisection residual term "PsiB" [-]
    Psi = Psimfu;

    % update the Bisection trackers
    estartracker(i,1) = estar;
    Psitracker(i,1) = Psi;

    % message to users
    display = [estar,Psimfu];
    fprintf('c* efficiency = %6.4f where residual = %8.5f\n',display)

    % update bounds of bisection
    if Psi > 0
        estarU = estar;
    else
        estarL = estar;
    end    
end

%% Conduct Follow-on Calculations
% for k = 1:length(t) 
%     % computation s-1: iteration_massflowrate_fuel_PRTM
%     % output: massflowrate_fuel "mdotfu" [kg/s]
%     % output: massflowrate_propellant "mdotp" [kg/s]
%     % output: ratio_oxidizertofuelmass "OF" [-]
%     % output: velocity_characteristicexhaust "cstar" [m/s]
%     ins_iter_mdotfu.efficiency_combustion = estar;       
%     ins_iter_mdotfu.massflowrate_oxidizer = mdotox(k);             
%     ins_iter_mdotfu.pressure_chamber = Pc(k);
%     ous_iter_mdotfu = iteration_massflowrate_fuel_PRTM(ins_iter_mdotfu);
%     cstar(k) = ous_iter_mdotfu.velocity_characteristicexhaust;
%     mdotfu(k) = ous_iter_mdotfu.massflowrate_fuel;
%     mdotp(k) = ous_iter_mdotfu.massflowrate_propellant;
%     OF(k) = ous_iter_mdotfu.ratio_oxidizertofuelmass;
% end

%% Assign Variables to Outputs
outputs.counter_bisectioniteration = i;
outputs.efficiency_combustion = estar;
outputs.mass_fuelconsumption = mfucal;
outputs.mass_fuelconsumption_history = mfuhistory;
outputs.massflowrate_fuel = mdotfu;
outputs.massflowrate_propellant = mdotp;
outputs.ratio_oxidizertofuelmass = OF;
outputs.residual_bisectioniteration = Psitracker;
outputs.value_bisectioniteration = estartracker;
outputs.velocity_characteristicexhaust = cstar;
outputs.time = t;
end