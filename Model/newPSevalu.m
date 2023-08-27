function [GenNol,GenNmin,GenNmax,LoadNol,LoadNmin,LoadNmax,ENSNol,ENSNmin,ENSNmax,OverChargeNol,OverChargeNmin,OverChargeNmax,savefileNname]=newPSevalu(lftype,Ns,T,V,savefilename,MCSmin,MCSq1,MCSmean,MCSq3,MCSmax,lf,UCf,lmin,lmax,TScf,Ymatriz,BUS,BRANCH,Title,NPgen,lnpgen)
%% This script set the input data run the optimizer and set the output
%Define the previous parametric data
nbus=length(BUS.NumBus(:,1));
nbr=length(BRANCH.NumIniRam(:,1));

%% Start setting sets in in.gdx
% Define all related bus sets
nbusset.name='nbus';
nbusset.uels={1:nbus};

nbusPV=[];
nbusPQ=[];
nbusSlack=[];
PQindex=1;
PVindex=1;
Slackindex=1;
for n=1:nbus
    if n==lnpgen
       BUS.TipoBus(n)=2;
       BUS.PGenBus(n,1)=BUS.PGenBus(n,1)+NPgen;
    end
    if BUS.TipoBus(n)==0
        nbusPQ(1,PQindex)=n;
        PQindex=PQindex+1;
    elseif BUS.TipoBus(n)==2
        nbusPV(1,PVindex)=n;
        PVindex=PVindex+1;
    else
        nbusSlack(1,Slackindex)=n;
        nbusPV(1,PVindex)=n;
        PVindex=PVindex+1;
        Slackindex=Slackindex+1;
    end
end
nbusPQset.name='nbusPQ';
nbusPQset.uels={nbusPQ};
nbusPVset.name='nbusPV';
nbusPVset.uels={nbusPV};
nbusSlackset.name='nbusSlack';
nbusSlackset.uels={nbusSlack};

% Define all related Branch Sets
nlinesset.name='nlines';
nlinesset.uels={1:nbr};

guel = @(s,v) strcat(s,strsplit(num2str(v)));
nll=zeros(nbr,2);
nrl=zeros(nbr,2);
limSval=ones(nbr,1);
for l=1:nbr
    nrl(l,1)=l;
    nrl(l,2)=BRANCH.NumIniRam(l,1);
    nll(l,1)=l;
    nll(l,2)=BRANCH.NumFinRam(l,1);
    limSval(l)=BRANCH.MVANormNorRam(l,1);
end

nrset.name='nrl';
nrset.type='set';
nrset.dim=2;
nrset.form='sparse';
nrset.uels={guel('',1:nbr),guel('',1:nbus)};
nrset.val=nrl;

nlset.name='nll';
nlset.type='set';
nlset.dim=2;
nlset.form='sparse';
nlset.uels={guel('',1:nbr),guel('',1:nbus)};
nlset.val=nll;

%% Start setting variables in in.gdx
% 
% basemvas.name='basemva';
% basemvas.val=Title.baseMVA;
% basemvas.form='full';
% basemvas.type='scalar';

limSs.name='limS';
limSs.val=limSval;
limSs.form='full';
limSs.type='parameter';
limSs.uels=nlinesset.uels;

% [Ymatriz]=Ymat(PStypenew);

Yms.name='Ym';
Yms.val=Ymatriz.Ym;
Yms.form='full';
Yms.type='parameter';
Yms.uels={nbusset.uels nbusset.uels};

ts.name='t';
ts.val=Ymatriz.Yt;
ts.form='full';
ts.type='parameter';
ts.uels={nbusset.uels nbusset.uels};

Vupval=zeros(nbus,1);
Vloval=zeros(nbus,1);
Vmlval=zeros(nbus,1);
deltaupval=zeros(nbus,1);
deltaloval=zeros(nbus,1);
deltalval=zeros(nbus,1);
Pgloval=zeros(nbus,1);
Pgupval=zeros(nbus,1);
Pglval=zeros(nbus,1);
Qgupval=zeros(nbus,1);
Qgloval=zeros(nbus,1);
Qglval=zeros(nbus,1);
PENSloval=zeros(nbus,1);
PENSlval=zeros(nbus,1);
for n=1:nbus
Vupval(n)=1.05;
Vloval(n)=0.95;
Vmlval(n)=BUS.VFinBus(n,1);
deltaloval(n)=-pi()/2;
deltaupval(n)=pi()/2;
deltalval(n)=pi()/180*BUS.ThFinBus(n,1);
Pgloval(n)=0;
Pgupval(n)=BUS.PGenBus(n,1);
Pglval(n)=BUS.PGenBus(n,1);
Qgupval(n)=BUS.QGenMaxBus(n,1);
Qgloval(n)=BUS.QGenMinBus(n,1);
Qglval(n)=BUS.QGenBus(n,1);
end

vups.name='Vup';
vups.val=Vupval;
vups.form='full';
vups.type='parameter';
vups.uels=nbusset.uels;

vlos.name='Vlo';
vlos.val=Vloval;
vlos.form='full';
vlos.type='parameter';
vlos.uels=nbusset.uels;

vmls.name='Vml';
vmls.val=Vmlval;
vmls.form='full';
vmls.type='parameter';
vmls.uels=nbusset.uels;

deltaups.name='deltaup';
deltaups.val=deltaupval;
deltaups.form='full';
deltaups.type='parameter';
deltaups.uels=nbusset.uels;

deltalos.name='deltalo';
deltalos.val=deltaloval;
deltalos.form='full';
deltalos.type='parameter';
deltalos.uels=nbusset.uels;

deltals.name='deltal';
deltals.val=deltalval;
deltals.form='full';
deltals.type='parameter';
deltals.uels=nbusset.uels;

Pgups.name='Pgup';
Pgups.val=Pgupval;
Pgups.form='full';
Pgups.type='parameter';
Pgups.uels=nbusset.uels;

Pglos.name='Pglo';
Pglos.val=Pgloval;
Pglos.form='full';
Pglos.type='parameter';
Pglos.uels=nbusset.uels;

Pgls.name='Pgl';
Pgls.val=Pglval;
Pgls.form='full';
Pgls.type='parameter';
Pgls.uels=nbusset.uels;

Qgups.name='Qgup';
Qgups.val=Qgupval;
Qgups.form='full';
Qgups.type='parameter';
Qgups.uels=nbusset.uels;

Qglos.name='Qglo';
Qglos.val=Qgloval;
Qglos.form='full';
Qglos.type='parameter';
Qglos.uels=nbusset.uels;

Qgls.name='Qgl';
Qgls.val=Qglval;
Qgls.form='full';
Qgls.type='parameter';
Qgls.uels=nbusset.uels;

PENSlos.name='PENSlo';
PENSlos.val=PENSloval;
PENSlos.form='full';
PENSlos.type='parameter';
PENSlos.uels=nbusset.uels;

PENSls.name='PENSl';
PENSls.val=PENSlval;
PENSls.form='full';
PENSls.type='parameter';
PENSls.uels=nbusset.uels;

% [lf]=readloadfactor(lftype);
ntime=length(lf.MT(:,1));


GenNol=zeros(ntime,1);
LoadNol=zeros(ntime,1);
ENSNol=zeros(ntime,1);
OverChargeNol=zeros(ntime,1);

%% Seteamos el nombre del archivo txt de resultados
Type=Title.case;
savingtxt=strcat(Type,'NewPSvalidacion.txt');
savingdir=strcat(Type,'NewPSvalidacion');
version=1;
while exist(savingdir,'file')==7 || exist(savingdir,'file')==2 
    savingtxt=strcat(Type,'NewPSvalidacion','v',num2str(version),'.txt');
    savingdir=strcat(Type,'NewPSvalidacion','v',num2str(version));
    version=version+1;
end
cd(pwd);
%% Relicability from only load
fresNPS=fopen(savingtxt,'w');
fprintf(fresNPS,'Resultados de la optimizacion para el nuevo sistema de potencia solo carga sin EVs\n');

%% Now set time dependent variables for only load modelling

for t=1:ntime
    Pdval=zeros(nbus,1);
    Qdval=zeros(nbus,1);
    PENSupval=zeros(nbus,1);
for n=1:nbus
    if BUS.AreaFCBus(n,1)==1
        Pdval(n)=BUS.PCarBus(n,1)*lf.MT(t,1);
        Qdval(n)=BUS.QCarBus(n,1)*lf.MT(t,1);
    else
        Pdval(n)=BUS.PCarBus(n,1)*lf.BT(t,1);
        Qdval(n)=BUS.QCarBus(n,1)*lf.BT(t,1);
    end
    PENSupval(n)=Pdval(n);
end

Pds.name='Pd';
Pds.val=Pdval;
Pds.form='full';
Pds.type='parameter';
Pds.uels=nbusset.uels;

Qds.name='Qd';
Qds.val=Qdval;
Qds.form='full';
Qds.type='parameter';
Qds.uels=nbusset.uels;

PENSups.name='PENSup';
PENSups.val=PENSupval;
PENSups.form='full';
PENSups.type='parameter';
PENSups.uels=nbusset.uels;

OType='out.gdx';
if exist(OType,'file')==2
   r1s.name='Vm';
   r1s.form='sparse';
   r1=rgdx('out.gdx',r1s);
   Vmlval=r1.val(:,2);

   r2s.name='delta';
   r2s.form='sparse';
   r2=rgdx('out.gdx',r2s);
   deltalval=r2.val(:,2);

else
    [Vmlval,deltalval]=FlatStart(BUS);
end
vmls.val=Vmlval;
deltals.val=deltalval;

 wgdx('in',nbusset,nbusPVset,nbusPQset,nbusSlackset,nlinesset,nrset,nlset,...
 Yms,ts,vups,vlos,vmls,deltaups,deltalos,deltals,Pgups,Pglos,Pgls,Qgups,...
 Qglos,Qgls,limSs,Pds,Qds,PENSups,PENSlos,PENSls);
%,basemvas,tiops
system 'gams opf.gms lo=0';
if ans==0
else
    for n=1:nbus
        Vmlval(n)=BUS.VFinBus(n,1);
        deltaloval(n)=-pi()/2;
        deltaupval(n)=pi()/2;
        deltalval(n)=pi()/180*BUS.ThFinBus(n,1);
    end
    vmls.val=Vmlval;
    deltals.val=deltalval;
 
    
 wgdx('in',nbusset,nbusPVset,nbusPQset,nbusSlackset,nlinesset,nrset,nlset,...
 Yms,ts,vups,vlos,vmls,deltaups,deltalos,deltals,Pgups,Pglos,Pgls,Qgups,...
 Qglos,Qgls,limSs,Pds,Qds,PENSups,PENSlos,PENSls);
%,basemvas,tiops
system 'gams opf.gms lo=0';
end
r1s.name='F';
r1s.form='full';
r1=rgdx('out.gdx',r1s);
cvol=r1.val;

r2s.name='Vm';
r2s.form='full';
r2=rgdx('out.gdx',r2s);
Vmol=r2.val;

r3s.name='delta';
r3s.form='full';
r3=rgdx('out.gdx',r3s);
deltaol=r3.val;

r4s.name='Pg';
r4s.form='full';
r4=rgdx('out.gdx',r4s);
Pgol=r4.val;

r5s.name='Qg';
r5s.form='full';
r5=rgdx('out.gdx',r5s);
Qgol=r5.val;

r6s.name='OChFrom';
r6s.form='full';
r6=rgdx('out.gdx',r6s);
OChFromol=r6.val;

r7s.name='OChTo';
r7s.form='full';
r7=rgdx('out.gdx',r7s);
OChTool=r7.val;

r8s.name='PENS';
r8s.form='full';
r8=rgdx('out.gdx',r8s);
PENSol=r8.val;

r9s.name='Pd';
r9s.form='full';
r9=rgdx('out.gdx',r9s);
Pdol=r9.val;

r10s.name='Qd';
r10s.form='full';
r10=rgdx('out.gdx',r10s);
Qdol=r10.val;
GenNol(t)=sum(Pgol);
LoadNol(t)=sum(Pdol);
ENSNol(t)=sum(PENSol);

for l=1:nbr
if OChFromol(l)<OChTool(l)
    OChol(l)=OChTool(l);
else
    OChol(l)=OChFromol(l);
end
Ochgol(t,l)=OChol(l);
end
for n=1:nbus
    Gengol(t,n)=Pgol(n);
    Logol(t,n)=Pdol(n);
    ENSgol(t,n)=PENSol(n);
end
OverChargeNol(t)=sum(OChol);
% Running opf again if some temporary point runs bad the opf proccess
opfolNite=1;
fprintf('\nt:%d',t);
while opfolNite<=2
[GenNgoltemp,LoadNgoltemp,ENSNgoltemp,GenNol,LoadNol,ENSNol,OverChargeNol,savingtxttemp]=GrCorrOL(GenNol,LoadNol,ENSNol,OverChargeNol,lf,BUS,BRANCH,Title,UCf,t,savingdir,Ymatriz,1);
for n=1:nbus
    Gengol(t,n)=GenNgoltemp(n);
    Logol(t,n)=LoadNgoltemp(n);
    ENSgol(t,n)=ENSNgoltemp(n);
end
opfolNite=opfolNite+1;
% fprintf('ite:%d',opfolNite);
end
while GenNol(t)==sum(BUS.PGenBus(:,1))&&opfolNite<=6
[GenNgoltemp,LoadNgoltemp,ENSNgoltemp,GenNol,LoadNol,ENSNol,OverChargeNol,savingtxttemp]=GrCorrOL(GenNol,LoadNol,ENSNol,OverChargeNol,lf,BUS,BRANCH,Title,UCf,t,savingdir,Ymatriz,1);
for n=1:nbus
    Gengol(t,n)=GenNgoltemp(n);
    Logol(t,n)=LoadNgoltemp(n);
    ENSgol(t,n)=ENSNgoltemp(n);
end
opfolNite=opfolNite+1
fprintf('ite:%d',opfolNite);
end
%Defining bad as less than usual
if t==1
    losteval=0.6;
    lossprev=GenNol(t)-LoadNol(t);
else
    lossprev=GenNol(t-1)-LoadNol(t-1);
    lossact=GenNol(t)-LoadNol(t);
    losteval=lossact/lossprev;
end
while (losteval<=0.75||losteval>=1.25)&&opfolNite<=6
[GenNgoltemp,LoadNgoltemp,ENSNgoltemp,GenNol,LoadNol,ENSNol,OverChargeNol,savingtxttemp]=GrCorrOL(GenNol,LoadNol,ENSNol,OverChargeNol,lf,BUS,BRANCH,Title,UCf,t,savingdir,Ymatriz,1);
for n=1:nbus
    Gengol(t,n)=GenNgoltemp(n);
    Logol(t,n)=LoadNgoltemp(n);
    ENSgol(t,n)=ENSNgoltemp(n);
end
    lossact=GenNol(t)-LoadNol(t);
    losteval=lossact/lossprev;
    fprintf('New PS ol,t:%d',t);
opfolNite=opfolNite+1
fprintf('ite:%d',opfolNite);
end
% Define outputs
fprintf(fresNPS,'t= %d \t ',t);
fprintf(fresNPS,'Pg=%8.4f \t Pd=%8.4f \t ENS= %6.2f \t OverCharge= %6.2f\n',...
    GenNol(t),LoadNol(t),ENSNol(t),OverChargeNol(t));
end
fprintf(fresNPS,'Overcharge general \n Line:');
for l=1:nbr
    fprintf(fresNPS,'\t %6d',l);
end
for t=1:ntime
    fprintf(fresNPS,'\n t: \t %d',t);
   for l=1:nbr
fprintf(fresNPS,'\t %6.2f',Ochgol(t,l));
   end
end
fprintf(fresNPS,'Power Generation general \n Bus:');
for n=1:nbus
    fprintf(fresNPS,'\t %6d',n);
end
for t=1:ntime
    fprintf(fresNPS,'\n t: \t %d',t);
   for n=1:nbus
fprintf(fresNPS,'\t %6.2f',Gengol(t,n));
   end
end

%[MCSmin,lmin,MCSq1,MCSmean,MCSq3,MCSmax,lmax,Rf,Xf,UCf,TScf]=MCSopt(PStype,Ns,T,V);

%% Replicability from only load min for new Power System
fprintf(fresNPS,'Resultados de la optimizacion minima carga requerida para el nuevo Sistema de Potencia\n');

%% Now set time dependent variables for only load modelling

for t=1:ntime
    Pdval=zeros(nbus,1);
    Qdval=zeros(nbus,1);
    PENSupval=zeros(nbus,1);
for n=1:nbus
    if BUS.AreaFCBus(n,1)==1
        Pdval(n)=BUS.PCarBus(n,1)*lf.MT(t,1)+sum(UCf(lmin,t,n))*24/T;
        Qdval(n)=BUS.QCarBus(n,1)*lf.MT(t,1);
    else
        Pdval(n)=BUS.PCarBus(n,1)*lf.BT(t,1)+sum(UCf(lmin,t,n))*24/T;
        Qdval(n)=BUS.QCarBus(n,1)*lf.BT(t,1);
    end
    PENSupval(n)=Pdval(n);
end

Pdmins.name='Pd';
Pdmins.val=Pdval;
Pdmins.form='full';
Pdmins.type='parameter';
Pdmins.uels=nbusset.uels;

Qdmins.name='Qd';
Qdmins.val=Qdval;
Qdmins.form='full';
Qdmins.type='parameter';
Qdmins.uels=nbusset.uels;

PENSupmins.name='PENSup';
PENSupmins.val=PENSupval;
PENSupmins.form='full';
PENSupmins.type='parameter';
PENSupmins.uels=nbusset.uels;

OType='out.gdx';
if exist(OType,'file')==2
   r1s.name='Vm';
   r1s.form='sparse';
   r1=rgdx('out.gdx',r1s);
   Vmlval=r1.val(:,2);

   r2s.name='delta';
   r2s.form='sparse';
   r2=rgdx('out.gdx',r2s);
   deltalval=r2.val(:,2);

else
    [Vmlval,deltalval]=FlatStart(BUS);
end
vmls.val=Vmlval;
deltals.val=deltalval;


 wgdx('in',nbusset,nbusPVset,nbusPQset,nbusSlackset,nlinesset,nrset,nlset,...
 Yms,ts,vups,vlos,vmls,deltaups,deltalos,deltals,Pgups,Pglos,Pgls,Qgups,...
 Qglos,Qgls,limSs,Pdmins,Qdmins,PENSupmins,PENSlos,PENSls);
%,basemvas,tiops
system 'gams opf.gms lo=0';
if ans==0
else
    for n=1:nbus
        Vmlval(n)=BUS.VFinBus(n,1);
        deltaloval(n)=-pi()/2;
        deltaupval(n)=pi()/2;
        deltalval(n)=pi()/180*BUS.ThFinBus(n,1);
    end
    vmls.val=Vmlval;
    deltals.val=deltalval;
    
 wgdx('in',nbusset,nbusPVset,nbusPQset,nbusSlackset,nlinesset,nrset,nlset,...
 Yms,ts,vups,vlos,vmls,deltaups,deltalos,deltals,Pgups,Pglos,Pgls,Qgups,...
 Qglos,Qgls,limSs,Pdmins,Qdmins,PENSupmins,PENSlos,PENSls);
%,basemvas,tiops
system 'gams opf.gms lo=0';
end
 MIN.nbusset(t)=nbusset;
 MIN.nbusPVset(t)=nbusPVset;
 MIN.nbusPQset(t)=nbusPQset;
 MIN.nbusSlackset(t)=nbusSlackset;
 MIN.nlinesset(t)=nlinesset;
 MIN.nrset(t)=nrset;
 MIN.nlset(t)=nlset;
 MIN.Yms(t)=Yms;
 MIN.ts(t)=ts;
 MIN.vups(t)=vups;
 MIN.vlos(t)=vlos;
 MIN.vmls(t)=vmls;
 MIN.deltaups(t)=deltaups;
 MIN.deltalos(t)=deltalos;
 MIN.deltals(t)=deltals;
 MIN.Pgups(t)=Pgups;
 MIN.Pglos(t)=Pglos;
 MIN.Pgls(t)=Pgls;
 MIN.Qgups(t)=Qgups;
 MIN.Qglos(t)=Qglos;
 MIN.Qgls(t)=Qgls;
 MIN.limSs(t)=limSs;
 MIN.Pds(t)=Pds;
 MIN.Qds(t)=Qds;
 MIN.PENSups(t)=PENSups;
 MIN.PENSlos(t)=PENSlos;
 MIN.PENSls(t)=PENSls;    

% [r1s,r2s,r3s,r4s,r5s,r6s,r7s,r8s,r9s,r10s]=gams('opf',nbusset,nbusPVset,nbusPQset,nbusSlackset,nlinesset,nrset,nlset,...
%  Yms,ts,vups,vlos,vls,deltaups,deltalos,deltals,Pgups,Pglos,Pgls,Qgups,...
%  Qglos,Qgls,basemvas,limSs,tiops,Pds,Qds,PENSups,PENSlos,PENSls);
% system 'gams opf.gms lo=1'
% 
r1s.name='F';
r1s.form='full';
r1=rgdx('out.gdx',r1s);
cvmin=r1.val;

r2s.name='Vm';
r2s.form='full';
r2=rgdx('out.gdx',r2s);
Vmmin=r2.val;

r3s.name='delta';
r3s.form='full';
r3=rgdx('out.gdx',r3s);
deltamin=r3.val;

r4s.name='Pg';
r4s.form='full';
r4=rgdx('out.gdx',r4s);
Pgmin=r4.val;

r5s.name='Qg';
r5s.form='full';
r5=rgdx('out.gdx',r5s);
Qgmin=r5.val;

r6s.name='OChFrom';
r6s.form='full';
r6=rgdx('out.gdx',r6s);
OChFrommin=r6.val;

r7s.name='OChTo';
r7s.form='full';
r7=rgdx('out.gdx',r7s);
OChTomin=r7.val;

r8s.name='PENS';
r8s.form='full';
r8=rgdx('out.gdx',r8s);
PENSmin=r8.val;

r9s.name='Pd';
r9s.form='full';
r9=rgdx('out.gdx',r9s);
Pdmin=r9.val;

r10s.name='Qd';
r10s.form='full';
r10=rgdx('out.gdx',r10s);
Qdmin=r10.val;
GenNmin(t)=sum(Pgmin);
LoadNmin(t)=sum(Pdmin);
ENSNmin(t)=sum(PENSmin);

for l=1:nbr
if OChFrommin(l)<OChTomin(l)
    OChmin(l)=OChTomin(l);
else
    OChmin(l)=OChFrommin(l);
end
Ochgmin(t,l)=OChmin(l);
end
for n=1:nbus
    Gengmin(t,n)=Pgmin(n);
    Logmin(t,n)=Pdmin(n);
    ENSgmin(t,n)=PENSmin(n);
end
OverChargeNmin(t)=sum(OChmin);
% Running opf again if some temporary point runs bad the opf proccess
opfNminite=1;
fprintf('\nt:%d',t);
while opfNminite<=2
[GenNgmintemp,LoadNgmintemp,ENSNgmintemp,GenNmin,LoadNmin,ENSNmin,OverChargeNmin]=GrCorrMIN(lf,BUS,BRANCH,Title,GenNmin,LoadNmin,ENSNmin,OverChargeNmin,UCf,t,lmin,savingdir,Ymatriz);
for n=1:nbus
    Gengmin(t,n)=GenNgmintemp(n);
    Logmin(t,n)=LoadNgmintemp(n);
    ENSgmin(t,n)=ENSNgmintemp(n);
end
opfNminite=opfNminite+1;
% fprintf('ite:%d',opfNminite);
end
while GenNmin(t)==sum(BUS.PGenBus(:,1))&&opfNminite<=6
[GenNgmintemp,LoadNgmintemp,ENSNgmintemp,GenNmin,LoadNmin,ENSNmin,OverChargeNmin]=GrCorrMIN(lf,BUS,BRANCH,Title,GenNmin,LoadNmin,ENSNmin,OverChargeNmin,UCf,t,lmin,savingdir,Ymatriz);
for n=1:nbus
    Gengmin(t,n)=GenNgmintemp(n);
    Logmin(t,n)=LoadNgmintemp(n);
    ENSgmin(t,n)=ENSNgmintemp(n);
end
opfNminite=opfNminite+1
fprintf('ite:%d',opfNminite);
end
%Defining bad as less than usual
if t==1
    losteval=0.6;
    lossprev=GenNmin(t)-LoadNmin(t);
else
    lossprev=GenNmin(t-1)-LoadNmin(t-1);
    lossact=GenNmin(t)-LoadNmin(t);
    losteval=lossact/lossprev;
end
while (losteval<=0.75||losteval>=1.25)&&opfNminite<=6
[GenNgmintemp,LoadNgmintemp,ENSNgmintemp,GenNmin,LoadNmin,ENSNmin,OverChargeNmin]=GrCorrMIN(lf,BUS,BRANCH,Title,GenNmin,LoadNmin,ENSNmin,OverChargeNmin,UCf,t,lmin,savingdir,Ymatriz);
for n=1:nbus
    Gengmin(t,n)=GenNgmintemp(n);
    Logmin(t,n)=LoadNgmintemp(n);
    ENSgmin(t,n)=ENSNgmintemp(n);
end
    lossact=GenNmin(t)-LoadNmin(t);
    losteval=lossact/lossprev;
    fprintf('New PS min MCS, t:%d',t)
opfNminite=opfNminite+1
fprintf('ite:%d',opfNminite);
end
% Define outputs
fprintf(fresNPS,'t= %d \t ',t);
fprintf(fresNPS,'Pg=%8.4f \t Pd=%8.4f \t ENS= %6.2f \t OverCharge= %6.2f\n',...
    GenNmin(t),LoadNmin(t),ENSNmin(t),OverChargeNmin(t));
end
fprintf(fresNPS,'Overcharge general \n Line:');
for l=1:nbr
    fprintf(fresNPS,'\t %6d',l);
end
for t=1:ntime
    fprintf(fresNPS,'\n t: \t %d',t);
   for l=1:nbr
fprintf(fresNPS,'\t %6.2f',Ochgmin(t,l));
   end
end
fprintf(fresNPS,'Power Generation general \n Bus:');
for n=1:nbus
    fprintf(fresNPS,'\t %6d',n);
end
for t=1:ntime
    fprintf(fresNPS,'\n t: \t %d',t);
   for n=1:nbus
fprintf(fresNPS,'\t %6.2f',Gengmin(t,n));
   end
end

%% Replicability from only load max
fprintf(fresNPS,'Resultados de la optimizacion maxima carga requerida para el nuevo Sistema de Potencia\n');

%% Now set time dependent variables for only load modelling

for t=1:ntime
    Pdval=zeros(nbus,1);
    Qdval=zeros(nbus,1);
    PENSupval=zeros(nbus,1);
for n=1:nbus
    if BUS.AreaFCBus(n,1)==1
        Pdval(n)=BUS.PCarBus(n,1)*lf.MT(t,1)+sum(UCf(lmax,t,n))*24/T;
        Qdval(n)=BUS.QCarBus(n,1)*lf.MT(t,1);
    else
        Pdval(n)=BUS.PCarBus(n,1)*lf.BT(t,1)+sum(UCf(lmax,t,n))*24/T;
        Qdval(n)=BUS.QCarBus(n,1)*lf.BT(t,1);
    end
    PENSupval(n)=Pdval(n);
end

Pdmaxs.name='Pd';
Pdmaxs.val=Pdval;
Pdmaxs.form='full';
Pdmaxs.type='parameter';
Pdmaxs.uels=nbusset.uels;

Qdmaxs.name='Qd';
Qdmaxs.val=Qdval;
Qdmaxs.form='full';
Qdmaxs.type='parameter';
Qdmaxs.uels=nbusset.uels;

PENSupmaxs.name='PENSup';
PENSupmaxs.val=PENSupval;
PENSupmaxs.form='full';
PENSupmaxs.type='parameter';
PENSupmaxs.uels=nbusset.uels;

OType='out.gdx';
if exist(OType,'file')==2
   r1s.name='Vm';
   r1s.form='sparse';
   r1=rgdx('out.gdx',r1s);
   vmlval=r1.val(:,2);

   r2s.name='delta';
   r2s.form='sparse';
   r2=rgdx('out.gdx',r2s);
   deltalval=r2.val(:,2);

else
    [Vmlval,deltalval]=FlatStart(BUS);
end
vmls.val=Vmlval;
deltals.val=deltalval;

 wgdx('in',nbusset,nbusPVset,nbusPQset,nbusSlackset,nlinesset,nrset,nlset,...
 Yms,ts,vups,vlos,vmls,deltaups,deltalos,deltals,Pgups,Pglos,Pgls,Qgups,...
 Qglos,Qgls,limSs,Pdmaxs,Qdmaxs,PENSupmaxs,PENSlos,PENSls);
%,basemvas,tiops
system 'gams opf.gms lo=0';
if ans==0
else
    for n=1:nbus
        Vmlval(n)=BUS.VFinBus(n,1);
        deltaloval(n)=-pi()/2;
        deltaupval(n)=pi()/2;
        deltalval(n)=pi()/180*BUS.ThFinBus(n,1);
    end
    vmls.val=Vmlval;
    deltals.val=deltalval;
    
 wgdx('in',nbusset,nbusPVset,nbusPQset,nbusSlackset,nlinesset,nrset,nlset,...
 Yms,ts,vups,vlos,vmls,deltaups,deltalos,deltals,Pgups,Pglos,Pgls,Qgups,...
 Qglos,Qgls,limSs,Pdmaxs,Qdmaxs,PENSupmaxs,PENSlos,PENSls);
%,basemvas,tiops
system 'gams opf.gms lo=0';
end
  
r1s.name='F';
r1s.form='full';
r1=rgdx('out.gdx',r1s);
cvmax=r1.val;

r2s.name='Vm';
r2s.form='full';
r2=rgdx('out.gdx',r2s);
Vmmax=r2.val;

r3s.name='delta';
r3s.form='full';
r3=rgdx('out.gdx',r3s);
deltamax=r3.val;

r4s.name='Pg';
r4s.form='full';
r4=rgdx('out.gdx',r4s);
Pgmax=r4.val;

r5s.name='Qg';
r5s.form='full';
r5=rgdx('out.gdx',r5s);
Qgmax=r5.val;

r6s.name='OChFrom';
r6s.form='full';
r6=rgdx('out.gdx',r6s);
OChFrommax=r6.val;

r7s.name='OChTo';
r7s.form='full';
r7=rgdx('out.gdx',r7s);
OChTomax=r7.val;

r8s.name='PENS';
r8s.form='full';
r8=rgdx('out.gdx',r8s);
PENSmax=r8.val;

r9s.name='Pd';
r9s.form='full';
r9=rgdx('out.gdx',r9s);
Pdmax=r9.val;

r10s.name='Qd';
r10s.form='full';
r10=rgdx('out.gdx',r10s);
Qdmax=r10.val;
GenNmax(t)=sum(Pgmax);
LoadNmax(t)=sum(Pdmax);
ENSNmax(t)=sum(PENSmax);

for l=1:nbr
if OChFrommax(l)<OChTomax(l)
    OChmax(l)=OChTomax(l);
else
    OChmax(l)=OChFrommax(l);
end
Ochgmax(t,l)=OChmax(l);
end
for n=1:nbus
    Gengmax(t,n)=Pgmax(n);
    Logmax(t,n)=Pdmax(n);
    ENSgmax(t,n)=PENSmax(n);
end
OverChargeNmax(t)=sum(OChmax);
% Running opf again if some temporary point runs bad the opf proccess
opfmaxNite=1;
fprintf('\nt:%d',t);
while opfmaxNite<=2
[GenNgmaxtemp,LoadNgmaxtemp,ENSNgmaxtemp,GenNmax,LoadNmax,ENSNmax,OverChargeNmax]=GrCorrMAX(lf,BUS,BRANCH,Title,GenNmax,LoadNmax,ENSNmax,OverChargeNmax,UCf,t,lmax,savingdir,Ymatriz);
for n=1:nbus
    Gengmax(t,n)=GenNgmaxtemp(n);
    Logmax(t,n)=LoadNgmaxtemp(n);
    ENSgmax(t,n)=ENSNgmaxtemp(n);
end
opfmaxNite=opfmaxNite+1;
% fprintf('ite:%d',opfmaxNite);
end
while GenNmax(t)==sum(BUS.PGenBus(:,1))&&opfmaxNite<=6
[GenNgmaxtemp,LoadNgmaxtemp,ENSNgmaxtemp,GenNmax,LoadNmax,ENSNmax,OverChargeNmax]=GrCorrMAX(lf,BUS,BRANCH,Title,GenNmax,LoadNmax,ENSNmax,OverChargeNmax,UCf,t,lmax,savingdir,Ymatriz);
for n=1:nbus
    Gengmax(t,n)=GenNgmaxtemp(n);
    Logmax(t,n)=LoadNgmaxtemp(n);
    ENSgmax(t,n)=ENSNgmaxtemp(n);
end
opfmaxNite=opfmaxNite+1
fprintf('ite:%d',opfmaxNite);
end
%Defining bad as less than usual
if t==1
    losteval=0.6;
    lossprev=GenNmax(t)-LoadNmax(t);
else
    lossprev=GenNmax(t-1)-LoadNmax(t-1);
    lossact=GenNmax(t)-LoadNmax(t);
    losteval=lossact/lossprev;
end
while (losteval<=0.75||losteval>=1.25)&&opfmaxNite<=6
[GenNgmaxtemp,LoadNgmaxtemp,ENSNgmaxtemp,GenNmax,LoadNmax,ENSNmax,OverChargeNmax]=GrCorrMAX(lf,BUS,BRANCH,Title,GenNmax,LoadNmax,ENSNmax,OverChargeNmax,UCf,t,lmax,savingdir,Ymatriz);
for n=1:nbus
    Gengmax(t,n)=GenNgmaxtemp(n);
    Logmax(t,n)=LoadNgmaxtemp(n);
    ENSgmax(t,n)=ENSNgmaxtemp(n);
end
    lossact=GenNmax(t)-LoadNmax(t);
    losteval=lossact/lossprev;
    fprintf('new PS, max MCS. t:%d',t);
opfmaxNite=opfmaxNite+1
fprintf('ite:%d',opfmaxNite);
end
% Define outputs
fprintf(fresNPS,'t= %d \t ',t);
fprintf(fresNPS,'Pg=%8.4f \t Pd=%8.4f \t ENS= %6.2f \t OverCharge= %6.2f\n',...
    GenNmax(t),LoadNmax(t),ENSNmax(t),OverChargeNmax(t));
end
fprintf(fresNPS,'Overcharge general \n Line:');
for l=1:nbr
    fprintf(fresNPS,'\t %6d',l);
end
for t=1:ntime
    fprintf(fresNPS,'\n t: \t %d',t);
   for l=1:nbr
fprintf(fresNPS,'\t %6.2f',Ochgmax(t,l));
   end
end
fprintf(fresNPS,'Power Generation general \n Bus:');
for n=1:nbus
    fprintf(fresNPS,'\t %6d',n);
end
for t=1:ntime
    fprintf(fresNPS,'\n t: \t %d',t);
   for n=1:nbus
fprintf(fresNPS,'\t %6.2f',Gengmax(t,n));
   end
end


fclose(fresNPS);
mkdir(savingdir)
movefile(savingtxt,savingdir,'f')
savefileNname=savingdir;
savingcorrtxt=strcat(savefileNname,'correction');
mkdir(savingcorrtxt);
t=1:ntime;
F9=figure;
print('djpg','-r800');
plot(t,LoadNol,t,LoadNmin,t,LoadNmax,'g');
lgd=legend({'Only Load scenario','Minimun EV Charge Load Scenario','Maximun EV charge Load Scenario'},'location','south');
lgd.FontSize=8;
title('Load in all scenarios');
xlabel('time 1/2 h');
ylabel('MW');
F9txt='LoadOlMinMax.jpg';
saveas(F9,F9txt);
F10=figure;
print('djpg','-r800');
plot(t,GenNol,'b',t,LoadNol,'k',t,ENSNol,'r',t,OverChargeNol,'g');
title('Only Load, without EV charging')
lgd1=legend({'Generation','Load','Energy Not Served','Overcharge'},'location','south');
lgd1.FontSize=8;
xlabel('time 1/2 h');
ylabel('MW');
F10txt='OlNewPS.jpg';
saveas(F10,F10txt);
F11=figure;
print('djpg','-r800');
plot(t,GenNmin,'b',t,LoadNmin,'k',t,ENSNmin,'r',t,OverChargeNmin,'g');
title('Load and minimun EV charging Load');
lgd2=legend({'Generation','Load','Energy Not Served','Overcharge'},'location','south');
lgd2.FontSize=8;
xlabel('time 1/2 h');
ylabel('MW');
F11txt='MinNewPS.jpg';
saveas(F11,F11txt);
F12=figure;
print('djpg','-r800');
plot(t,GenNmax,'b',t,LoadNmax,'k',t,ENSNmax,'r',t,OverChargeNmax,'g');
title('Load and maximun EV charging Load');
lgd3=legend({'Generation','Load','Energy Not Served','Overcharge'},'location','south');
lgd3.FontSize=8;
xlabel('time 1/2 h');
ylabel('MW');
F12txt='MaxNewPS.jpg';
saveas(F12,F12txt);
movefile(F9txt,savingdir,'f')
movefile(F10txt,savingdir,'f')
movefile(F11txt,savingdir,'f')
movefile(F12txt,savingdir,'f')
tfix=1;
while tfix>=1
ReGraphNPS;
tfix=input('Insert t needed to fix [0 if not needed]');
if tfix==0
    break
else
GCfix=input('Insert the correction needed [Col,Cmin,Cmax]');

if strcmp(GCfix,'Col')
[GenNgoltemp,LoadNgoltemp,ENSNgoltemp,GenNol,LoadNol,ENSNol,OverChargeNol,savingtxttemp]=GrCorrOL(GenNol,LoadNol,ENSNol,OverChargeNol,lf,BUS,BRANCH,Title,UCf,tfix,savingdir,Ymatriz,1);
for n=1:nbus
    Gengol(tfix,n)=GenNgoltemp(n);
    Logol(tfix,n)=LoadNgoltemp(n);
    ENSgol(tfix,n)=ENSNgoltemp(n);
end
elseif strcmp(GCfix,'Cmin')
[GenNgmintemp,LoadNgmintemp,ENSNgmintemp,GenNmin,LoadNmin,ENSNmin,OverChargeNmin]=GrCorrMIN(lf,BUS,BRANCH,Title,GenNmin,LoadNmin,ENSNmin,OverChargeNmin,UCf,tfix,lmin,savingdir,Ymatriz);
for n=1:nbus
    Gengmin(tfix,n)=GenNgmintemp(n);
    Logmin(tfix,n)=LoadNgmintemp(n);
    ENSgmin(tfix,n)=ENSNgmintemp(n);
end
elseif strcmp(GCfix,'Cmax')
[GenNgmaxtemp,LoadNgmaxtemp,ENSNgmaxtemp,GenNmax,LoadNmax,ENSNmax,OverChargeNmax]=GrCorrMAX(lf,BUS,BRANCH,Title,GenNmax,LoadNmax,ENSNmax,OverChargeNmax,UCf,tfix,lmax,savingdir,Ymatriz);
for n=1:nbus
    Gengmax(tfix,n)=GenNgmaxtemp(n);
    Logmax(tfix,n)=LoadNgmaxtemp(n);
    ENSgmax(tfix,n)=ENSNgmaxtemp(n);
end
else
    GCfix=input('\n Critical error, introduce a correct format[Col,Cmin,Cmax]');
end
end
end

end