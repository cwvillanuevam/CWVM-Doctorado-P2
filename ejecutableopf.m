function [Genol,Genmin,Genmax,Loadol,Loadmin,Loadmax,ENSol,ENSmin,ENSmax,OverChargeol,OverChargemin,OverChargemax,savefilename,MCSmin,MCSq1,MCSmean,MCSq3,MCSmax,lf,Title,BUS,BRANCH,UCf,lmin,lmax,TScf,G1SD,G2SD,G3SD,G4SD,GVDfM,GVDtM,GVDfm,GVDtm]=ejecutableopf(PStype,lftype,Nsm,T,Vm,GrafDir,SCtypem)
numsc=length(Nsm);
[Title,BUS,BRANCH]=readcdf2(PStype);
nbus=length(BUS.NumBus(:,1));
nbr=length(BRANCH.NumIniRam(:,1));
 x=imread(GrafDir);
 figure; imshow(x);
 [xb,yb]=ginput(nbus+1);

for sc=1:numsc
    fprintf('Scenario: %s',SCtypem(sc))
    V=Vm(sc);
    Ns=Nsm(sc);
    SCdir=SCtypem(sc);
    mkdir(SCdir);
%% This script set the input data run the optimizer and set the output
%Define the previous parametric data


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

[Ymatriz]=Ymat(PStype);

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

[lf]=readloadfactor(lftype);
ntime=length(lf.MT(:,1));


%% Seteamos el nombre del archivo txt de resultados
Type=Title.case;
savingtxt=strcat(Type,'validacion.txt');
savingdir=strcat(Type,'validacion');
version=1;
while exist(savingdir,'file')==7 || exist(savingdir,'file')==2 
    savingtxt=strcat(Type,'validacion','v',num2str(version),'.txt');
    savingdir=strcat(Type,'validacion','v',num2str(version));
    version=version+1;
end
cd(pwd);
mkdir(savingdir)

savingcorrtxt0=strcat(savingdir,'correction');
mkdir(savingcorrtxt0);




%% Now set time dependent variables for only load modelling
Genol=zeros(ntime,1);
Loadol=zeros(ntime,1);
ENSol=zeros(ntime,1);
OverChargeol=zeros(ntime,1);
Genmin=zeros(ntime,1);
Loadmin=zeros(ntime,1);
ENSmin=zeros(ntime,1);
OverChargemin=zeros(ntime,1);
Genmax=zeros(ntime,1);
Loadmax=zeros(ntime,1);
ENSmax=zeros(ntime,1);
OverChargemax=zeros(ntime,1);
[MCSmin,lmin,MCSq1,MCSmean,MCSq3,MCSmax,lmax,UCf,TScf]=MCSopt(PStype,Ns,T,V,savingdir,BUS,lf);
%% Relicability from only load
fres=fopen(savingtxt,'w');
fprintf(fres,'\n Resultados de la optimizacion solo carga sin EVs\n');
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
 OL.nbusset(t)=nbusset;
 OL.nbusPVset(t)=nbusPVset;
 OL.nbusPQset(t)=nbusPQset;
 OL.nbusSlackset(t)=nbusSlackset;
 OL.nlinesset(t)=nlinesset;
 OL.nrset(t)=nrset;
 OL.nlset(t)=nlset;
 OL.Yms(t)=Yms;
 OL.ts(t)=ts;
 OL.vups(t)=vups;
 OL.vlos(t)=vlos;
 OL.vmls(t)=vmls;
 OL.deltaups(t)=deltaups;
 OL.deltalos(t)=deltalos;
 OL.deltals(t)=deltals;
 OL.Pgups(t)=Pgups;
 OL.Pglos(t)=Pglos;
 OL.Pgls(t)=Pgls;
 OL.Qgups(t)=Qgups;
 OL.Qglos(t)=Qglos;
 OL.Qgls(t)=Qgls;
 OL.limSs(t)=limSs;
 OL.Pds(t)=Pds;
 OL.Qds(t)=Qds;
 OL.PENSups(t)=PENSups;
 OL.PENSlos(t)=PENSlos;
 OL.PENSls(t)=PENSls;    

% [r1s,r2s,r3s,r4s,r5s,r6s,r7s,r8s,r9s,r10s]=gams('opf',nbusset,nbusPVset,nbusPQset,nbusSlackset,nlinesset,nrset,nlset,...
%  Yms,ts,vups,vlos,vls,deltaups,deltalos,deltals,Pgups,Pglos,Pgls,Qgups,...
%  Qglos,Qgls,basemvas,limSs,tiops,Pds,Qds,PENSups,PENSlos,PENSls);
% system 'gams opf.gms lo=1'
% 
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
Genol(t)=sum(Pgol);
Loadol(t)=sum(Pdol);
ENSol(t)=sum(PENSol);
for l=1:nbr
if OChFromol(l)<OChTool(l)
    OChol(l)=OChTool(l);
else
    OChol(l)=OChFromol(l);
end
Ochgol(t,l)=OChol(l);
end
OverChargeol(t)=sum(OChol);
for n=1:nbus
    Gengol(t,n)=Pgol(n);
    Logol(t,n)=Pdol(n);
    ENSgol(t,n)=PENSol(n);
end
% Running opf again if some temporary point runs bad the opf proccess
opfolite=1;
fprintf('\nt:%d',t);
while opfolite<=2
[Gengoltemp,Logoltemp,ENSgoltemp,Genol,Loadol,ENSol,OverChargeol,savingtxttemp]=GrCorrOL(Genol,Loadol,ENSol,OverChargeol,lf,BUS,BRANCH,Title,UCf,t,savingdir,Ymatriz,1);
for n=1:nbus
    Gengol(t,n)=Gengoltemp(n);
    Logol(t,n)=Logoltemp(n);
    ENSgol(t,n)=ENSgoltemp(n);
end
opfolite=opfolite+1;  

% fprintf('ite:%d',opfolite);
end
while Genol(t)==sum(BUS.PGenBus(:,1))&&opfolite<=6
[Gengoltemp,Logoltemp,ENSgoltemp,Genol,Loadol,ENSol,OverChargeol,savingtxttemp]=GrCorrOL(Genol,Loadol,ENSol,OverChargeol,lf,BUS,BRANCH,Title,UCf,t,savingdir,Ymatriz,1);
for n=1:nbus
    Gengol(t,n)=Gengoltemp(n);
    Logol(t,n)=Logoltemp(n);
    ENSgol(t,n)=ENSgoltemp(n);
end
opfolite=opfolite+1;
fprintf('ite:%d',opfolite);
end
%Defining bad as less than usual
if t==1
    losteval=0.6;
    lossprev=Genol(t)-Loadol(t);
else
    lossprev=Genol(t-1)-Loadol(t-1);
    lossact=Genol(t)-Loadol(t);
    losteval=lossact/lossprev;
end
while (losteval<=0.75||losteval>=1.25)&&opfolite<=6
[Gengoltemp,Logoltemp,ENSgoltemp,Genol,Loadol,ENSol,OverChargeol,savingtxttemp]=GrCorrOL(Genol,Loadol,ENSol,OverChargeol,lf,BUS,BRANCH,Title,UCf,t,savingdir,Ymatriz,1);
    lossact=Genol(t)-Loadol(t);
    losteval=lossact/lossprev;
for n=1:nbus
    Gengol(t,n)=Gengoltemp(n);
    Logol(t,n)=Logoltemp(n);
    ENSgol(t,n)=ENSgoltemp(n);
end
opfolite=opfolite+1;
fprintf('ite:%d',opfolite);
end
% Define outputs


fprintf(fres,'t= %d \t ',t);
fprintf(fres,'Pg=%8.4f \t Pd=%8.4f \t ENS= %6.2f \t OverCharge= %6.2f\n',...
    Genol(t),Loadol(t),ENSol(t),OverChargeol(t));
end
fprintf(fres,'\n Overcharge general \n Line:');
for l=1:nbr
    fprintf(fres,'\t %6d',l);
end
for t=1:ntime
    fprintf(fres,'\n t: \t %d',t);
   for l=1:nbr
fprintf(fres,'\t %6.2f',Ochgol(t,l));
   end
end
fprintf(fres,'\n Power Generation general \n Bus:');
for n=1:nbus
    fprintf(fres,'\t %6d',n);
end
for t=1:ntime
    fprintf(fres,'\n t: \t %d',t);
   for n=1:nbus
fprintf(fres,'\t %6.2f',Gengol(t,n));
   end
end

fprintf(fres,'\n Not Served Energy \n Bus:');
for n=1:nbus
    fprintf(fres,'\t %6d',n);
end
for t=1:ntime
    fprintf(fres,'\n t: \t %d',t);
   for n=1:nbus
fprintf(fres,'\t %6.2f',ENSgol(t,n));
   end
end



%% Graphic development of electric vehicle distribution
[GVDfM,GVDtM]=Geo_Veh_Dist(TScf,nbus,V,lmax);
[GVDfm,GVDtm]=Geo_Veh_Dist(TScf,nbus,V,lmin);
[G1SD,G2SD,G3SD,G4SD]=mkPSgraph(xb,yb,BUS,BRANCH,Title,GVDfM,GVDtM,GVDfm,GVDtm,GrafDir)
movefile(G1SD,SCdir,'f')
movefile(G2SD,SCdir,'f')
movefile(G3SD,SCdir,'f')
movefile(G4SD,SCdir,'f')
%% Relicability from only load min
fprintf(fres,'\n Resultados de la optimizacion minima carga requerida\n');

%% Now set time dependent variables for only load modelling

for t=1:ntime
    Pdval=zeros(nbus,1);
    Qdval=zeros(nbus,1);
    PENSupval=zeros(nbus,1);
for n=1:nbus
    if BUS.AreaFCBus(n,1)==1
        Pdval(n)=BUS.PCarBus(n,1)*lf.MT(t,1)+sum(UCf(lmin,t,n))*T/24;
        Qdval(n)=BUS.QCarBus(n,1)*lf.MT(t,1);
    else
        Pdval(n)=BUS.PCarBus(n,1)*lf.BT(t,1)+sum(UCf(lmin,t,n))*T/24;
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
Genmin(t)=sum(Pgmin);
Loadmin(t)=sum(Pdmin);
ENSmin(t)=sum(PENSmin);

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
OverChargemin(t)=sum(OChmin);
% Running opf again if some temporary point runs bad the opf proccess
opfminite=1;
fprintf('\nt:%d',t);
while opfminite<=2
[Gengmintemp,Logmintemp,ENSgmintemp,Genmin,Loadmin,ENSmin,OverChargemin]=GrCorrMIN(lf,BUS,BRANCH,Title,Genmin,Loadmin,ENSmin,OverChargemin,UCf,t,lmin,savingdir,Ymatriz);
for n=1:nbus
    Gengmin(t,n)=Gengmintemp(n);
    Logmin(t,n)=Logmintemp(n);
    ENSgmin(t,n)=ENSgmintemp(n);
end
opfminite=opfminite+1;
% fprintf('ite:%d',opfminite);
end
while Genmin(t)==sum(BUS.PGenBus(:,1))&&opfminite<=6
[Gengmintemp,Logmintemp,ENSgmintemp,Genmin,Loadmin,ENSmin,OverChargemin]=GrCorrMIN(lf,BUS,BRANCH,Title,Genmin,Loadmin,ENSmin,OverChargemin,UCf,t,lmin,savingdir,Ymatriz);
for n=1:nbus
    Gengmin(t,n)=Gengmintemp(n);
    Logmin(t,n)=Logmintemp(n);
    ENSgmin(t,n)=ENSgmintemp(n);
end
opfminite=opfminite+1;
fprintf('ite:%d',opfminite);
end
%Defining bad as less than usual
if t==1
    losteval=0.6;
    lossprev=Genmin(t)-Loadmin(t);
else
    lossprev=Genmin(t-1)-Loadmin(t-1);
    lossact=Genmin(t)-Loadmin(t);
    losteval=lossact/lossprev;
end
while (losteval<=0.75||losteval>=1.25)&&opfminite<=6
[Gengmintemp,Logmintemp,ENSgmintemp,Genmin,Loadmin,ENSmin,OverChargemin]=GrCorrMIN(lf,BUS,BRANCH,Title,Genmin,Loadmin,ENSmin,OverChargemin,UCf,t,lmin,savingdir,Ymatriz);
for n=1:nbus
    Gengmin(t,n)=Gengmintemp(n);
    Logmin(t,n)=Logmintemp(n);
    ENSgmin(t,n)=ENSgmintemp(n);
end
    lossact=Genmin(t)-Loadmin(t);
    losteval=lossact/lossprev;
    fprintf('Min opt, t:%d',t);
opfminite=opfminite+1
fprintf('ite:%d',opfminite);
end
% Define outputs
fprintf(fres,'t= %d \t ',t);
fprintf(fres,'Pg=%8.4f \t Pd=%8.4f \t ENS= %6.2f \t OverCharge= %6.2f\n',...
    Genmin(t),Loadmin(t),ENSmin(t),OverChargemin(t));
end
fprintf(fres,'\n Overcharge general \n Line:');
for l=1:nbr
    fprintf(fres,'\t %6d',l);
end
for t=1:ntime
    fprintf(fres,'\n t: \t %d',t);
   for l=1:nbr
fprintf(fres,'\t %6.2f',Ochgmin(t,l));
   end
end
fprintf(fres,'\n Power Generation general \n Bus:');
for n=1:nbus
    fprintf(fres,'\t %6d',n);
end
for t=1:ntime
    fprintf(fres,'\n t: \t %d',t);
   for n=1:nbus
fprintf(fres,'\t %6.2f',Gengmin(t,n));
   end
end

fprintf(fres,'\n Not Served Energy\n Bus:');
for n=1:nbus
    fprintf(fres,'\t %6d',n);
end
for t=1:ntime
    fprintf(fres,'\n t: \t %d',t);
   for n=1:nbus
fprintf(fres,'\t %6.2f',ENSgmin(t,n));
   end
end
%% Relicability from only load max
fprintf(fres,'\n Resultados de la optimizacion maxima carga requerida\n');

%% Now set time dependent variables for only load modelling

for t=1:ntime
    Pdval=zeros(nbus,1);
    Qdval=zeros(nbus,1);
    PENSupval=zeros(nbus,1);
for n=1:nbus
    if BUS.AreaFCBus(n,1)==1
        Pdval(n)=BUS.PCarBus(n,1)*lf.MT(t,1)+sum(UCf(lmax,t,n))*T/24;
        Qdval(n)=BUS.QCarBus(n,1)*lf.MT(t,1);
    else
        Pdval(n)=BUS.PCarBus(n,1)*lf.BT(t,1)+sum(UCf(lmax,t,n))*T/24;
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
 MAX.nbusset(t)=nbusset;
 MAX.nbusPVset(t)=nbusPVset;
 MAX.nbusPQset(t)=nbusPQset;
 MAX.nbusSlackset(t)=nbusSlackset;
 MAX.nlinesset(t)=nlinesset;
 MAX.nrset(t)=nrset;
 MAX.nlset(t)=nlset;
 MAX.Yms(t)=Yms;
 MAX.ts(t)=ts;
 MAX.vups(t)=vups;
 MAX.vlos(t)=vlos;
 MAX.vmls(t)=vmls;
 MAX.deltaups(t)=deltaups;
 MAX.deltalos(t)=deltalos;
 MAX.deltals(t)=deltals;
 MAX.Pgups(t)=Pgups;
 MAX.Pglos(t)=Pglos;
 MAX.Pgls(t)=Pgls;
 MAX.Qgups(t)=Qgups;
 MAX.Qglos(t)=Qglos;
 MAX.Qgls(t)=Qgls;
 MAX.limSs(t)=limSs;
 MAX.Pds(t)=Pds;
 MAX.Qds(t)=Qds;
 MAX.PENSups(t)=PENSups;
 MAX.PENSlos(t)=PENSlos;
 MAX.PENSls(t)=PENSls;    

% [r1s,r2s,r3s,r4s,r5s,r6s,r7s,r8s,r9s,r10s]=gams('opf',nbusset,nbusPVset,nbusPQset,nbusSlackset,nlinesset,nrset,nlset,...
%  Yms,ts,vups,vlos,vls,deltaups,deltalos,deltals,Pgups,Pglos,Pgls,Qgups,...
%  Qglos,Qgls,basemvas,limSs,tiops,Pds,Qds,PENSups,PENSlos,PENSls);
% system 'gams opf.gms lo=1'
% 
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
Genmax(t)=sum(Pgmax);
Loadmax(t)=sum(Pdmax);
ENSmax(t)=sum(PENSmax);

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
OverChargemax(t)=sum(OChmax);
% Running opf again if some temporary point runs bad the opf proccess
opfmaxite=1;
fprintf('\nt:%d',t);
while opfmaxite<=2
[Gengmaxtemp,Logmaxtemp,ENSgmaxtemp,Genmax,Loadmax,ENSmax,OverChargemax]=GrCorrMAX(lf,BUS,BRANCH,Title,Genmax,Loadmax,ENSmax,OverChargemax,UCf,t,lmax,savingdir,Ymatriz);
for n=1:nbus
    Gengmax(t,n)=Gengmaxtemp(n);
    Logmax(t,n)=Logmaxtemp(n);
    ENSgmax(t,n)=ENSgmaxtemp(n);
end
opfmaxite=opfmaxite+1;
% fprintf('ite:%d',opfmaxite);
end
while Genmax(t)==sum(BUS.PGenBus(:,1))&&opfmaxite<=8
[Gengmaxtemp,Logmaxtemp,ENSgmaxtemp,Genmax,Loadmax,ENSmax,OverChargemax]=GrCorrMAX(lf,BUS,BRANCH,Title,Genmax,Loadmax,ENSmax,OverChargemax,UCf,t,lmax,savingdir,Ymatriz);
for n=1:nbus
    Gengmax(t,n)=Gengmaxtemp(n);
    Logmax(t,n)=Logmaxtemp(n);
    ENSgmax(t,n)=ENSgmaxtemp(n);
end
opfmaxite=opfmaxite+1
fprintf('ite:%d',opfmaxite);
end
%Defining bad as less than usual
if t==1
    losteval=0.6;
    lossprev=Genmax(t)-Loadmax(t);
else
    lossprev=Genmax(t-1)-Loadmax(t-1);
    lossact=Genmax(t)-Loadmax(t);
    losteval=lossact/lossprev;
end
while (losteval<=0.75||losteval>=1.25)&&opfmaxite<=12
[Gengmaxtemp,Logmaxtemp,ENSgmaxtemp,Genmax,Loadmax,ENSmax,OverChargemax]=GrCorrMAX(lf,BUS,BRANCH,Title,Genmax,Loadmax,ENSmax,OverChargemax,UCf,t,lmax,savingdir,Ymatriz);
for n=1:nbus
    Gengmax(t,n)=Gengmaxtemp(n);
    Logmax(t,n)=Logmaxtemp(n);
    ENSgmax(t,n)=ENSgmaxtemp(n);
end
    lossact=Genmax(t)-Loadmax(t);
    losteval=lossact/lossprev;
    fprintf('Max MCS, t:%d',t);
opfmaxite=opfmaxite+1
fprintf('ite:%d',opfmaxite);
if opfmaxite>=4
    break;
end
end
% Define outputs
fprintf(fres,'t= %d \t ',t);
fprintf(fres,'Pg=%8.4f \t Pd=%8.4f \t ENS= %6.2f \t OverCharge= %6.2f\n',...
    Genmax(t),Loadmax(t),ENSmax(t),OverChargemax(t));
end
fprintf(fres,'\n Overcharge general \n Line:');
for l=1:nbr
    fprintf(fres,'\t %6d',l);
end
for t=1:ntime
    fprintf(fres,'\n t: \t %d',t);
   for l=1:nbr
fprintf(fres,'\t %6.2f',Ochgmax(t,l));
   end
end
fprintf(fres,'\n Power Generation general \n Bus:');
for n=1:nbus
    fprintf(fres,'\t %6d',n);
end
for t=1:ntime
    fprintf(fres,'\n t: \t %d',t);
   for n=1:nbus
fprintf(fres,'\t %6.2f',Gengmax(t,n));
   end
end

fprintf(fres,'\n Not Served Energy \n Bus:');
for n=1:nbus
    fprintf(fres,'\t %6d',n);
end
for t=1:ntime
    fprintf(fres,'\n t: \t %d',t);
   for n=1:nbus
fprintf(fres,'\t %6.2f',ENSgmax(t,n));
   end
end

fclose(fres);
movefile(savingtxt,savingdir,'f')
savefilename=savingdir;
savingcorrtxt=strcat(savefilename,'correction');
mkdir(savingcorrtxt);
t=1:ntime;
figure;
ImageDPI=800;
subplot(2,2,1)
plot(t,Loadol,t,Loadmin,t,Loadmax,'g');
lgd=legend({'Only Load scenario','Minimun EV Charge Load Scenario','Maximun EV charge Load Scenario'},'location','southeast');
lgd.FontSize=8;
title('Load in all scenarios');
xlabel('time 1/2 h');
ylabel('MW');
subplot(2,2,2)
plot(t,Genol,'b',t,Loadol,'k',t,ENSol,'r',t,OverChargeol,'g');
title('Only Load, without EV charging')
lgd1=legend({'Generation','Load','Not Served Energy','Overcharge'},'location','east');
lgd1.FontSize=8;
xlabel('time 1/2 h');
ylabel('MW');
subplot(2,2,3)
plot(t,Genmin,'b',t,Loadmin,'k',t,ENSmin,'r',t,OverChargemin,'g');
title('Load and minimun EV charging Load');
lgd2=legend({'Generation','Load','Not Served Energy','Overcharge'},'location','east');
lgd2.FontSize=8;
xlabel('time 1/2 h');
ylabel('MW');
subplot(2,2,4)
plot(t,Genmax,'b',t,Loadmax,'k',t,ENSmax,'r',t,OverChargemax,'g');
title('Load and maximun EV charging Load');
lgd3=legend({'Generation','Load','Not Served Energy','Overcharge'},'location','east');
lgd3.FontSize=8;
xlabel('time 1/2 h');
ylabel('MW');
tfix=1;
while tfix>=1
ReGraph;
tfix=input('Insert t needed to fix [0 if not needed]');
if tfix==0
    break
else
GCfix=input('Insert the correction needed [Col,Cmin,Cmax]');

if strcmp(GCfix,'Col')
    [Gengoltemp,Logoltemp,ENSgoltemp,Genol,Loadol,ENSol,OverChargeol,savingtxttemp]=GrCorrOL(Genol,Loadol,ENSol,OverChargeol,lf,BUS,BRANCH,Title,UCf,tfix,savingdir,Ymatriz,1);
for n=1:nbus
    Gengol(tfix,n)=Gengoltemp(n);
    Logol(tfix,n)=Logoltemp(n);
    ENSgol(tfix,n)=ENSgoltemp(n);
end
elseif strcmp(GCfix,'Cmin')
    [Gengmintemp,Logmintemp,ENSgmintemp,Genmin,Loadmin,ENSmin,OverChargemin]=GrCorrMIN(lf,BUS,BRANCH,Title,Genmin,Loadmin,ENSmin,OverChargemin,UCf,tfix,lmin,savingdir,Ymatriz);
for n=1:nbus
    Gengmin(tfix,n)=Gengmintemp(n);
    Logmin(tfix,n)=Logmintemp(n);
    ENSgmin(tfix,n)=ENSgmintemp(n);
end
elseif strcmp(GCfix,'Cmax')
    [Gengmaxtemp,Logmaxtemp,ENSgmaxtemp,Genmax,Loadmax,ENSmax,OverChargemax]=GrCorrMAX(lf,BUS,BRANCH,Title,Genmax,Loadmax,ENSmax,OverChargemax,UCf,tfix,lmax,savingdir,Ymatriz);
for n=1:nbus
    Gengmax(tfix,n)=Gengmaxtemp(n);
    Logmax(tfix,n)=Logmaxtemp(n);
    ENSgmax(tfix,n)=ENSgmaxtemp(n);
end

else
    GCfix=input('\n Critical error introduce a correct format[Col,Cmin,Cmax]');
end
end
end
savemaxtxt=strcat(savefilename,'maximos ENS.txt');
fres2=fopen(savemaxtxt,'w');
ttmp2=zeros(nbus,2);
ttmp3=zeros(2,1);
minmaxind=0;
[Npgtemp,ttemp]=max(ENSgmin);
ttmp2(:,1)=ttemp(:);
[NPGenmin,lnpgenmin]=max(Npgtemp);
ttmp3(1,1)=ttmp2(lnpgenmin,1);
fprintf(fres2,'\nMaximum Extra Power Generation:%4.2f needed in bus bar: %d, for time: %d, corresponting to %1.2f hours',NPGenmin,lnpgenmin,ttemp(lnpgenmin),24/T);

[Npgtemp,ttemp]=max(ENSgmax);
ttmp2(:,2)=ttemp(:);
[NPGenmax,lnpgenmax]=max(Npgtemp);
ttmp3(2,1)=ttmp2(lnpgenmax,2);
fprintf(fres2,'\nMaximum Extra Power Generation:%4.2f needed in bus bar: %d, for time: %d, corresponting to %1.2f hours',NPGenmax,lnpgenmax,ttemp(lnpgenmax),24/T);
if NPGenmin>NPGenmax
    NPgen=NPGenmin;
    lnpgen=lnpgenmin;
    tpgen=ttmp3(1,1);
    minmaxind=1;
else
    NPgen=NPGenmax;
    lnpgen=lnpgenmax;
    tpgen=ttmp3(2,1);
    minmaxind=2;
end
fclose(fres2);
movefile(savemaxtxt,savefilename,'f')
MCSsummary;
movefile(MCStext,savefilename,'f')
IntMCSOPFSummary;
movefile(inttext,savefilename,'f')
OPFSummary;
movefile(opftext,savefilename,'f')
if NPgen==0
else
    BUStemp=BUS;
    BRANCHtemp=BRANCH;
[GenNol,GenNmin,GenNmax,LoadNol,LoadNmin,LoadNmax,ENSNol,ENSNmin,ENSNmax,OverChargeNol,OverChargeNmin,OverChargeNmax,savefileNname]=newPSevalu(lftype,Ns,T,V,savefilename,MCSmin,MCSq1,MCSmean,MCSq3,MCSmax,lf,UCf,lmin,lmax,TScf,Ymatriz,BUS,BRANCH,Title,NPgen,lnpgen)
movefile(savefileNname,SCdir,'f')
OPFNPSSummary;
movefile(opfNtext,savefilename)
[SGenNol,SGenNmin,SGenNmax,SLoadNol,SLoadNmin,SLoadNmax,SENSNol,SENSNmin,SENSNmax,SOverChargeNol,SOverChargeNmin,SOverChargeNmax,SolarsavefileNname,NSPcap,Schf,BSScap,PVSScost]=SolarnewPSevalu(lftype,Ns,T,V,savefilename,MCSmin,MCSq1,MCSmean,MCSq3,MCSmax,lf,UCf,lmin,lmax,TScf,Ymatriz,BUStemp,BRANCHtemp,Title,NPgen,lnpgen,tpgen,ENSgmin,ENSgmax,minmaxind)
movefile(SolarsavefileNname,SCdir,'f')
SolarOPFNPSSummary;
movefile(SopfNtext,savefilename,'f')
end
movefile(savefilename,SCdir,'f')

end
end
