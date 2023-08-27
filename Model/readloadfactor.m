function [lf]=readloadfactor(lftype)
%% Read the data of load factor of MT and BT
MTlf = xlsread(strcat(lftype,'.xlsx'), 'MT', 'B1:B96','basic');
BTlf = xlsread(strcat(lftype,'.xlsx'), 'BT', 'B1:B96','basic');
lf.MT=MTlf;
lf.BT=BTlf;
fclose all
end