%% The Reconstruction Technique User Interface
% Overview:
% This function allows you to run the Reconstruction Techniques programs
% which are saved in the "functions" folder based on experimental data
% saved in the "inputs" folder.

% Instructions:
% Please complete the following four steps.

% Step 1 - specify the inputs file name: e.g. 'test_1'
%     note: this file must be saved in the folder titled "inputs"
%%
filename = 'test-1';
%filename = 'test-2';
%filename = 'test-3';
%filename = 'test-4';
%filename = 'test-5';
%filename = 'test-6';
%filename = 'test-7';
%filename = 'test-8';
%filename = 'test-9';
%filename = 'test-10';
%filename = 'test-11';
%filename = 'test-12';

OF_lim=3;
eta_lim=1.2;%1.05

name = [filename,'.xlsx'];
% Step 2 - specify which reconstruction techniques you would like to run
%     'yes' to run, 'no' to skip
OP_F_C = 'yes';
OP_F_CE = 'yes';
PRTM = 'yes';
TRTEM = 'yes';
MODIFY = 'yes';
% Step 3 - specify which propellant combination was used
%  select from one of the following options:
%  'N2OHDPE','O2HDPE','N2O10O290HDPE','N2O20O280HDPE','N2O30O270HDPE', ...
%  'N2O40O260HDPE','N2O50O250HDPE','N2O60O240HDPE','N2O70O230HDPE', ...
%  'N2O80O220HDPE','N2O90O210HDPE'
propellant = 'O2HDPE';

% Step 4 - "Run" this program (i.e. "user_interface.m") !

%% ******* Everything below this line is automated *********
% task 1: addpath
addpath(strcat(pwd,'\functions'))

% task 2: readmatrix
data = readmatrix(strcat(pwd,'\inputs\',name));

% task 3: load
load(strcat(pwd,'\databases\CEA_210623'))

% task 4: assign data to "inputs" structure
inputs.database_CEA = CEA.(propellant);     % n/a
inputs.diameter_exit = 1e-3*data(1,8);      % m (converted from mm)
inputs.diameter_throat = 1e-3*data(1,6);    % m (converted from mm)
inputs.mass_fuelconsumption = data(1,7);    % kg
inputs.massflowrate_oxidizer = data(:,2);   % kg/s
inputs.pressure_atmosphere = 1e6*data(1,9); % Pa (converted from MPa)
inputs.pressure_chamber = 1e6*data(:,3);    % Pa (converted from MPa)
inputs.thrust = data(:,4);                  % N
inputs.time_burn = data(:,1);               % s
inputs.eta = data(:,10);                    % s
inputs.OF = data(:,5);                      % O/F

filename_graph = ('input_CEA');
F_make_graph_CEA(filename_graph,inputs)

filename_graph = [filename,'_input_FiringTest'];
F_make_graph_input_all(filename_graph,inputs)

% task 5: sort input data by fieldname
inputs = task_sort_fieldname(inputs);



% %% temp
% inputs.OF = data(:,5); 
% AA=0;
% BB=1;
% a=1;
% while abs(a) >0.000001 
%   eF=(AA+BB)/2;
% for i=1:1:500
% ins_cal_F.efficiency_thrust = eF;
% 
% ins_cal_F.database_CEA          = inputs.database_CEA;
% ins_cal_F.diameter_exit         = inputs.diameter_exit;
% ins_cal_F.diameter_throat       = inputs.diameter_throat;
% ins_cal_F.massflowrate_oxidizer = inputs.massflowrate_oxidizer(i,1);
% ins_cal_F.pressure_atmosphere   = inputs.pressure_atmosphere;
% ins_cal_F.pressure_chamber      = inputs.pressure_chamber(i,1);
% 
% mdotfu=ins_cal_F.massflowrate_oxidizer/inputs.OF(i,1);
% 
% ins_cal_F.massflowrate_fuel     = mdotfu;
% 
% ous_cal_F = calculation_thrust_TRTEM(ins_cal_F);
% Fcal = ous_cal_F.thrust;
% F=inputs.thrust(i,1);
% a=F-Fcal;
% end
% if a > 0
%     AA=eF;
% else
%     BB=eF;
% end
% a
% eF
% end
% aaa

%%


% task 5: reconstruction techniques
if isequal(OP_F_C,'yes') %
    disp(' ')
    disp('***************************************************************')
    disp(' Pressure-based RT for Fuel Mass Flow Rate [OP-F-C a.k.a. RT-1] ')
    disp('***************************************************************')
    disp(datetime)
    % conditional task 5-a: PRTM
    outputs_OP_F_C = iteration_efficiency_combustion_OP_F_C(inputs);
    outputs_OP_F_C.name = filename;
    name_OP_F_C = strcat(pwd,'\outputs\',filename,'_OP_F_C');
    outputs_OP_F_C = task_sort_fieldname(outputs_OP_F_C);
    save(name_OP_F_C,'outputs_OP_F_C')
    
    %filename_graph = [filename,'_output_OP_F_C'];
    %F_make_graph_output_OP_F_C(filename_graph, outputs_OP_F_C,OF_lim)
end

if isequal(OP_F_CE,'yes') %
    disp(' ')
    disp('***************************************************************')
    disp(' Pressure-based RT for Fuel Mass Flow Rate [OP_F_CE a.k.a. RT-5] ')
    disp('***************************************************************')
    disp(datetime)
    % conditional task 5-a: PRTM
    outputs_OP_F_CE = iteration_efficiency_combustion_OP_F_CE(inputs,outputs_OP_F_C);
    outputs_OP_F_CE.name = filename;
    name_OP_F_CE = strcat(pwd,'\outputs\',filename,'_OP_F_CE');
    outputs_OP_F_CE = task_sort_fieldname(outputs_OP_F_CE);
    save(name_OP_F_CE,'outputs_OP_F_CE')
    
    %filename_graph = [filename,'_output_OP_F_CE'];
    %F_make_graph_output_PRTM(filename_graph,outputs_OP_F_CE,OF_lim)
end

if isequal(PRTM,'yes') %
    disp(' ')
    disp('***************************************************************')
    disp(' Pressure-based RT for Fuel Mass Flow Rate [OP-F-C a.k.a. RT-2] ')
    disp('***************************************************************')
    disp(datetime)
    % conditional task 5-a: PRTM
    outputs_PRTM = iteration_efficiency_combustion_PRTM(inputs);
    outputs_PRTM.name = filename;
    name_PRTM = strcat(pwd,'\outputs\',filename,'_PRTM');
    outputs_PRTM= task_sort_fieldname(outputs_PRTM);
    save(name_PRTM,'outputs_PRTM')
    
    %filename_graph = [filename,'_output_OP_F_E'];
    %F_make_graph_output_PRTM(filename_graph,outputs_PRTM,OF_lim)
end

if isequal(TRTEM,'yes')
    disp(' ')
    disp('***************************************************************')
    disp('Thrust-based RT for Efficiency and Fuel Mass Flow Rate [TRT-EM]')
    disp('***************************************************************')
    disp(datetime)
    % conditional task 5-b: TRTEM
    outputs_TRTEM = iteration_efficiency_thrust_TRTEM(inputs);
    outputs_TRTEM.name = filename;
    name_TRTEM = strcat(pwd,'\outputs\',filename,'_TRTEM');
    outputs_TRTEM = task_sort_fieldname(outputs_TRTEM);
    save(name_TRTEM,'outputs_TRTEM')
    
    %filename_graph = [filename,'_output_OPT_F_L'];
    %F_make_graph_output_TPTEM(filename_graph,outputs_TRTEM,OF_lim)
end

% inputs.OF = data(:,5);               % -
% filename_graph = [filename,'_compare_OF'];
% F_make_graph_compare(filename_graph,OF_lim,...
%     inputs.time_burn, ...%time
%     inputs.OF, ...%simulated
%     outputs_OP_F_C.ratio_oxidizertofuelmass,...% OP_F_C
%     outputs_OP_F_CE.ratio_oxidizertofuelmass,...% OP_F_CE
%     outputs_PRTM.ratio_oxidizertofuelmass,...% PRTM
%     outputs_TRTEM.ratio_oxidizertofuelmass) % TRTEM
%
% filename_graph = [filename,'_compare_eta'];
% F_make_graph_compare_eta(filename_graph,...
%     inputs.time_burn, ...%time
%     inputs.eta, ...%simulated
%     outputs_OP_F_CE.efficiency_combustion,...% OP_F_CE
%     outputs_PRTM.efficiency_combustion,...% PRTM
%     outputs_TRTEM.efficiency_combustion) % TRTEM

if isequal(MODIFY,'yes')
    cstar=inputs.database_CEA.velocity_characteristicexhaust.value; %CEA_cstar
    ff=zeros(96,45);
    cstar_mod=zeros(96,45);
    for pc=1:1:45
        for i=1:1:96
            OF=(i+4)/10;
            ff(i,pc)=cstar(i,pc)*(1+1/OF);
        end
        for i=1:1:96
            OF=(i+4)/10;
            if OF>2.3
            else
                appro=(ff(19,pc)-ff(18,pc))/0.1*(OF-2.3)+ff(19,pc);
                if ff(i,pc) > appro
                else
                    ff(i,pc)=appro;
                end
            end
            cstar_mod(i,pc)=ff(i,pc)/(1+1/OF);
        end
    end
    inputs.database_CEA.velocity_characteristicexhaust.value=cstar_mod;
    
    filename_graph = ('input_CEA_modify');
    F_make_graph_CEA_double(filename_graph,cstar,inputs)
    
    
    if isequal(PRTM,'yes') %
        disp(' ')
        disp('***************************************************************')
        disp(' Pressure-based RT for Fuel Mass Flow Rate [OP-F-C a.k.a. RT-2] ')
        disp('***************************************************************')
        disp(datetime)
        % conditional task 5-a: PRTM
        outputs_PRTM_modify = iteration_efficiency_combustion_PRTM(inputs);
        outputs_PRTM_modify.name = filename;
        name_PRTM_modify = strcat(pwd,'\outputs\',filename,'_PRTM_modify');
        outputs_PRTM_modify= task_sort_fieldname(outputs_PRTM_modify);
        save(name_PRTM_modify,'outputs_PRTM_modify')
        
        %   filename_graph = [filename,'_output_OP_F_E_modify'];
        %   F_make_graph_output_PRTM(filename_graph,outputs_PRTM_modify,OF_lim)
    end
    if isequal(TRTEM,'yes')
        disp(' ')
        disp('***************************************************************')
        disp('Thrust-based RT for Efficiency and Fuel Mass Flow Rate [TRT-EM]')
        disp('***************************************************************')
        disp(datetime)
        % conditional task 5-b: TRTEM
        outputs_TRTEM_modify = iteration_efficiency_thrust_TRTEM(inputs);
        outputs_TRTEM_modify.name = filename;
        name_TRTEM_modify = strcat(pwd,'\outputs\',filename,'_TRTEM_modify');
        outputs_TRTEM_modify = task_sort_fieldname(outputs_TRTEM_modify);
        save(name_TRTEM_modify,'outputs_TRTEM_modify')
        
        %   filename_graph = [filename,'_output_OPT_F_L_modify'];
        %  F_make_graph_output_TPTEM(filename_graph,outputs_TRTEM_modify,OF_lim)
    end
    
              % -
    filename_graph = [filename,'_compare_OF'];
    F_make_graph_compare(filename_graph,OF_lim,...
        inputs.time_burn, ...%time
        inputs.OF, ...%simulated
        outputs_OP_F_C.ratio_oxidizertofuelmass,...% OP_F_C
        outputs_OP_F_CE.ratio_oxidizertofuelmass,...% OP_F_CE
        outputs_PRTM.ratio_oxidizertofuelmass,...% PRTM
        outputs_TRTEM.ratio_oxidizertofuelmass,... % TRTEM
        outputs_PRTM_modify.ratio_oxidizertofuelmass,...% PRTM
        outputs_TRTEM_modify.ratio_oxidizertofuelmass) % TRTEM
    
    
    filename_graph = [filename,'_compare_eta'];
    F_make_graph_compare_eta(filename_graph, eta_lim,...
        inputs.time_burn, ...%time
        inputs.eta, ...%simulated
        outputs_OP_F_CE.efficiency_combustion,...% OP_F_CE
        outputs_PRTM.efficiency_combustion,...% PRTM
        outputs_TRTEM.efficiency_combustion,...% TRTEM
        outputs_PRTM_modify.efficiency_combustion,...% PRTM_modify
        outputs_TRTEM_modify.efficiency_combustion) % TRTEM_modify
    
    Error.OF.mean.OP_F_C      = mean(abs(inputs.OF(:,1)-outputs_OP_F_C.ratio_oxidizertofuelmass(:,1)));
    Error.OF.mean.OP_F_CE     = mean(abs(inputs.OF(:,1)-outputs_OP_F_CE.ratio_oxidizertofuelmass(:,1)));
    Error.OF.mean.PRTM        = mean(abs(inputs.OF(:,1)-outputs_PRTM.ratio_oxidizertofuelmass(:,1)));
    Error.OF.mean.TRTEM       = mean(abs(inputs.OF(:,1)-outputs_TRTEM.ratio_oxidizertofuelmass(:,1)));
    Error.OF.mean.PRTM_modify = mean(abs(inputs.OF(:,1)-outputs_PRTM_modify.ratio_oxidizertofuelmass(:,1)));
    Error.OF.mean.TRTEM_modify= mean(abs(inputs.OF(:,1)-outputs_TRTEM_modify.ratio_oxidizertofuelmass(:,1)));
    
    Error.OF.std.OP_F_C       =std(inputs.OF(:,1)-outputs_OP_F_C.ratio_oxidizertofuelmass(:,1));
    Error.OF.std.OP_F_CE      =std((inputs.OF(1,:)-outputs_OP_F_CE.ratio_oxidizertofuelmass(:,1)));
    Error.OF.std.PRTM         =std(inputs.OF(:,1)-outputs_PRTM.ratio_oxidizertofuelmass(:,1));
    Error.OF.std.TRTEM        =std(inputs.OF(:,1)-outputs_TRTEM.ratio_oxidizertofuelmass(:,1));
    Error.OF.std.PRTM_modify  =std(inputs.OF(:,1)-outputs_PRTM_modify.ratio_oxidizertofuelmass(:,1));
    Error.OF.std.TRTEM_modify =std(inputs.OF(:,1)-outputs_TRTEM_modify.ratio_oxidizertofuelmass(:,1));
    
    dir=('graph');
    mkdir(dir);
    figure(1)
    x =  categorical({'OPMA-F-C',    'OPMA-F-CE',             'OPTMA-F-E',           'OPTMA-FE-L',                    'OPMA-F-C (modified CEA)',       'OPTMA-FE-L (modified CEA)'});
    x = reordercats(x,{'OPMA-F-C',    'OPMA-F-CE',             'OPTMA-F-E',           'OPTMA-FE-L',                    'OPMA-F-C (modified CEA)',       'OPTMA-FE-L (modified CEA)'});
    data = [Error.OF.mean.OP_F_C  Error.OF.mean.OP_F_CE  Error.OF.mean.PRTM    Error.OF.mean.TRTEM            Error.OF.mean.PRTM_modify     Error.OF.mean.TRTEM_modify]';
    err =  [Error.OF.std.OP_F_C   Error.OF.std.OP_F_CE   Error.OF.std.PRTM     Error.OF.std.TRTEM             Error.OF.std.PRTM_modify      Error.OF.std.TRTEM_modify];
    b=bar(data,1);
    xlabel( '', 'fontsize', 15, 'FontName', 'Times New Roman');
    ylabel('{\it O/F} error [-]','FontName', 'Times','FontSize', 15)
    
    b.FaceColor = 'flat';
    b.CData(1,:) = [0 1 1];
    b.CData(2,:) = [1 0 1];
    b.CData(3,:) = [1 0 0];
    b.CData(4,:) = [0 0 1];
    b.CData(5,:) = [1 0 0];
    b.CData(6,:) = [0 0 1];
    set (gca, 'XTickLabel', {'OP-F-C', 'OP-F-CE',  'OPT-F-E', 'OPT-FE-L','OP-F-C (modified CEA)','OPT-FE-L (modified CEA)'}, 'FontSize', 12, 'FontName', 'Times New Roman');
    hold on
    er = errorbar(x,data,err);
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    hold off
    ylim([0 1.5]);
    xtickangle(45);
    filename1 = [filename,'_OF_error'];
    filename1 = ['graph_',filename1];
    filename_png = [dir, '\',filename1,'.png'];
    saveas(gcf, filename_png);
    filename_emf = [dir, '\',filename1,'.emf'];
    saveas(gcf, filename_emf);
    
    filename_PDF= [dir, '\',filename1];
    F_SaveFig(figure(1), filename_PDF)
    close(1)
    
    Error.eta.mean.OP_F_CE     = mean(abs(inputs.eta(:,1)-outputs_OP_F_CE.efficiency_combustion));
    Error.eta.mean.PRTM        = mean(abs(inputs.eta(:,1)-outputs_PRTM.efficiency_combustion));
    Error.eta.mean.TRTEM       = mean(abs(inputs.eta(:,1)-outputs_TRTEM.efficiency_combustion(:,1)));
    Error.eta.mean.PRTM_modify = mean(abs(inputs.eta(:,1)-outputs_PRTM_modify.efficiency_combustion));
    Error.eta.mean.TRTEM_modify= mean(abs(inputs.eta(:,1)-outputs_TRTEM_modify.efficiency_combustion(:,1)));
    
    Error.eta.std.OP_F_CE      =std((inputs.eta(:,1)-outputs_OP_F_CE.efficiency_combustion));
    Error.eta.std.PRTM         =std(inputs.eta(:,1)-outputs_PRTM.efficiency_combustion);
    Error.eta.std.TRTEM        =std(inputs.eta(:,1)-outputs_TRTEM.efficiency_combustion(:,1));
    Error.eta.std.PRTM_modify  =std(inputs.eta(:,1)-outputs_PRTM_modify.efficiency_combustion);
    Error.eta.std.TRTEM_modify =std(inputs.eta(:,1)-outputs_TRTEM_modify.efficiency_combustion(:,1));
    
    
    figure(1)
    x=  categorical({'OP-F-CE',             'OPT-F-E',           'OPT-FE-L',                    'OP-F-C (modified CEA)',       'OPT-FE-L (modified CEA)'});
    x = reordercats(x,{'OP-F-CE',             'OPT-F-E',           'OPT-FE-L',                    'OP-F-C (modified CEA)',       'OPT-FE-L (modified CEA)'});
    data = [Error.eta.mean.OP_F_CE  Error.eta.mean.PRTM    Error.eta.mean.TRTEM            Error.eta.mean.PRTM_modify     Error.eta.mean.TRTEM_modify]';
    err = [Error.eta.std.OP_F_CE    Error.eta.std.PRTM     Error.eta.std.TRTEM             Error.eta.std.PRTM_modify      Error.eta.std.TRTEM_modify];
    b=bar(data,1);
    xlabel( '', 'fontsize', 15, 'FontName', 'Times New Roman');
    ylabel('{\it \eta_{c^{*}}} error [-]','FontName', 'Times','FontSize', 15)
    
    b.FaceColor = 'flat';
    b.CData(1,:) = [1 0 1];
    b.CData(2,:) = [1 0 0];
    b.CData(3,:) = [0 0 1];
    b.CData(4,:) = [1 0 0];
    b.CData(5,:) = [0 0 1];
    set (gca, 'XTickLabel', {'OP-F-CE',  'OPT-F-E', 'OPT-FE-L','OP-F-C (modified CEA)','OPT-FE-L (modified CEA)'}, 'FontSize', 12, 'FontName', 'Times New Roman');
    hold on
    er = errorbar(x,data,err);
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    hold off
    ylim([0 0.2]);
    xtickangle(45);
    filename1 = [filename,'_eta_error'];
    filename1 = ['graph_',filename1];
    filename_png = [dir, '\',filename1,'.png'];
    saveas(gcf, filename_png);
    filename_emf = [dir, '\',filename1,'.emf'];
    saveas(gcf, filename_emf);
    
    filename_PDF= [dir, '\',filename1];
    F_SaveFig(figure(1), filename_PDF)
    
    close(1)
    
end
