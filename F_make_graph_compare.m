function  F_make_graph_compare(filename,OF_lim, time, OF1, OF2, OF3, OF4, OF5, OF6, OF7)
dir=('graph');
mkdir(dir);
% time : burn time
% OF1 :  inputs.OF
% OF2 :  OP_F_C
% OF3 :  OP_F_CE
% OF4 :  PRTM
% OF5 :  TRTEM
% OF6 :  PRTM_modified
% OF7 :  TRTEM_modified

filename1 = ['graph_',filename];
figure(1)

plot(time, OF1,'k','LineWidth',8);
hold on
 plot(time, OF2,'c','LineWidth',4);
 plot(time, OF3,'m','LineWidth',2);
 plot(time, OF4,'r');
 plot(time, OF5,'b');
 plot(time, OF6,'--r','LineWidth',2);
 plot(time, OF7,'--b','LineWidth',2);
 legend('simulated','OPMA-F-C','OPMA-F-CE','OPMA-F-E','OPTMA-FE-L','OPMA-F-E (modified CEA)','OPTMA-FE-L (modified CEA)','FontName', 'Times','FontSize', 10)
hold off
h_axes = gca;
h_axes.YAxis.FontSize = 12;
h_axes.YAxis.FontName = 'Times';
ylabel({'Oxidizer to fuel mass ratio,','{\it O/F} [-]'},'FontName', 'Times','FontSize', 15)
ylim([0 OF_lim]);

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