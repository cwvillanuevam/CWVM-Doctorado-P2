% function[]=ReGraph(Genol,Loadol,ENSol,OverChargeol,Genmin,Loadmin,ENSmin,OverChargemin,Genmax,Loadmax,ENSmax,OverChargemax)
% [lf]=readloadfactor(lftype);
close all
ntime=length(lf.MT(:,1));
 t=1:ntime;

 %% F1
% subplot(2,2,1)
 F5=figure;
 print('djpg','-r800');
plot(t,Loadol,t,Loadmin,t,Loadmax,'g');
lgd=legend({'Only Load scenario','Minimun EV Charge Load Scenario','Maximun EV charge Load Scenario'},'location','southeast');
lgd.FontSize=8;
title('Load in all scenarios');
xlabel('time 1/2 h');
ylabel('MW');
FTxt1=strcat(savefilename,'PSF1.jpg');
saveas(F5,FTxt1);

%% F2
% subplot(2,2,2)
 F6=figure;
 print('djpg','-r800');
plot(t,Genol,'b',t,Loadol,'k',t,ENSol,'r',t,OverChargeol,'g');
title('Only Load, without EV charging')
lgd1=legend({'Generation','Load','Not Served Energy','Overcharge'},'location','east');
lgd1.FontSize=8;
xlabel('time 1/2 h');
ylabel('MW');
FTxt2=strcat(savefilename,'PSF2.jpg');
saveas(F6,FTxt2);

%% F3
% subplot(2,2,3)
 F7=figure;
 print('djpg','-r800');
plot(t,Genmin,'b',t,Loadmin,'k',t,ENSmin,'r',t,OverChargemin,'g');
title('Load and minimun EV charging Load');
lgd2=legend({'Generation','Load','Not Served Energy','Overcharge'},'location','east');
lgd2.FontSize=8;
xlabel('time 1/2 h');
ylabel('MW');
FTxt3=strcat(savefilename,'PSF3.jpg');
saveas(F7,FTxt3);

%% F4
% subplot(2,2,4)
 F8=figure;
 print('djpg','-r800');
plot(t,Genmax,'b',t,Loadmax,'k',t,ENSmax,'r',t,OverChargemax,'g');
title('Load and maximun EV charging Load');
lgd3=legend({'Generation','Load','Not Served Energy','Overcharge'},'location','east');
lgd3.FontSize=8;
xlabel('time 1/2 h');
ylabel('MW');
FTxt4=strcat(savefilename,'PSF4.jpg');
saveas(F8,FTxt4);
movefile(FTxt1,savefilename,'f');
movefile(FTxt2,savefilename,'f');
movefile(FTxt3,savefilename,'f');
movefile(FTxt4,savefilename,'f');