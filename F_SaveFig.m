function F_SaveFig(fig, filename)
%
% SaveFig(fig, filename)
%
% 引数figに指定されたfigureをfilenameの名前のpng,pdfファイルで保存する。
% filenameは拡張子をつけない。
%
% 例：SaveFig(figure(1),'example')

% 終わってない描画処理があったら終わらせる
drawnow;

% 紙のサイズを変える。
temp.figunit = fig.Units;
fig.Units = 'centimeters';
pos = fig.Position;
fig.PaperPositionMode = 'Auto';
temp.figpaperunit = fig.PaperUnits;
fig.PaperUnits = 'centimeters';
temp.figsize = fig.PaperSize;
fig.PaperSize = [pos(3), pos(4)];

% 保存する。
print(fig,filename,'-dpdf','-r300','-bestfit')
print(fig,filename,'-dpng','-r300')

% 設定を元に戻す。
fig.PaperSize = temp.figsize;
fig.Units = temp.figunit;
fig.PaperUnits = temp.figpaperunit;

end