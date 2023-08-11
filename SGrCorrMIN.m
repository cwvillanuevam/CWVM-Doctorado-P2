function [Gengmin,Logmin,ENSgmin,Genmin,Loadmin,ENSmin,OverChargemin,SolarStorageGmin,SSGgmin]=SGrCorrMIN(lf,BUS,BRANCH,Title,Genmini,Loadmini,ENSmini,OverChargemini,UCf,t,lmin,savefilename,Ymatriz,Schf,lnpgen)
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

% [Ymatriz]=Ymat(PStype);

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

Pglos.name='Pglo';
Pglos.val=Pgloval;
Pglos.form='full';
Pglos.type='parameter';
Pglos.uels=nbusset.uels;

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

ntime=length(lf.MT(:,1));

%% Seteamos el nombre del archivo txt de resultados
Type=Title.case;
savingtxt=strcat(Type,'Correction',savefilename,'MIN',num2str(t),'.txt');
savingdir=strcat(savefilename,'Correcction');
cd(pwd);

%% Open new file seting correction
fresmin=fopen(savingtxt,'w');
fprintf(fresmin,'\n Resultados de la optimizacion solo carga sin EVs\n');

%% Now use time dependent variables for MIN modelling
    Pdval=zeros(nbus,1);
    Qdval=zeros(nbus,1);
    PENSupval=zeros(nbus,1);
for n=1:nbus
    if BUS.AreaFCBus(n,1)==1
        Pdval(n)=BUS.PCarBus(n,1)*lf.MT(t,1)+sum(UCf(lmin,t,n))*4;
        Qdval(n)=BUS.QCarBus(n,1)*lf.MT(t,1);
    else
        Pdval(n)=BUS.PCarBus(n,1)*lf.BT(t,1)+sum(UCf(lmin,n))*4;
        Qdval(n)=BUS.QCarBus(n,1)*lf.BT(t,1);
    end
    PENSupval(n)=Pdval(n);
Pgupval(n)=Pgupval(n)+Schf(t,n);
Pglval(n)=Pglval(n)+Schf(t,n);

end

Pgups.name='Pgup';
Pgups.val=Pgupval;
Pgups.form='full';
Pgups.type='parameter';
Pgups.uels=nbusset.uels;

Pgls.name='Pgl';
Pgls.val=Pglval;
Pgls.form='full';
Pgls.type='parameter';
Pgls.uels=nbusset.uels;

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
SSGgmin=0;
for n=1:nbus
    if Pgmin(n,1)>Schf(t,n)
        SolarStorageGmin(n)=Schf(t,n);
    else
        SolarStorageGmin(n)=Pgmin(n);
    end
    SSGgmin=SSGgmin+SolarStorageGmin(n);
end


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
Genmin=Genmini;
Loadmin=Loadmini;
ENSmin=ENSmini;
OverChargemin=OverChargemini;
Genmin(t)=sum(Pgmin);
Loadmin(t)=sum(Pdmin);
ENSmin(t)=sum(PENSmin);

for l=1:nbr
if OChFrommin(l)<OChTomin(l)
    OChmin(l)=OChTomin(l);
else
    OChmin(l)=OChFrommin(l);
end
Ochgmin(l)=OChmin(l);
end
for n=1:nbus
    Gengmin(n)=Pgmin(n);
    Logmin(n)=Pdmin(n);
    ENSgmin(n)=PENSmin(n);
end
OverChargemin(t)=sum(OChmin);
fprintf(fresmin,'t= %d \t ',t);
fprintf(fresmin,'Pg=%8.4f \t Pd=%8.4f \t ENS= %6.2f \t OverCharge= %6.2f\n',...
    Genmini(t),Loadmini(t),ENSmini(t),OverChargemini(t));

fprintf(fresmin,'\n Overcharge general \n Line:');
for l=1:nbr
    fprintf(fresmin,'\n %6d',l);
    fprintf(fresmin,'\t t: \t %d',t);
    fprintf(fresmin,'\t %6.2f',Ochgmin(l));
end
fprintf(fresmin,'\n Power Generation general \n Bus:');
for n=1:nbus
    fprintf(fresmin,'\n %6d',n);
    fprintf(fresmin,'\t t: \t %d',t);
    fprintf(fresmin,'\t %6.2f',Gengmin(n));
end

fprintf(fresmin,'\n Power Energy Not Served \n Bus:');
for n=1:nbus
    fprintf(fresmin,'\n %6d',n);
    fprintf(fresmin,'\t t: \t %d',t);
    fprintf(fresmin,'\t %6.2f',ENSgmin(n));
end

fclose(fresmin);
% fclose('all');
movefile(savingtxt,savingdir,'f');
end