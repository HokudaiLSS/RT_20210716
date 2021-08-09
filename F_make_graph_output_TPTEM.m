function  F_make_graph_output_TPTEM(filename, outputs_TRTEM,OF_lim)
dir=('graph');
mkdir(dir);
% outputs.area_exit = Ae;
% outputs.area_throat = At;
% outputs.coefficient_thrust = CF;
% outputs.counter_bisectioniteration = i;
% outputs.efficiency_combustion = estar;
% outputs.efficiency_thrust = eF;
% outputs.mass_fuelconsumption = mfucal;
% outputs.mass_fuelconsumptionhistory = mfuhistory;
% outputs.massflowrate_fuel = mdotfu;
% outputs.massflowrate_propellant = mdotp;
% outputs.pressure_exit = Pe;
% outputs.ratio_oxidizertofuelmass = OF;
% outputs.residual_bisectioniteration = Psitracker;
% outputs.specificimpulse = Isp;
% outputs.value_bisectioniteration = eFtracker;
% outputs.velocity_characteristicexhaust = cstar;
% outputs.velocity_effectiveexhaust = ueff;
% outputs.velocity_exit = ue;


filename1 = ['graph_',filename];
figure(1)
% set(gca, 'FontName', 'Times','Color','white', 'FontSize', 12);

t = tiledlayout(3,1); % Requires R2019b or later

% Top plot
ax1 = nexttile;
plot(ax1, outputs_TRTEM.time, outputs_TRTEM.efficiency_combustion,'k');
h_axes = gca;
h_axes.YAxis.FontSize = 8;
h_axes.YAxis.FontName = 'Times';
ylabel(ax1,{'Efficiency of cstar','[-]'},'FontName', 'Times','FontSize', 8)
ylim([0 1.2]);

% Middle plot
ax2 = nexttile;
plot(ax2, outputs_TRTEM.time,outputs_TRTEM.mass_fuelconsumption,'k')
yline(outputs_TRTEM.mass_fuelconsumption,'--k')
hold on
plot(ax2, outputs_TRTEM.time,outputs_TRTEM.mass_fuelconsumptionhistory,'k')
hold off
h_axes = gca;
h_axes.YAxis.FontSize = 8;
h_axes.YAxis.FontName = 'Times';
ylabel(ax2,{'Fuel mass consnpution','[kg]'},'FontName', 'Times','FontSize', 8)
ylim([0 outputs_TRTEM.mass_fuelconsumption*1.1]);

% Bottom plot
ax3 = nexttile;
plot(ax3, outputs_TRTEM.time,outputs_TRTEM.ratio_oxidizertofuelmass,'k')
h_axes = gca;
h_axes.YAxis.FontSize = 8;
h_axes.YAxis.FontName = 'Times';
h_axes.XAxis.FontSize = 8;
h_axes.XAxis.FontName = 'Times';
ylabel(ax3,{'O/F','[-]'},'FontName', 'Times','FontSize', 8)
ylim([0 OF_lim]);
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