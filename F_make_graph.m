function  F_make_graph(filename, inputs)
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

t = tiledlayout(3,1); % Requires R2019b or later

% Top plot
ax1 = nexttile;
plot(ax1, inputs.massflowrate_oxidizer,'c');
h_axes = gca;
h_axes.YAxis.FontSize = 8;
h_axes.YAxis.FontName = 'Times';
ylabel(ax1,{'Oxidizer mass flow rate','[kg/s]'},'FontName', 'Times','FontSize', 8)
ylim([0 1]);

% Middle plot
ax2 = nexttile;
plot(ax2,1e-6*inputs.pressure_chamber,'r')
h_axes = gca;
h_axes.YAxis.FontSize = 8;
h_axes.YAxis.FontName = 'Times';
ylabel(ax2,{'Chamber pressure','[MPa]'},'FontName', 'Times','FontSize', 8)
ylim([0 5]);

% Bottom plot
ax3 = nexttile;
plot(ax3,1e-3*inputs.thrust,'b')
h_axes = gca;
h_axes.YAxis.FontSize = 8;
h_axes.YAxis.FontName = 'Times';
h_axes.XAxis.FontSize = 8;
h_axes.XAxis.FontName = 'Times';
ylabel(ax3,{'Thrust','[kN]'},'FontName', 'Times','FontSize', 8)
ylim([0 10]);
xlabel(t,'Time [s]','FontName', 'Times','FontSize', 10)

% Move plots closer together
xticklabels(ax1,{})
xticklabels(ax2,{})
t.TileSpacing = 'compact';

filename_png = [dir, '\',filename1,'.png'];
saveas(gcf, filename_png);
filename_emf = [dir, '\',filename1,'.emf'];
saveas(gcf, filename_emf);
close(1)

end