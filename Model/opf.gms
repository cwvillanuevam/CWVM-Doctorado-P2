SETs
nbus
nbusPV(nbus)
nbusPQ(nbus)
nbusSlack(nbus)
nlines
nrl(nlines,nbus)
nll(nlines,nbus)
*nbussum(nbus,nbus)
;

$gdxin in
$load nbus nbusPV nbusPQ nbusSlack nlines nrl nll
$gdxin

alias(nbus,nbusi,nbusj);

scalar
Mbig /100000000/
basemva /100/
tiop /0.25/
;

parameters
Vup(nbus) limite de voltajes
Vlo(nbus) limite de voltajes
deltaup(nbus) limite de angulos
deltalo(nbus) limite de angulos
Pd(nbus) potencia activa demandada
Qd(nbus) potencia reactiva demandada
Pgup(nbus) potencia activa generada
Pglo(nbus) potencia activa generada
Qgup(nbus) potencia reactiva generada
Qglo(nbus) potencia reactiva generada
*nr(nlines) line from
*nl(nlines) line to
*a(nlines) transformacion
Ym(nbus,nbus) valor de admitancia total de i a j
t(nbus,nbus) valor de angulo total de i a j
*basemva MVA base
limS(nlines) Potencia aparente maxima
*tiop tiempo de operacion
Vml(nbus) inital point Vm
deltal(nbus) inital point delta
Pgl(nbus) inital point Pg
Qgl(nbus) inital point Qg
PENSl(nbus) inital point PENS
;

$GDXIN in.gdx
$LOAD Vup Vlo deltaup deltalo Pd Qd Pgup Pglo Qgup Qglo Ym t limS Vml deltal Pgl Qgl PENSl
$GDXIN

Variables
F Funcion objetivo
F1 minimizacion externa
F2 Fo global
Vm(nbus) voltaje en barras
delta(nbus) angulos en barras
Pg(nbus) Potencia activa de generacion en barras
Qg(nbus) Potencia reactiva de generacion en barras
Yop1val(nlines,nbus,nbus) Valor absoluto de Ym no diagonal para cada condicion de operacion.
PENS(nbus) Potencia activa de energia no suministrada
hep(nbus) constante de holgura de equidad
heq(nbus) constante de holgura de equidad
Pfrom(nlines,nbusi,nbusj) Potencia activa de salida
Pto(nlines,nbusi,nbusj) Potencia activa de llegada
Qfrom(nlines,nbusi,nbusj) Potencia reactiva de salida
Qto(nlines,nbusi,nbusj) Potencia reactiva de llegada
Sfrom(nlines,nbusi,nbusj) Potencia aparente de salida
Sto(nlines,nbusi,nbusj) Potencia aparente de llegada
OChFrom(nlines) Sobrecarga aparente de salida
OChTo(nlines) Sobracarga aparente de llegada
SChFrom(nlines) Holgadura aparente de salida
SChTo(nlines) Holgadura aparente de llegada
;

positive variables
Vm(nbus)
Pg(nbus)
PENS(nbus)
hep(nbus)
heq(nbus)
Sfrom(nlines,nbusi,nbusj)
Sto(nlines,nbusi,nbusj)
OChFrom(nlines)
OChTo(nlines)
SChFrom(nlines)
SChTo(nlines)
;

EQUATIONS
OBJ,OBJ1,OBJ2, Yop1(nlines,nbus,nbus), Pnfrom(nlines,nbusi,nbusj),Pnto(nlines,nbusi,nbusj),Qnfrom(nlines,nbusi,nbusj),Qnto(nlines,nbusi,nbusj),RPPV(nbusPV), RQPV(nbusPV), RPPQ(nbusPQ), RQPQ(nbusPQ),Sfromeq1(nlines,nbusi,nbusj),Stoeq1(nlines,nbusi,nbusj),OChF(nlines,nbusi,nbusj),OChT(nlines,nbusi,nbusj);
OBJ.. F=E=sum(nbus,6000*PENS(nbus)*tiop)+sum(nbus,Mbig*hep(nbus)+Mbig*heq(nbus))+sum(nlines,(OChFrom(nlines)+OChTo(nlines))*tiop)+sum(nbusSlack,Pg(nbusSlack)*tiop);
OBJ1.. F1=E=sum(nbusSlack,Qg(nbusSlack)*tiop);
OBJ2.. F2=E=F+F1;
Yop1(nlines,nbusi,nbusj)$((nll(nlines,nbusi) $ nrl(nlines,nbusj)) or (nll(nlines,nbusj) $ nrl(nlines,nbusi))).. Yop1val(nlines,nbusi,nbusj)=E=Ym(nbusi,nbusj);
Pnfrom(nlines,nbusi,nbusj)$(nll(nlines,nbusi)$nrl(nlines,nbusj)).. Pfrom(nlines,nbusi,nbusj)=E=(Vm(nbusi)*Vm(nbusj)*Yop1val(nlines,nbusi,nbusj)*cos(t(nbusi,nbusj)-delta(nbusi)+delta(nbusj))-Vm(nbusi)*Vm(nbusi)*Yop1val(nlines,nbusi,nbusj)*cos(t(nbusi,nbusj)));
Pnto(nlines,nbusi,nbusj)$(nll(nlines,nbusi)$nrl(nlines,nbusj)).. Pto(nlines,nbusi,nbusj)=E=(Vm(nbusj)*Vm(nbusi)*Yop1val(nlines,nbusj,nbusi)*cos(t(nbusj,nbusi)-delta(nbusj)+delta(nbusi))-Vm(nbusj)*Vm(nbusj)*Yop1val(nlines,nbusj,nbusi)*cos(t(nbusj,nbusi)));
Qnfrom(nlines,nbusi,nbusj)$(nll(nlines,nbusi)$nrl(nlines,nbusj)).. Qfrom(nlines,nbusi,nbusj)=E=-(Vm(nbusi)*Vm(nbusj)*Yop1val(nlines,nbusi,nbusj)*sin(t(nbusi,nbusj)-delta(nbusi)+delta(nbusj))-Vm(nbusi)*Vm(nbusi)*Yop1val(nlines,nbusi,nbusj)*sin(t(nbusi,nbusj)));
Qnto(nlines,nbusi,nbusj)$(nll(nlines,nbusi)$nrl(nlines,nbusj)).. Qto(nlines,nbusi,nbusj)=E=-(Vm(nbusi)*Vm(nbusj)*Yop1val(nlines,nbusj,nbusi)*sin(t(nbusj,nbusi)-delta(nbusj)+delta(nbusi))-Vm(nbusj)*Vm(nbusj)*Yop1val(nlines,nbusj,nbusi)*sin(t(nbusj,nbusi)));
RPPV(nbusPV).. Pg(nbusPV)/basemva=G=hep(nbusPV)+Pd(nbusPV)/basemva+sum(nlines$(nll(nlines,nbusPV)),sum(nbusj$(nrl(nlines,nbusj)),Pfrom(nlines,nbusPV,nbusj)))+sum(nlines$(nrl(nlines,nbusPV)),sum(nbusi$(nll(nlines,nbusi)),Pto(nlines,nbusi,nbusPV)));
RQPV(nbusPV).. Qg(nbusPV)/basemva=G=heq(nbusPV)+Qd(nbusPV)/basemva+sum(nlines$(nll(nlines,nbusPV)),sum(nbusj$(nrl(nlines,nbusj)),Qfrom(nlines,nbusPV,nbusj)))+sum(nlines$(nrl(nlines,nbusPV)),sum(nbusi$(nll(nlines,nbusi)),Qto(nlines,nbusi,nbusPV)));
RPPQ(nbusPQ).. PENS(nbusPQ)/basemva=E=Pd(nbusPQ)/basemva+sum(nlines$(nll(nlines,nbusPQ)),sum(nbusj$(nrl(nlines,nbusj)),Pfrom(nlines,nbusPQ,nbusj)))+sum(nlines$(nrl(nlines,nbusPQ)),sum(nbusi$(nll(nlines,nbusi)),Pto(nlines,nbusi,nbusPQ)));
RQPQ(nbusPQ).. 0=G=heq(nbusPQ)+Qd(nbusPQ)/basemva+sum(nlines$(nll(nlines,nbusPQ)),sum(nbusj$(nrl(nlines,nbusj)),Qfrom(nlines,nbusPQ,nbusj)))+sum(nlines$(nrl(nlines,nbusPQ)),sum(nbusi$(nll(nlines,nbusi)),Qto(nlines,nbusi,nbusPQ)));
Sfromeq1(nlines,nbusi,nbusj)$(nll(nlines,nbusi)$nrl(nlines,nbusj)).. sqrt(power(Pfrom(nlines,nbusi,nbusj),2)+power(Qfrom(nlines,nbusi,nbusj),2))=E=Sfrom(nlines,nbusi,nbusj);
Stoeq1(nlines,nbusi,nbusj)$(nll(nlines,nbusi)$nrl(nlines,nbusj)).. sqrt(power(Pto(nlines,nbusi,nbusj),2)+power(Qto(nlines,nbusi,nbusj),2))=E=Sto(nlines,nbusi,nbusj);
OChF(nlines,nbusi,nbusj)$(nll(nlines,nbusi)$nrl(nlines,nbusj)).. (OChFrom(nlines)-SChFrom(nlines))/basemva=G=Sfrom(nlines,nbusi,nbusj)-limS(nlines);
OChT(nlines,nbusi,nbusj)$(nll(nlines,nbusi)$nrl(nlines,nbusj)).. (OChTo(nlines)-SChTo(nlines))/basemva=G=Sto(nlines,nbusi,nbusj)-limS(nlines);

*UPPER VALUES
Vm.up(nbus)=Vup(nbus);
delta.up(nbus)=deltaup(nbus);
Pg.up(nbus)=Pgup(nbus);
Qg.up(nbus)=Qgup(nbus);

PENS.up(nbus)=Pd(nbus);

*LOWER VALUES
Vm.lo(nbus)=Vlo(nbus);
delta.lo(nbus)=deltalo(nbus);
Pg.lo(nbus)=Pglo(nbus);
Qg.lo(nbus)=Qglo(nbus);


*Initial values
PENS.l(nbus)=PENSl(nbus);
*PENS.l(nbus)=0.001;
Pg.l(nbus)=Pgl(nbus);
Qg.l(nbus)=Qgl(nbus);
Vm.l(nbus)=Vml(nbus);
delta.l(nbus)=deltal(nbus);

MODEL OPF /ALL/;
*option NLP=CONOPT;
SOLVE OPF USING NLP MINIMIZING F2;

execute_unload 'out.gdx',F,Vm,delta,Pg,Qg,PENS,Pd,Qd,OChFrom,OChTo;
*,PENS

*$gdxout out
*$unload F Vm delta Pg Qg PENS Pd Qd Sfrom Sto
*$gdxout
