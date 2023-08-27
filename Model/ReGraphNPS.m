% function[]=ReGraph(GenNol,LoadNol,ENSNol,OverChargeNol,GenNmin,LoadNmin,ENSNmin,OverChargeNmin,GenNmax,LoadNmax,ENSNmax,OverChargeNmax)
% [lf]=readLoadNfactor(lftype);
close all
ntime=length(lf.MT(:,1));
 t=1:ntime;
 
 %% F1
% subplot(2,2,1)
 F5=figure;
 print('djpg','-r800');
plot(t,LoadNol,t,LoadNmin,t,LoadNmax,'g');
lgd=legend({'Only Load scenario','Minimun EV Charge Load Scenario','Maximun EV charge Load Scenario'},'location','southeast');
lgd.FontSize=8;
title('Load in all scenarios for New Power System');
xlabel('time 1/2 h');
ylabel('MW');
FTxt1=strcat(savefilename,'NPSF1.jpg');
saveas(F5,FTxt1);

%% F2
% subplot(2,2,2)
 F6=figure;
 print('djpg','-r800');
plot(t,GenNol,'b',t,LoadNol,'k',t,ENSNol,'r',t,OverChargeNol,'g');
title('Only Load, without EV charging for New Power System')
lgd1=legend({'Generation','Load','Energy Not Served','OverCharge'},'location','east');
lgd1.FontSize=8;
xlabel('time 1/2 h');
ylabel('MW');
FTxt2=strcat(savefilename,'NPSF2.jpg');
saveas(F6,FTxt2);

%% F3
% subplot(2,2,3)
 F7=figure;
 print('djpg','-r800');
plot(t,GenNmin,'b',t,LoadNmin,'k',t,ENSNmin,'r',t,OverChargeNmin,'g');
title('Load and minimun EV charging Load for New Power System');
lgd2=legend({'Generation','Load','Energy Not Served','Overcharge'},'location','east');
lgd2.FontSize=8;
xlabel('time 1/2 h');
ylabel('MW');
FTxt3=strcat(savefilename,'NPSF3.jpg');
saveas(F7,FTxt3);

%% F4
% subplot(2,2,4)
 F8=figure;
 print('djpg','-r800');
plot(t,GenNmax,'b',t,LoadNmax,'k',t,ENSNmax,'r',t,OverChargeNmax,'g');
title('Load and maximun EV charging Load for New Power System');
lgd3=legend({'Generation','Load','Energy Not Served','Overcharge'},'location','east');
lgd3.FontSize=8;
xlabel('time 1/2 h');
ylabel('MW');
FTxt4=strcat(savefilename,'NPSF4.jpg');
saveas(F8,FTxt4);
movefile(FTxt1,savefileNname,'f');
movefile(FTxt2,savefileNname,'f');
movefile(FTxt3,savefileNname,'f');
movefile(FTxt4,savefileNname,'f');