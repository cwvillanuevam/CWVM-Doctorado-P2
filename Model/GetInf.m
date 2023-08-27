function [NSPcap,Schf,BSScap,PVSScost,PVSScap]=GetInf(Sch,ntime,nbus,BUS,ENSgmin,ENSgmax,minmaxind,savingdir)
%% Cost USD / KW PV: 1000
%% Cost USD / KWh BESS: 400
tset.name='t';
tset.uels={1:ntime};

bset.name='b';
bset.uels={1:nbus};

if minmaxind==2
    Load=ENSgmax;
else
    Load=ENSgmin;
end

Ls.name='L';
Ls.val=Load;
Ls.form='full';
Ls.type='parameter';
Ls.uels={tset.uels bset.uels};

Spus.name='Spu';
Spus.val=Sch';
Spus.form='full';
Spus.type='parameter';
Spus.uels=tset.uels;

wgdx('SSSin',tset,bset,Ls,Spus);

system 'gams SSS.gms lo=0';

r1s.name='F';
r1s.form='full';
r1=rgdx('SSSout.gdx',r1s);
PVSScost=r1.val;

r2s.name='PVcap';
r2s.form='full';
r2s.uels={1:nbus};
r2=rgdx('SSSout.gdx',r2s);
NSPcap=r2.val;

r3s.name='PVSSp';
r3s.form='full';
r3s.uels={tset.uels bset.uels};
r3=rgdx('SSSout.gdx',r3s);
Schf=r3.val;
PVSScap=max(Schf)';

r4s.name='BSScap';
r4s.form='full';
r4s.uels={1:nbus};
r4=rgdx('SSSout.gdx',r4s);
BSScap=r4.val;

intxt="SSSin.gdx";
outtxt="SSSout.gdx";
movefile(intxt,savingdir)
movefile(outtxt,savingdir)

end