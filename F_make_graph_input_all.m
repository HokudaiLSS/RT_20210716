function  F_make_graph_input_all(filename, inputs)
dir=('graph');
mkdir(dir);
% inputs.database_CEA = CEA.(propellant);     % n/a
% inputs.diameter_exit = 1e-3*data(1,8);      % m (converted from mm)
% inputs.diameter_throat = 1e-3*data(1,6);    % m (converted from mm)
% inputs.mass_fuelconsumption = data(1,7);    % kg
% inputs.massflowrate_oxidizer = data(:,2);   % kg/s
% inputs.pressure_atmosphere = 1e6*data(1,9); % Pa (converted from MPa)
% inputs.pressure_chamber = 1e6*data(:,3);    % Pa (converted from MPa)
% inputs.thrust = data(:,4);                  % N
% inputs.time_burn = data(:,1);               % s


filename1 = ['graph_',filename];
figure(1)
% set(gca, 'FontName', 'Times','Color','white', 'FontSize', 12);

t = tiledlayout(5,1); % Requires R2019b or later

% Top plot
ax1 = nexttile;
plot(ax1,inputs.time_burn,inputs.massflowrate_oxidizer,'k');
h_axes = gca;
h_axes.YAxis.FontSize = 10;
h_axes.YAxis.FontName = 'Times';
ylabel(ax1,{'$\dot{m}_{o}$ [kg/s]'}, 'interpreter', 'latex', 'FontName', 'Times','FontSize', 10)
ylim([0 max(max(inputs.massflowrate_oxidizer))*1.1]);

% Middle plot
ax2 = nexttile;
plot(ax2,inputs.time_burn,1e-6*inputs.pressure_chamber,'r')
h_axes = gca;
h_axes.YAxis.FontSize = 10;
h_axes.YAxis.FontName = 'Times';
ylabel(ax2,{'{\it P_{c}} [MPa]'},'FontName', 'Times','FontSize', 10)
ylim([0 max(max(inputs.pressure_chamber))*1.1*1e-6]);

% Bottom plot-3
ax3 = nexttile;
plot(ax3,inputs.time_burn,inputs.thrust,'b')
h_axes = gca;
h_axes.YAxis.FontSize = 10;
h_axes.YAxis.FontName = 'Times';
h_axes.XAxis.FontSize = 10;
h_axes.XAxis.FontName = 'Times';
ylabel(ax3,{'{\it F} [N]'},'FontName', 'Times','FontSize', 10)
ylim([0 max(max(inputs.time_burn,inputs.thrust))*1.1]);

% Bottom plot-4
ax4 = nexttile;
plot(ax4,inputs.time_burn,inputs.OF,'k')
h_axes = gca;
h_axes.YAxis.FontSize = 10;
h_axes.YAxis.FontName = 'Times';
h_axes.XAxis.FontSize = 10;
h_axes.XAxis.FontName = 'Times';
ylabel(ax4,{'{\it O/F} [-]'},'FontName', 'Times','FontSize', 10)
ylim([0 3]);

% Bottom plot-5
ax5 = nexttile;
plot(ax5,inputs.time_burn,inputs.eta,'k')
h_axes = gca;
h_axes.YAxis.FontSize = 10;
h_axes.YAxis.FontName = 'Times';
h_axes.XAxis.FontSize = 10;
h_axes.XAxis.FontName = 'Times';
ylabel(ax5,{'{\eta_{c*}} [-]'},'FontName', 'Times','FontSize', 10)
ylim([0 1.1]);
xlabel(t,'Time [s]','FontName', 'Times','FontSize', 10)

% Move plots closer together
xticklabels(ax1,{})
xticklabels(ax2,{})
xticklabels(ax3,{})
xticklabels(ax4,{})
t.TileSpacing = 'compact';

filename_png = [dir, '\',filename1,'.png'];
saveas(gcf, filename_png);
filename_emf = [dir, '\',filename1,'.emf'];
saveas(gcf, filename_emf);

filename_PDF= [dir, '\',filename1];
F_SaveFig(figure(1), filename_PDF)
close(1)

end