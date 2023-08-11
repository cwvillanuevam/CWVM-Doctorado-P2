SETs
t
b
;

$gdxin SSSin
$load t b
$gdxin

scalar
PVcost /1000000/
*cost in USD per MW
BSScost /400000/
*cost in USD per MWh
deltat /0.5/
*time considered
;

parameters
L(t,b) Load that need to be supplied
Spu(t) Solar daily patterns per kWp
;

$GDXIN SSSin.gdx
$LOAD L Spu
$GDXIN

Variables
F Funcion objetivo
BEV(t,b) Battery Energy Variation
;

positive variables
BSScap(b) Battery storage system capacity in MWh
SoC(t,b) State of Charge in MWh
PVcap(b) Photo Voltaic Capacity MW
PVSSp(t,b) Photo Voltaic - Storage System Power
;
SoC.fx('1',b)=0;

EQUATIONS
OBJ,DailySupply(t,b),StateOfCharge(t,b),SoCfinal(t,b),PVSSdef(t,b),BEVupb(t,b),BEVlob(t,b),SoCupb(t,b);
OBJ.. F=E=sum(b,PVcost*PVcap(b))+sum(b,BSScost*BSScap(b));
DailySupply(t,b).. deltat*PVcap(b)*Spu(t)=G=deltat*L(t,b)+BEV(t,b);
StateOfCharge(t,b).. SoC(t,b)=E=SoC(t-1,b)+BEV(t-1,b);
SoCfinal('1',b).. SoC('1',b)=E=SoC('48',b)+BEV('48',b);
PVSSdef(t,b).. PVSSp(t,b)=E=PVcap(b)*Spu(t)-BEV(t,b)/deltat;
BEVupb(t,b).. BEV(t,b)=L=BSScap(b);
BEVlob(t,b).. BEV(t,b)=G=-BSScap(b);
SoCupb(t,b).. SoC(t,b)=L=BSScap(b);

*UPPER VALUES

*LOWER VALUES
SoC.lo(t,b)=0;
PVSSp.lo(t,b)=0;

*Initial values

MODEL SSS /ALL/;
SOLVE SSS USING LP MINIMIZING F;

execute_unload 'SSSout.gdx',F,PVcap,BSScap,BEV,SoC,PVSSp;

*$gdxout out
*$unload F Vm delta Pg Qg PENS Pd Qd Sfrom Sto
*$gdxout
