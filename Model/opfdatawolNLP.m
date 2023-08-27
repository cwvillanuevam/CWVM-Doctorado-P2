%% Comandos de inicio
% Type=evalin('base','Type');
% eval(Type);
% tempDB=DB;
nvcont=length(tempDB.buscontrol(:,1));
[basemva,busdata,linedata]=CallDB(tempDB);
lfybusi;
statements;
nbusset.name='nbus';
nbusset.uels={1:nbus};

ngenval=length(tempDB.gencost(:,1));
ngenset.name='ngen';
ngenset.uels={1:ngenval};

guel = @(s,v) strcat(s,strsplit(num2str(v)));
nrdat=length(tempDB.rerdata(:,1));
for r=1:nrdat
nrerval(r,1)=tempDB.rerdata(r,1);
end
nrerset.name='nrer';
nrerset.type='set';
nrerset.dim=1;
nrerset.form='sparse';
nrerset.uels={guel('',1:ngenval)};
nrerset.val=nrerval;

nbusPQ=[];
PQindex=0;
nbusPV=[];
PVindex=0;
for b=1:nbus
    if kb(b)==0,
        PQindex=PQindex+1;
        nbusPQ(1,PQindex)=b;
    else
        PVindex=PVindex+1;
        nbusPV(1,PVindex)=b;
    end
end
nbusPQset.name='nbusPQ';
nbusPQset.uels={nbusPQ};
nbusPVset.name='nbusPV';
nbusPVset.uels={nbusPV};
nlinesset.name='nlines';
nlinesset.uels={1:nbr};

nopset.name='nop';
nopset.uels={1:ncont+1};

noppset.name='nopp';
noppset.uels={1};

%% Salida de datos ante contingencia
nbuscval=[]
indc=0;

if ncont==0;
else
for op=1:ncont
    if op<5
    indc=indc+1;
    nbuscval(indc,1)=2;
    nbuscval(indc,2)=op+1;
    end
end

nbuscset.name='nbusc';
nbuscset.type='set';
nbuscset.dim=2;
nbuscset.form='sparse';
nbuscset.uels={guel('',1:nbus),guel('',1:ncont+1)};
nbuscset.val=nbuscval;
end
nrval=[];
nlval=[];
for l=1:nbr
    nrval(l,1)=l;
    nrval(l,2)=nr(l);
    nlval(l,1)=l;
    nlval(l,2)=nl(l);
end

nrset.name='nrl';
nrset.type='set';
nrset.dim=2;
nrset.form='sparse';
nrset.uels={guel('',1:nbr),guel('',1:nbus)};
nrset.val=nrval;

nlset.name='nll';
nlset.type='set';
nlset.dim=2;
nlset.form='sparse';
nlset.uels={guel('',1:nbr),guel('',1:nbus)};
nlset.val=nlval;

ngenbusval=[];
for g=1:ngenval
    ngenbusval(g,1)=g;
    ngenbusval(g,2)=tempDB.gencost(g,1);
end
ngenbusset.name='ngenbus';
ngenbusset.type='set';
ngenbusset.dim=2;
ngenbusset.form='sparse';
ngenbusset.uels={guel('',1:ngen),guel('',1:nbus)};
ngenbusset.val=ngenbusval;

nbussumval=[];
for i=1:nbus
    ind=1;
    for j=1:nbus
        if i==j
        else
        nbussumval((nbus-1)*(i-1)+ind,1)=i;
        nbussumval((nbus-1)*(i-1)+ind,2)=j;
        ind=ind+1;
        end
    end
end

      
nbussumset.name='nbussum';
nbussumset.type='set';
nbussumset.dim=2;
nbussumset.form='sparse';
nbussumset.uels={guel('',1:nbus),guel('',1:nbus)};
nbussumset.val=nbussumval;

noleset.name='nole';
noleset.uels={1:nole};

%% Parametros
Pdval=zeros(nbus,nole);
Qdval=zeros(nbus,nole);
for b=1:nbus
for le=1:nole
    Pdval(b,le)=tempDB.lechargedata(b,le*2);
    Qdval(b,le)=tempDB.lechargedata(b,le*2+1);
end
end

Qshval=Qsh';
%a
% Ym
% t
agval=ag';
bgval=bg';
cgval=cg';

%% limites
Vupval=ones(nbus,ncont+1);
Vloval=ones(nbus,ncont+1);
deltaupval=zeros(nbus,1);
deltaloval=zeros(nbus,1);
Pgupval=zeros(ngenval,nole);
Pgloval=zeros(ngenval,nole);
for g=1:ngenval
    for le=1:nole
    Pgloval(g,le)=tempDB.gendata(g,2*le);
    Pgupval(g,le)=tempDB.gendata(g,2*le+1);
    end
end
Qgupval=zeros(nbus,1);
Qgloval=zeros(nbus,1);
Vmin1=input('Ingrese el valor mínimo de voltaje op normal:');
Vmax1=input('Ingrese el valor máximo de voltaje op normal:');
Vmin2=input('Ingrese el valor mínimo de voltaje op n-1:');
Vmax2=input('Ingrese el valor máximo de voltaje op n-1:');
for b=1:nbus
if kb(b)==0
    Vloval(b,1)=Vmin1;
    Vupval(b,1)=Vmax1;
    for op=1:ncont
    Vloval(b,1+op)=Vmin2;
    Vupval(b,1+op)=Vmax2;
    end
    Qgloval(b)=busdata(b,9);
    Qgupval(b)=busdata(b,10);
else
    Vloval(b,:)=Vm(b);
    Vupval(b,:)=Vm(b);
    Qgloval(b)=busdata(b,9);
    Qgupval(b)=busdata(b,10);    
end
    for bc=1:nvcont
        if b==tempDB.buscontrol(bc,1)
            Vloval(b,:)=tempDB.buscontrol(bc,2);
            Vupval(b,:)=tempDB.buscontrol(bc,3);
        end
    end
end
for b=1:nbus
    if kb(b)==1
        deltaloval(b)=delta(b);
        deltaupval(b)=delta(b);
    else
        deltaloval(b)=-pi()/2;
        deltaupval(b)=pi()/2; 
    end
%     Vmlval(b)=tempDB.initialpoint(b,1);
%     deltalval(b)=tempDB.initialpoint(b,2);
%     Pglval(b)=tempDB.initialpoint(b,3);
%     Qglval(b)=tempDB.initialpoint(b,4);
%     PENSlval(b)=tempDB.initialpoint(b,5);
end

% Vmls.name='Vml';
% Vmls.val=Vmlval;
% Vmls.form='full';
% Vmls.type='parameter';
% Vmls.uels=nbusset.uels;
% 
% deltals.name='deltal';
% deltals.val=deltalval;
% deltals.form='full';
% deltals.type='parameter';
% deltals.uels=nbusset.uels;
% 
% Pgls.name='Pgl';
% Pgls.val=Pglval;
% Pgls.form='full';
% Pgls.type='parameter';
% Pgls.uels=nbusset.uels;
% 
% Qgls.name='Qgl';
% Qgls.val=Qglval;
% Qgls.form='full';
% Qgls.type='parameter';
% Qgls.uels=nbusset.uels;
% 
% PENSls.name='PENSl';
% PENSls.val=PENSlval;
% PENSls.form='full';
% PENSls.type='parameter';
% PENSls.uels=nbusset.uels;

limSval=Smax;
vups.name='Vup';
vups.val=Vupval;
vups.form='full';
vups.type='parameter';
vups.uels={nbusset.uels nopset.uels};

vlos.name='Vlo';
vlos.val=Vloval;
vlos.form='full';
vlos.type='parameter';
vlos.uels={nbusset.uels nopset.uels};

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

Pds.name='Pd';
Pds.val=Pdval;
Pds.form='full';
Pds.type='parameter';
Pds.uels={nbusset.uels noleset.uels};

Qds.name='Qd';
Qds.val=Qdval;
Qds.form='full';
Qds.type='parameter';
Qds.uels={nbusset.uels noleset.uels};

Qshs.name='Qsh';
Qshs.val=Qshval;
Qshs.form='full';
Qshs.type='parameter';
Qshs.uels=nbusset.uels;

Pgups.name='Pgup';
Pgups.val=Pgupval;
Pgups.form='full';
Pgups.type='parameter';
Pgups.uels={ngenset.uels noleset.uels};

Pglos.name='Pglo';
Pglos.val=Pgloval;
Pglos.form='full';
Pglos.type='parameter';
Pglos.uels={ngenset.uels noleset.uels};

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


as.name='a';
as.val=a;
as.form='full';
as.type='parameter';
as.uels=nlinesset.uels;

Yms.name='Ym';
Yms.val=Ym;
Yms.form='full';
Yms.type='parameter';
Yms.uels={nbusset.uels nbusset.uels};

ts.name='t';
ts.val=t;
ts.form='full';
ts.type='parameter';
ts.uels={nbusset.uels nbusset.uels};

ags.name='ag';
ags.val=agval;
ags.form='full';
ags.type='parameter';
ags.uels=ngenset.uels;

bgs.name='bg';
bgs.val=bgval;
bgs.form='full';
bgs.type='parameter';
bgs.uels=ngenset.uels;

cgs.name='cg';
cgs.val=cgval;
cgs.form='full';
cgs.type='parameter';
cgs.uels=ngenset.uels;

basemvas.name='basemva';
basemvas.val=basemva;
basemvas.form='full';
basemvas.type='parameter';

limSs.name='limS';
limSs.val=limSval;
limSs.form='full';
limSs.type='parameter';
limSs.uels=nlinesset.uels;

disclval=zeros(nbr,ncont+1);
ntlupval=zeros(nbr,1);
ntlloval=zeros(nbr,1);
cilval=zeros(nbr,1);
for l=1:nbr
    for op=1:ncont
        if tempDB.contingency(op,1)==l
            disclval(l,op+1)=1;
        end
    end
    ntlupval(l,1)=tempDB.reinforces(l,3);
    ntlloval(l,1)=tempDB.reinforces(l,2);
    cilval(l,1)=tempDB.reinforces(l,4);
end

discls.name='discl';
discls.val=disclval;
discls.form='full';
discls.type='parameter';
discls.uels={nlinesset.uels nopset.uels};

r11s.name='ntl';
r11s.form='sparse';
r11=rgdx('out.gdx',r11s);
ntllval=r11.val;

ntlls.name='ntl';
ntlls.form='sparse';
ntlls.type='parameter';
ntlls.uels=nlinesset.uels;
ntlls.val=floor(ntllval);

ntlups.name='ntlup';
ntlups.form='full';
ntlups.type='parameter';
ntlups.uels=nlinesset.uels;
ntlups.val=ntlupval;

ntllos.name='ntllo';
ntllos.val=ntlloval;
ntllos.form='full';
ntllos.type='parameter';
ntllos.uels=nlinesset.uels;

cils.name='cil';
cils.val=cilval;
cils.form='full';
cils.type='parameter';
cils.uels=nlinesset.uels;

abval=zeros(nbr,1);
for l=1:nbr
    abval(l)=1-tempDB.linedata(l,9);
end

abs.name='ab';
abs.val=abval;
abs.form='full';
abs.type='parameter';
abs.uels=nlinesset.uels;

Profaval=ones(ncont+1,1);
tiopval=ones(ncont+1,nole);
for le=1:nole
tiopval(1,le)=tempDB.loadescdata(le,2);
end
for op=1:ncont
    Profaval(op+1,1)=tempDB.linedata(tempDB.contingency(op,1),9);
    tiopval(op+1,:)=tempDB.linedata(tempDB.contingency(op,1),8);
end

Profas.name='Profa';
Profas.val=Profaval;
Profas.form='full';
Profas.type='parameter';
Profas.uels=nopset.uels;

tiops.name='tiop';
tiops.val=tiopval;
tiops.form='full';
tiops.type='parameter';
tiops.uels={nopset.uels noleset.uels};

r2s.name='Vm';
r2s.form='sparse';
r2=rgdx('out.gdx',r2s);
Vmlval=r2.val;

Vmls.name='Vml';
Vmls.form='sparse';
Vmls.type='parameter';
Vmls.uels={nbusset.uels nopset.uels noleset.uels};
Vmls.val=Vmlval;

r4s.name='Pg';
r4s.form='sparse';
r4=rgdx('out.gdx',r4s);
Pglval=r4.val;

Pgls.name='Pgl';
Pgls.form='sparse';
Pgls.type='parameter';
Pgls.uels={ngenset.uels nopset.uels noleset.uels};
Pgls.val=Pglval;



if ncont==0
    wgdx('in',nbusset,nbusPVset,nbusPQset,nlinesset,nrset,nlset,nopset,noppset,nbussumset,noleset,nrerset,...
    ngenset,ngenbusset,vups,vlos,deltaups,deltalos,Pds,Qds,Qshs,Pgups,Pglos,Qgups,Qglos,as,Yms,ts,ags,bgs,cgs,...
    basemvas,limSs,discls,ntlups,ntllos,cils,abs,Profas,tiops,Vmls,Pgls,ntlls);
else
wgdx('in',nbusset,nbusPVset,nbusPQset,nlinesset,nrset,nlset,nopset,noppset,nbussumset,noleset,nrerset,...
    ngenset,ngenbusset,nbuscset,vups,vlos,deltaups,deltalos,Pds,Qds,Qshs,Pgups,Pglos,Qgups,Qglos,as,Yms,ts,ags,bgs,cgs,...
    basemvas,limSs,discls,ntlups,ntllos,cils,abs,Profas,tiops,Vmls,Pgls,ntlls);
%,Vmls,deltals,Pgls,Qgls,PENSls 
end