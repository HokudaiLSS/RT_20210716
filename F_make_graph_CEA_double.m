function  F_make_graph_CEA_double(filename, cstar, inputs)
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

x(1,:) = [0.5:0.1:10];
y(1,:) = inputs.database_CEA.velocity_characteristicexhaust.value(:,6);
yy(1,:) =cstar(:,6);
for i=1:1:96
  r(1,i) = y(1,i)*(1+1/x(1,i));
  rr(1,i) = yy(1,i)*(1+1/x(1,i));
end

t = tiledlayout(2,1); % Requires R2019b or later

% Top plot
ax1 = nexttile;
h1=plot(ax1,x,y,'b','LineWidth',3);
hold on
 h2=plot(ax1,x,yy,'k','LineWidth',2);
hold off
h_axes = gca;
h_axes.YAxis.FontSize = 10;
h_axes.YAxis.FontName = 'Times';
ylabel({'{\it c^*} [m/s]'},'FontName', 'Times','FontSize', 12)
legend([h1,h2],'modified CEA','original CEA', 'FontName', 'Times','FontSize', 10)
% Bottom plot
ax2 = nexttile;
plot(ax2,x,r,'b','LineWidth',3)
hold on
plot(ax2,x,rr,'k','LineWidth',2)
yline(2720.575,'--k')
yline(2577.3,'--k')
xline(0.9,'--k')
xline(2.25,'--k')
hold off
h_axes = gca;
h_axes.YAxis.FontSize = 10;
h_axes.YAxis.FontName = 'Times';
h_axes.XAxis.FontSize = 10;
h_axes.XAxis.FontName = 'Times';
ylabel('{\it c^{*}}(1+1/({\it O/F}) [m/s]','FontName', 'Times','FontSize', 12)
ylim([1500 3500]);
xlabel(ax2,'{\it O/F} [-]','FontName', 'Times','FontSize', 12)

% Move plots closer together
xticklabels(ax1,{})
%xticklabels(ax2,{})
t.TileSpacing = 'compact';

filename_png = [dir, '\',filename1,'.png'];
saveas(gcf, filename_png);
filename_emf = [dir, '\',filename1,'.emf'];
saveas(gcf, filename_emf);

filename_PDF= [dir, '\',filename1];
F_SaveFig(figure(1), filename_PDF)
close(1)

end