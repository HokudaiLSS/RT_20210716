function outputs = iteration_efficiency_thrust_TRTEM(inputs)
%% Overview
% The objectve of this function is to solve for the time-averaged 
% combustion efficiency based on the overall fuel mass consumption for the
% TRT-EM operation.

% Inputs:
%    database_CEA "CEADB" [m/s]
%    diameter_exit "de" [m]
%    diameter_throat "dt" [m]
%    massflowrate_oxidizer "mdotox" [kg/s]
%    pressure_atmosphere "Pa" [Pa]
%    pressure_chamber "Pc" [Pa]
%    thrust "F" [N]

% Outputs:
%    area_exit "Ae" [m^2]
%    area_throat "At" [m^2]
%    counter_bisectioniteration "iB" [#]
%    efficiency_combustion "estar" [-]
%    efficiency_thrust "eF" [-]
%    massflowrate_fuel "mdotfu" [kg/s]
%    massflowrate_propellant "mdotp" [kg/s]
%    pressure_exit "Pe" [Pa]
%    ratio_oxidizertofuelmass "OF" [-]
%    residual_bisectioniteration "PsiB" [-]
%    specificimpulse "Isp" [s]
%    value_bisectioniteration "mdotfuBtracker" [kg/s]
%    velocity_characteristicexhaust "cstar" [m/s]
%    velocity_effectiveexhaust "ueff" [m/s]
%    velocity_exit "ue" [m/s]

% Subordinate Functions & Structure:
%    equation_residual
%    integration_trapezoidal
%    iteration_massflowrate_fuel_TRTEM
%        calculation_thrust_TRTEM
%            equation_area_circle
%            equation_coefficient_thrust
%            equation_specificimpulse
%            equation_thrust
%            equation_velocity_characteristicexhaust
%            equation_velocity_effectiveexhaust
%            equation_velocity_exit
%            interpolation_line
%            iteration_pressure_exit
%                equation_ratio_nozzleexpansion
%                equation_residual
%        equation_residual

% Senior Functions:
%    n/a

%% Test Data: a case where OF is outside the multiple solutions region
% load(strcat(strrep(pwd,'functions','databases'),'\CEA'))
% inputs.database_CEA = CEA.O2HDPE;
% inputs.diameter_exit = 2*23e-3;
% inputs.diameter_throat = 23e-3;
% inputs.mass_fuelconsumption = 1.2;
% inputs.massflowrate_oxidizer = 500e-3*ones(7,1);
% inputs.pressure_atmosphere = 1e5;
% inputs.pressure_chamber = 3e6*ones(7,1);
% inputs.thrust = 1800*ones(7,1);
% inputs.time_burn = (0:1:6)';

%% Assign Inputs to Variables
CEADB  = inputs.database_CEA;
de     = inputs.diameter_exit;
dt     = inputs.diameter_throat;
F      = inputs.thrust;
mdotox = inputs.massflowrate_oxidizer;
mfu    = inputs.mass_fuelconsumption;
Pa     = inputs.pressure_atmosphere;
Pc     = inputs.pressure_chamber;
t      = inputs.time_burn;

% stoichiometric OF
OFs = CEADB.ratio_stoichiometric.value;

%% The Iteration
% iteration counters [#]
i = 0;
max = 20;

% initial residual definitions
Psi = 8;

% bisection limits "PcL" & "PcU" [Pa]
eFL = 0.;
eFU = 1.2;

% allocate space for solution vector
Ae = zeros(size(t));
At = zeros(size(t));
CF = zeros(size(t));
cstar = zeros(size(t));
estar = zeros(size(t));
Isp = zeros(size(t));
mdotfu = zeros(size(t));
mdotp = zeros(size(t));
OF = zeros(size(t));
Pe = zeros(size(t));
ue = zeros(size(t));
ueff = zeros(size(t));

% % check solutions region
% eFtest = (0.4:0.02:1.1)';
% Psimfutest = 8*ones(size(eFtest));
% mfucaltest = zeros(size(eFtest));
% for i = 1:length(eFtest) 
%     for k = 1:length(t)     
%         
%         % computation 2: iteration_massflowrate_fuel_TRTEM
%         % output: massflowrate_fuel "mdotfu" [kg/s]
%         ins_iter_mdotfu.database_CEA = CEADB;
%         ins_iter_mdotfu.diameter_exit = de;
%         ins_iter_mdotfu.diameter_throat = dt;
%         ins_iter_mdotfu.efficiency_thrust = eFtest(i);    
%         ins_iter_mdotfu.massflowrate_oxidizer = mdotox(k);
%         ins_iter_mdotfu.pressure_atmosphere = Pa;            
%         ins_iter_mdotfu.pressure_chamber = Pc(k);
%         ins_iter_mdotfu.thrust = F(k);
%         ous_iter_mdotfu = ...
%             iteration_massflowrate_fuel_TRTEM(ins_iter_mdotfu); 
%         mdotfu(k) = ous_iter_mdotfu.massflowrate_fuel;
%     end
% 
%     % computation 3: integration_trapezoidal
%     % output: mass_fuelconsumption "mfu"
%     ins_integ_mfu.abscissa = t;
%     ins_integ_mfu.ordinate = mdotfu;
%     ous_integ_mfu = integration_trapezoidal(ins_integ_mfu);
%     mfucal = ous_integ_mfu.area_total;
%     mfucaltest(i) = mfucal;
%     
%     % computation 4: equation_residual
%     % output: residual_fuelmassconsumption left "PsimfuL" [-]
%     ins_eq_Psi.denominator = mfu;
%     ins_eq_Psi.numerator = mfucal;
%     outs_eq_Psi = equation_residual(ins_eq_Psi);
%     Psimfutest(i) = outs_eq_Psi.residual;
% end
% figure
% plot(eFtest,Psimfutest,'--k','Marker','p')
% ylabel('Residual \Psi_{mfu}','FontSize',17.6,'FontName','Times New Roman')
% xlabel('Efficiency, \lambda','FontSize',17.6,'FontName','Times New Roman')
% set(gca,'FontName','Times New Roman','FontSize',16)
% grid on
% 
% figure
% hold on
% plot(eFtest,mfucaltest,'-k','Marker','p')
% plot([eFtest(1) eFtest(end)],[mfu mfu],'--r','Marker','s')
% ylabel('Fuel Mass Consumption \it M_{fu}','FontSize',17.6,'FontName','Times New Roman')
% xlabel('Efficiency, \lambda','FontSize',17.6,'FontName','Times New Roman')
% set(gca,'FontName','Times New Roman','FontSize',16)
% grid on
% hold off

while abs(Psi) > 1e-3 && i <= max

    % computation c1: +
    % output: Bisection iteration counter "i" [#]   
    i = i + 1;

    % computation c2: *
    % output: efficiency_combustion "estar" [-]
    eF = (eFU + eFL) / 2;       

    for k = 1:length(t)
        
        % computation 3: iteration_massflowrate_fuel_TRTEM
        % output: massflowrate_fuel "mdotfu" [kg/s]
        ins_iter_mdotfu.database_CEA = CEADB;
        ins_iter_mdotfu.diameter_exit = de;
        ins_iter_mdotfu.diameter_throat = dt;
        ins_iter_mdotfu.efficiency_thrust = eF;    
        ins_iter_mdotfu.massflowrate_oxidizer = mdotox(k);
        ins_iter_mdotfu.pressure_atmosphere = Pa;            
        ins_iter_mdotfu.pressure_chamber = Pc(k);
        ins_iter_mdotfu.thrust = F(k);
        ous_iter_mdotfu = ...
            iteration_massflowrate_fuel_TRTEM(ins_iter_mdotfu); 
        mdotfu(k) = ous_iter_mdotfu.massflowrate_fuel;
        
    end

    % computation 4: integration_trapezoidal
    % output: mass_fuelconsumption "mfu"
    ins_integ_mfu.abscissa = t;
    ins_integ_mfu.ordinate = mdotfu;
    ous_integ_mfu = integration_trapezoidal(ins_integ_mfu);
    mfucal = ous_integ_mfu.area_total;
    mfuhistory = ous_integ_mfu.integral_trapezoidal;
    % computation 5: equation_residual
    % output: residual_fuelmassconsumption left "PsimfuL" [-]
    ins_eq_Psi.denominator = mfu;
    ins_eq_Psi.numerator = mfucal;
    outs_eq_Psi = equation_residual(ins_eq_Psi);
    Psimfu = outs_eq_Psi.residual;

    % update the Bisection residual term "Psi" [-]
    Psi = Psimfu;

    % update the Bisection trackers
    eFtracker(i,1) = eF;
    Psitracker(i,1) = Psi;

    % message to users
    display = [eF,Psimfu];
    fprintf('thrust efficiency = %6.4f where residual = %8.5f\n',display)

    % update the bounds of bisection iteration
    if Psi > 0
        eFU = eF;
    else
        eFL = eF;
    end    
end

%% Conduct Follow-on Calculations
for k = 1:length(t) 
    % computation s-1: iteration_TRTEF_fuelmassflowrate
    % output: coefficient_thrust "CF" [-]
    % output: efficiency_combustion "estar" [-]
    % output: massflowrate_propellant "mdotp" [kg/s]
    % output: pressure_exit "Pe" [Pa]
    % output: ratio_oxidizertofuelmass "OF" [-]
    % output: specificimpulse "Isp" [s]
    % output: velocity_characteristicexhaust "cstar" [m/s]
    % output: velocity_effectiveexhaust "ueff" [m/s]
    % output: velocity_exit "ue" [m/s]
    ins_iter_mdotfu.efficiency_thrust = eF;       
    ins_iter_mdotfu.massflowrate_oxidizer = mdotox(k);             
    ins_iter_mdotfu.pressure_chamber = Pc(k);
    ins_iter_mdotfu.thrust = F(k);
    ous_iter_mdotfu = ...
        iteration_massflowrate_fuel_TRTEM(ins_iter_mdotfu);
    Ae(k) = ous_iter_mdotfu.area_exit;
    At(k) = ous_iter_mdotfu.area_throat;
    CF(k) = ous_iter_mdotfu.coefficient_thrust;
    cstar(k) = ous_iter_mdotfu.velocity_characteristicexhaust;
    estar(k) = ous_iter_mdotfu.efficiency_combustion;
    Isp(k) = ous_iter_mdotfu.specificimpulse;
    mdotfu(k) = ous_iter_mdotfu.massflowrate_fuel;
    mdotp(k) = ous_iter_mdotfu.massflowrate_propellant;
    OF(k) = ous_iter_mdotfu.ratio_oxidizertofuelmass;
    Pe(k) = ous_iter_mdotfu.pressure_exit;
    ueff(k) = ous_iter_mdotfu.velocity_effectiveexhaust;
    ue(k) = ous_iter_mdotfu.velocity_exit;
end

%% Assign Variables to Outputs
outputs.area_exit = Ae;
outputs.area_throat = At;
outputs.coefficient_thrust = CF;
outputs.counter_bisectioniteration = i;
outputs.efficiency_combustion = estar;
outputs.efficiency_thrust = eF;
outputs.mass_fuelconsumption = mfucal;
outputs.mass_fuelconsumptionhistory = mfuhistory;
outputs.massflowrate_fuel = mdotfu;
outputs.massflowrate_propellant = mdotp;
outputs.pressure_exit = Pe;
outputs.ratio_oxidizertofuelmass = OF;
outputs.residual_bisectioniteration = Psitracker;
outputs.specificimpulse = Isp;
outputs.value_bisectioniteration = eFtracker;
outputs.velocity_characteristicexhaust = cstar;
outputs.velocity_effectiveexhaust = ueff;
outputs.velocity_exit = ue;
outputs.time = t;
end