function [Genol,Genmin,Genmax,Loadol,Loadmin,Loadmax,ENSol,ENSmin,ENSmax,OverChargeol,OverChargemin,OverChargemax,savefilename,MCSmin,MCSq1,MCSmean,MCSq3,MCSmax]=ejecutableopf2(PStype,lftype,Ns,T,V)
%% This script set the input data run the optimizer and set the output
%Define the previous parametric data
[Title,BUS,BRANCH]=readcdf2(PStype);
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


Genol=zeros(ntime,1);
Loadol=zeros(ntime,1);
ENSol=zeros(ntime,1);
OverChargeol=zeros(ntime,1);

%% Seteamos el nombre del archivo txt de resultados
Type=Title.case;
savingtxt=strcat(Type,'validacion.txt');
savingdir=strcat(Type,'validacion');
version=1;
while exist(savingdir,'file')==7
    savingtxt=strcat(Type,'validacion','v',num2str(version),'.txt');
    savingdir=strcat(Type,'validacion','v',num2str(version));
    version=version+1;
end
cd(pwd);
%% Relicability from only load
fres=fopen(savingtxt,'w');
fprintf(fres,'Resultados de la optimizacion solo carga sin EVs\n');

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
% 
% OType='out.gdx';
% if exist(OType,'file')==2
%    r1s.name='Vm';
%    r1s.form='sparse';
%    r1=rgdx('out.gdx',r1s);
%    Vmlval=r1.val(:,2);
% 
%    r2s.name='delta';
%    r2s.form='sparse';
%    r2=rgdx('out.gdx',r2s);
%    deltalval=r2.val(:,2);

% else
    [Vmlval,deltalval]=FlatStart(BUS);
% end
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
%  
%  OL.nbusset(t)=nbusset;
%  OL.nbusPVset(t)=nbusPVset;
%  OL.nbusPQset(t)=nbusPQset;
%  OL.nbusSlackset(t)=nbusSlackset;
%  OL.nlinesset(t)=nlinesset;
%  OL.nrset(t)=nrset;
%  OL.nlset(t)=nlset;
%  OL.Yms(t)=Yms;
%  OL.ts(t)=ts;
%  OL.vups(t)=vups;
%  OL.vlos(t)=vlos;
%  OL.vmls(t)=vmls;
%  OL.deltaups(t)=deltaups;
%  OL.deltalos(t)=deltalos;
%  OL.deltals(t)=deltals;
%  OL.Pgups(t)=Pgups;
%  OL.Pglos(t)=Pglos;
%  OL.Pgls(t)=Pgls;
%  OL.Qgups(t)=Qgups;
%  OL.Qglos(t)=Qglos;
%  OL.Qgls(t)=Qgls;
%  OL.limSs(t)=limSs;
%  OL.Pds(t)=Pds;
%  OL.Qds(t)=Qds;
%  OL.PENSups(t)=PENSups;
%  OL.PENSlos(t)=PENSlos;
%  OL.PENSls(t)=PENSls;    
%     
 wgdx('in',nbusset,nbusPVset,nbusPQset,nbusSlackset,nlinesset,nrset,nlset,...
 Yms,ts,vups,vlos,vmls,deltaups,deltalos,deltals,Pgups,Pglos,Pgls,Qgups,...
 Qglos,Qgls,limSs,Pds,Qds,PENSups,PENSlos,PENSls);
%,basemvas,tiops
system 'gams opf.gms lo=0';
end
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
for n=1:nbus
    Gengol(t,n)=Pgol(n);
    Logol(t,n)=Pdol(n);
    ENSgol(t,n)=PENSol(n);
end
OverChargeol(t)=sum(OChol);
fprintf(fres,'t= %d \t ',t);
fprintf(fres,'Pg=%8.4f \t Pd=%8.4f \t ENS= %6.2f \t OverCharge= %6.2f\n',...
    Genol(t),Loadol(t),ENSol(t),OverChargeol(t));
end
fprintf(fres,'Overcharge general \n Line:');
for l=1:nbr
    fprintf(fres,'\t %6d',l);
end
for t=1:ntime
    fprintf(fres,'\n t: \t %d',t);
   for l=1:nbr
fprintf(fres,'\t %6.2f',Ochgol(t,l));
   end
end
fprintf(fres,'Power Generation general \n Bus:');
for n=1:nbus
    fprintf(fres,'\t %6d',n);
end
for t=1:ntime
    fprintf(fres,'\n t: \t %d',t);
   for n=1:nbus
fprintf(fres,'\t %6.2f',Gengol(t,n));
   end
end

[MCSmin,lmin,MCSq1,MCSmean,MCSq3,MCSmax,lmax,Rf,Xf,UCf]=MCSopt(PStype,Ns,T,V);
%% Relicability from only load min
fprintf(fres,'Resultados de la optimizacion minima carga requerida\n');

%% Now set time dependent variables for only load modelling

for t=1:ntime
    Pdval=zeros(nbus,1);
    Qdval=zeros(nbus,1);
    PENSupval=zeros(nbus,1);
for n=1:nbus
    if BUS.AreaFCBus(n,1)==1
        Pdval(n)=BUS.PCarBus(n,1)*lf.MT(t,1)+sum(UCf(lmin,t,:,n))*4;
        Qdval(n)=BUS.QCarBus(n,1)*lf.MT(t,1);
    else
        Pdval(n)=BUS.PCarBus(n,1)*lf.BT(t,1)+sum(UCf(lmin,t,:,n))*4;
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

% OType='out.gdx';
% if exist(OType,'file')==2
%    r1s.name='Vm';
%    r1s.form='sparse';
%    r1=rgdx('out.gdx',r1s);
%    Vmlval=r1.val(:,2);
% 
%    r2s.name='delta';
%    r2s.form='sparse';
%    r2=rgdx('out.gdx',r2s);
%    deltalval=r2.val(:,2);

% else
    [Vmlval,deltalval]=FlatStart(BUS);
% end
vmls.val=Vmlval;
deltals.val=deltalval;
% 
%  MIN.nbusset(t)=nbusset;
%  MIN.nbusPVset(t)=nbusPVset;
%  MIN.nbusPQset(t)=nbusPQset;
%  MIN.nbusSlackset(t)=nbusSlackset;
%  MIN.nlinesset(t)=nlinesset;
%  MIN.nrset(t)=nrset;
%  MIN.nlset(t)=nlset;
%  MIN.Yms(t)=Yms;
%  MIN.ts(t)=ts;
%  MIN.vups(t)=vups;
%  MIN.vlos(t)=vlos;
%  MIN.vmls(t)=vmls;
%  MIN.deltaups(t)=deltaups;
%  MIN.deltalos(t)=deltalos;
%  MIN.deltals(t)=deltals;
%  MIN.Pgups(t)=Pgups;
%  MIN.Pglos(t)=Pglos;
%  MIN.Pgls(t)=Pgls;
%  MIN.Qgups(t)=Qgups;
%  MIN.Qglos(t)=Qglos;
%  MIN.Qgls(t)=Qgls;
%  MIN.limSs(t)=limSs;
%  MIN.Pds(t)=Pds;
%  MIN.Qds(t)=Qds;
%  MIN.PENSups(t)=PENSups;
%  MIN.PENSlos(t)=PENSlos;
%  MIN.PENSls(t)=PENSls;    

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
fprintf(fres,'t= %d \t ',t);
fprintf(fres,'Pg=%8.4f \t Pd=%8.4f \t ENS= %6.2f \t OverCharge= %6.2f\n',...
    Genmin(t),Loadmin(t),ENSmin(t),OverChargemin(t));
end
fprintf(fres,'Overcharge general \n Line:');
for l=1:nbr
    fprintf(fres,'\t %6d',l);
end
for t=1:ntime
    fprintf(fres,'\n t: \t %d',t);
   for l=1:nbr
fprintf(fres,'\t %6.2f',Ochgmin(t,l));
   end
end
fprintf(fres,'Power Generation general \n Bus:');
for n=1:nbus
    fprintf(fres,'\t %6d',n);
end
for t=1:ntime
    fprintf(fres,'\n t: \t %d',t);
   for n=1:nbus
fprintf(fres,'\t %6.2f',Gengmin(t,n));
   end
end

%% Relicability from only load max
fprintf(fres,'Resultados de la optimizacion maxima carga requerida\n');

%% Now set time dependent variables for only load modelling

for t=1:ntime
    Pdval=zeros(nbus,1);
    Qdval=zeros(nbus,1);
    PENSupval=zeros(nbus,1);
for n=1:nbus
    if BUS.AreaFCBus(n,1)==1
        Pdval(n)=BUS.PCarBus(n,1)*lf.MT(t,1)+sum(UCf(lmax,t,:,n))*4;
        Qdval(n)=BUS.QCarBus(n,1)*lf.MT(t,1);
    else
        Pdval(n)=BUS.PCarBus(n,1)*lf.BT(t,1)+sum(UCf(lmax,t,:,n))*4;
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

% OType='out.gdx';
% if exist(OType,'file')==2
%    r1s.name='Vm';
%    r1s.form='sparse';
%    r1=rgdx('out.gdx',r1s);
%    vmlval=r1.val(:,2);
% 
%    r2s.name='delta';
%    r2s.form='sparse';
%    r2=rgdx('out.gdx',r2s);
%    deltalval=r2.val(:,2);

% else
    [Vmlval,deltalval]=FlatStart(BUS);
% end
vmls.val=Vmlval;
deltals.val=deltalval;
% 
%  MAX.nbusset(t)=nbusset;
%  MAX.nbusPVset(t)=nbusPVset;
%  MAX.nbusPQset(t)=nbusPQset;
%  MAX.nbusSlackset(t)=nbusSlackset;
%  MAX.nlinesset(t)=nlinesset;
%  MAX.nrset(t)=nrset;
%  MAX.nlset(t)=nlset;
%  MAX.Yms(t)=Yms;
%  MAX.ts(t)=ts;
%  MAX.vups(t)=vups;
%  MAX.vlos(t)=vlos;
%  MAX.vmls(t)=vmls;
%  MAX.deltaups(t)=deltaups;
%  MAX.deltalos(t)=deltalos;
%  MAX.deltals(t)=deltals;
%  MAX.Pgups(t)=Pgups;
%  MAX.Pglos(t)=Pglos;
%  MAX.Pgls(t)=Pgls;
%  MAX.Qgups(t)=Qgups;
%  MAX.Qglos(t)=Qglos;
%  MAX.Qgls(t)=Qgls;
%  MAX.limSs(t)=limSs;
%  MAX.Pds(t)=Pds;
%  MAX.Qds(t)=Qds;
%  MAX.PENSups(t)=PENSups;
%  MAX.PENSlos(t)=PENSlos;
%  MAX.PENSls(t)=PENSls;    

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
fprintf(fres,'t= %d \t ',t);
fprintf(fres,'Pg=%8.4f \t Pd=%8.4f \t ENS= %6.2f \t OverCharge= %6.2f\n',...
    Genmax(t),Loadmax(t),ENSmax(t),OverChargemax(t));
end
fprintf(fres,'Overcharge general \n Line:');
for l=1:nbr
    fprintf(fres,'\t %6d',l);
end
for t=1:ntime
    fprintf(fres,'\n t: \t %d',t);
   for l=1:nbr
fprintf(fres,'\t %6.2f',Ochgmax(t,l));
   end
end
fprintf(fres,'Power Generation general \n Bus:');
for n=1:nbus
    fprintf(fres,'\t %6d',n);
end
for t=1:ntime
    fprintf(fres,'\n t: \t %d',t);
   for n=1:nbus
fprintf(fres,'\t %6.2f',Gengmax(t,n));
   end
end


fclose(fres);
mkdir(savingdir)
movefile(savingtxt,savingdir)
savefilename=savingdir;
t=1:ntime;
subplot(2,2,1)
plot(t,Loadol,t,Loadmin,t,Loadmax,'g');
lgd=legend({'Only Load scenario','Minimun EV Charge Load Scenario','Maximun EV charge Load Scenario'},'location','south');
lgd.FontSize=8;
title('Load in all scenarios');
xlabel('time 1/4 h');
ylabel('MW');
subplot(2,2,2)
plot(t,Genol,'b',t,Loadol,'k',t,ENSol,'r',t,OverChargeol,'g');
title('Only Load, without EV charging')
lgd1=legend({'Generation','Load','Energy Not Served','Overcharge'},'location','south');
lgd1.FontSize=8;
xlabel('time 1/4 h');
ylabel('MW');
subplot(2,2,3)
plot(t,Genmin,'b',t,Loadmin,'k',t,ENSmin,'r',t,OverChargemin,'g');
title('Load and minimun EV charging Load');
lgd2=legend({'Generation','Load','Energy Not Served','Overcharge'},'location','south');
lgd2.FontSize=8;
xlabel('time 1/4 h');
ylabel('MW');
subplot(2,2,4)
plot(t,Genmax,'b',t,Loadmax,'k',t,ENSmax,'r',t,OverChargemax,'g');
title('Load and maximun EV charging Load');
lgd3=legend({'Generation','Load','Energy Not Served','Overcharge'},'location','south');
lgd3.FontSize=8;
xlabel('time 1/4 h');
ylabel('MW');
end
