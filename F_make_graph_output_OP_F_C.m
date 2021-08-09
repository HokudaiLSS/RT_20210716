function  F_make_graph_output_OP_F_C(filename, outputs_PRTM,OF_lim)
dir=('graph');
mkdir(dir);
% outputs.counter_bisectioniteration = i;
% outputs.efficiency_combustion = estar;
% outputs.mass_fuelconsumption = mfucal;
% outputs.mass_fuelconsumption_history = mfuhistory;
% outputs.massflowrate_fuel = mdotfu;
% outputs.massflowrate_propellant = mdotp;
% outputs.ratio_oxidizertofuelmass = OF;
% outputs.residual_bisectioniteration = Psitracker;
% outputs.value_bisectioniteration = estartracker;
% outputs.velocity_characteristicexhaust = cstar;


filename1 = ['graph_',filename];
figure(1)
% set(gca, 'FontName', 'Times','Color','white', 'FontSize', 12);

t = tiledlayout(2,1); % Requires R2019b or later

% Top plot
ax1 = nexttile;
plot(ax1,outputs_PRTM.time, outputs_PRTM.mass_fuelconsumption,'k')
yline(outputs_PRTM.mass_fuelconsumption,'--k')
hold on
%time=1:1:7;
% Mass_Fuel = cumtrapz(outputs_PRTM.massflowrate_fuel);

plot(ax1,outputs_PRTM.time,outputs_PRTM.mass_fuelconsumption_history,'k')
hold off
h_axes = gca;
h_axes.YAxis.FontSize = 8;
h_axes.YAxis.FontName = 'Times';
ylabel(ax1,{'Fuel mass consnpution','[kg]'},'FontName', 'Times','FontSize', 8)
ylim([0 outputs_PRTM.mass_fuelconsumption*1.1]);

% Bottom plot
ax2 = nexttile;
plot(ax2,outputs_PRTM.time, outputs_PRTM.ratio_oxidizertofuelmass,'k')
h_axes = gca;
h_axes.YAxis.FontSize = 8;
h_axes.YAxis.FontName = 'Times';
h_axes.XAxis.FontSize = 8;
h_axes.XAxis.FontName = 'Times';
ylabel(ax2,{'O/F','[-]'},'FontName', 'Times','FontSize', 8)
ylim([0 OF_lim]);
xlabel(t,'Time [s]','FontName', 'Times','FontSize', 10)

% Move plots closer together
xticklabels(ax1,{})
%xticklabels(ax2,{})
t.TileSpacing = 'compact';

filename_png = [dir, '\',filename1,'.png'];
saveas(gcf, filename_png);
filename_emf = [dir, '\',filename1,'.emf'];
saveas(gcf, filename_emf);
close(1)

end