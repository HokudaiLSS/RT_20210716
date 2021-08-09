function  F_make_graph_compare_eta(filename, eta_lim, time, eta1, eta2, eta3, eta4, eta5, eta6)
dir=('graph');
mkdir(dir);
% time : burn time
% OF1 :  inputs.OF
% OF2 :  OP_F_C
% OF3 :  OP_F_CE
% OF4 :  PRTM
% OF5 :  TRTEM

filename1 = ['graph_',filename];
figure(1)
 h1=plot(time, eta1,'k','LineWidth',6);
hold on
 h2=yline(eta2, 'm','LineWidth',2);
 h3=yline(eta3, 'r');
 h4=plot(time, eta4,'b','LineWidth',4);
 h5=yline(eta5, '--r','LineWidth',2);
 h6=plot(time, eta6,'--b','LineWidth',4);
 %g = get(gca);
 %g.Children
 %newh = [h4 h3 h2 h1];
 %set(gca,'Children',[g.Children(2) g.Children(1) g.Children(3) g.Children(4)]);
 legend([h1,h2,h3,h4,h5,h6],'simulated','OPMA-F-CE','OPMA-F-C','OPTMA-FE-L','OPMA-F-C (modified CEA)','OPTMA-FE-L (modified CEA)','FontName', 'Times','FontSize', 10)
hold off

h_axes = gca;
h_axes.YAxis.FontSize = 12;
h_axes.YAxis.FontName = 'Times';
ylabel({'Efficiency of {\it c}^{*},','{\it \eta_{c^{*}}} [-]'},'FontName', 'Times','FontSize', 15)
ylim([0.65 eta_lim]);

h_axes = gca;
h_axes.XAxis.FontSize = 12;
h_axes.XAxis.FontName = 'Times';
xlabel('Time [s]','FontName', 'Times','FontSize', 15)


filename_png = [dir, '\',filename1,'.png'];
saveas(gcf, filename_png);
filename_emf = [dir, '\',filename1,'.emf'];
saveas(gcf, filename_emf);

filename_PDF= [dir, '\',filename1];
F_SaveFig(figure(1), filename_PDF)
close(1)

end