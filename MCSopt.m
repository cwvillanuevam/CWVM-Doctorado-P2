function [MCSmin,lmin,MCSq1,MCSmean,MCSq3,MCSmax,lmax,UCf,TScf]=MCSopt(PStype,Ns,T,V,savingdir,BUS,lf)
[Title,BUS,BRANCH]=readcdf2(PStype); %reading power system data (psd)
stocdata; %Reading mean stochastic data
nbus=length(BUS.NumBus(:,1));
cd(pwd);
%% Time traveling distribution
% Reading departure and arriving home characteristic data.
dep=xlsread('evs dist charact.xlsx','Resumen','B2:B57','basic'); %Departure time
arr=xlsread('evs dist charact.xlsx','Resumen','D2:D57','basic'); %Arrive time
tconv=xlsread('evs dist charact.xlsx','Resumen','H2:H57','basic'); % Time conversion [1-48]
depdist=zeros(10000,1);
depind=1;
arrdist=zeros(10000,1);
arrind=1;
for i=1:56
    if dep(i,1)==0
    else
        for j=1:round(dep(i,1))
         depdist(depind,1)=tconv(i,1);
         depind=depind+1;
        end
    end
    if arr(i,1)==0
    else
        for k=1:round(arr(i,1))
         arrdist(arrind,1)=tconv(i,1);
         arrind=arrind+1;
        end
    end
end
if depind==10001
else
    fprintf('There was a critical error in depleture data, please fix it and try again \n');
end
if arrind==10001
else
    fprintf('There was a critical error in arrive data, please fix it and try again \n');
end
pddep=fitdist(depdist,'normal');
pdarr=fitdist(arrdist,'normal');

 rng shuffle;
 %% Starting the sample proccess in MonteCarlo Simulation
UCf=zeros(Ns,T,nbus);
ChL=zeros(Ns,1);
TScf=zeros(Ns,V,2);
mL=zeros(Ns,1);
for s=1:Ns
    fprintf('\nSample=%d',s);
    rng('shuffle')
    [R,X,UC,TSc]=mksample(PStype,pddep,pdarr,T,V);
    Rtype=strcat('R_s',num2str(s),'.txt');
    Xtype=strcat('X_s',num2str(s),'.txt');
    TStype=strcat('TS_s',num2str(s),'.txt');
    Rprint=fopen(Rtype,'w');
    Xprint=fopen(Xtype,'w');
    TSprint=fopen(TStype,'w');
    chargeload=0;

    fprintf(Rprint,'Road energy needed [KWh] per t=%1.2f hour, for sample %d',24/T,s);
    fprintf(Xprint,'X binary variable indicating that in t=%1.2f hour vehicle is on road, for sample %d',24/T,s);
    fprintf(TSprint,'TS travel state indicating bus from and bus to for each vehicle');
    fprintf(Rprint,'\nV:  ');
    fprintf(Xprint,'\nV:  ');
    fprintf(TSprint,'\nV:  \tFrom: \t To:');
    for t=1:T
        fprintf(Rprint,' t: %2d ',t);
        fprintf(Xprint,'t: %2d',t);
    end
    for v=1:V
        TScf(s,v,1)=TSc(v,1);
        TScf(s,v,2)=TSc(v,2);
        
        fprintf(Rprint,'\n %2d ',v);
        fprintf(Xprint,'\n %2d ',v);
        fprintf(TSprint,'\n %2d %2d %2d ',v,TSc(v,1),TSc(v,2));
        for t=1:T
            %Rf(s,t,v)=R(t,v);
            %Xf(s,t,v)=X(t,v);
            fprintf(Rprint,' %3.2f',R(t,v)*1000);
            fprintf(Xprint,'  %1d  ',X(t,v));
            for n=1:nbus
            chargeload=chargeload+UC(t,v,n);
            UCf(s,t,n)=UCf(s,t,n)+UC(t,v,n);
            end
        end
    end
    for t=1:T
        Ltemp=0;
        for n=1:nbus
            for v=1:V
                Ltemp=Ltemp+UC(t,v,n);
            end
            Ltemp=Ltemp+BUS.PCarBus(n,1)*lf.MT(t,1);
        end
        if mL(s)<Ltemp
            mL(s)=Ltemp;
        end
    end
    ChL(s,1)=chargeload;
    fclose(Rprint);
    fclose(Xprint);
    fclose(TSprint);
%% moving R and X files
movefile(Rtype,savingdir)
movefile(Xtype,savingdir)
movefile(TStype,savingdir)
end

%% Analizing the sample characterization for Charge Load.
[MCSmin,lmin]=min(mL);
[MCSmax,lmax]=max(mL);
MCSq1=quantile(ChL,0.25);
MCSmean=quantile(ChL,0.5);
MCSq3=quantile(ChL,0.75);
end