function [R,X,UC,TSc]=mksample(PStype,pddep,pdarr,T,V)
%% Preparing data to eval probabilistic distributions of departure and arriving time
rng('shuffle');
[Title,BUS,BRANCH]=readcdf2(PStype); %reading power system data (psd)
stocdata; %Reading mean stochastic data
nbus=length(BUS.NumBus(:,1));
[TD,FR,TO,TS]=traveldistancecharact(BUS,BRANCH,tdf,V); %Based in psd estimate travel distance
% Probabilistic distribution characteristic travel speed
TSc=TS;
pdhts=makedist('normal','mu',speeddata(1,1),'sigma',speeddata(1,2));
pdmts=makedist('normal','mu',speeddata(2,1),'sigma',speeddata(2,2));
pdlts=makedist('normal','mu',speeddata(3,1),'sigma',speeddata(3,2));
CTS=ones(T,1); %Predefinning Characteristic travel speed (1:hts,2:mts,3:lts)
ncts=length(charactts(:,1));
% Assignin CTS.
for t=1:T
    for tsstep=1:ncts
        if t>=charactts(tsstep,1)
            CTS(t)=charactts(tsstep,2);
        else
        end
    end
end
% Developping energy consumption and departure and arrive sample times
CE=CEmin+(CEmax-CEmin)*rand(V,1);
valdep=pruebav11(pddep,0,24,V);
valarr=pruebav11(pdarr,25,56,V);
% Presetting speed value matrix in time
valspeed=zeros(T,1);

%% Setting R: Road battery energy consumption, X:Binary state of travel &
% UC: Uncontrolled grid charge consumption.
depini=zeros(V,1);
depend=zeros(V,1);
arrini=zeros(V,1);
arrend=zeros(V,1);
% Define speed value samples according to traffic patterns in road
for t=1:T
    if CTS(t)==1
        valspeed(t)=prueba11(pdhts,10,100); %,t*S
    elseif CTS(t)==2
        valspeed(t)=prueba11(pdmts,10,100); %,t*S
    else
        valspeed(t)=prueba11(pdlts,10,100); %,t*S
    end
end
% Predefine R,X,UC
R=zeros(T,V);
X=zeros(T,V);
UC=zeros(T,V,nbus);

for v=1:V
depini(v,1)=round(valdep(v));
if depini(v,1)==0
    td=1;
else
td=depini(v,1);
end
% Assign Road data for arriving home travel
arrend(v,1)=round(valarr(v));

if arrend(v,1)>T
    ta=arrend(v,1)-T;
else
    ta=arrend(v,1);
end
while abs(ta-td)<3
valdeptmp=pruebav11(pddep,0,24,1);
valarrtmp=pruebav11(pdarr,25,56,1);
valdep(v)=valdeptmp;
valarr(v)=valarrtmp;
depini(v,1)=round(valdep(v));
if depini(v,1)==0
    td=1;
else
td=depini(v,1);
end
% Assign Road data for arriving home travel
arrend(v,1)=round(valarr(v));

if arrend(v,1)>T
    ta=arrend(v,1)-T;
else
    ta=arrend(v,1);
end
end
if ta<td
    temp=ta;
    ta=td;
    td=temp;
end
rtd=0;
lefttd=TD(v);
% Assign all Road data for departure
while lefttd>0
    lastd=rtd;
    rtd=rtd+valspeed(td)*24/T;
    lefttd=TD(v)-rtd;
    X(td,v)=1;
    if lefttd>0
        R(td,v)=valspeed(td)*24/T*CE(v)/ndsg/1000;
    else
        R(td,v)= (TD(v)-lastd)*CE(v)/ndsg/1000;
        rdepend=R(td,v);
    end
    depend(v,1)=td;
    td=td+1;
end


% ta=arrend(v,1);
rtd=0;
lefttd=TD(v);
while lefttd>0
    lastd=rtd;
    rtd=rtd+valspeed(ta)*24/T;
    lefttd=TD(v)-rtd;
    X(ta,v)=1;
    if lefttd>0
        R(ta,v)=valspeed(ta)*24/T*CE(v)/ndsg/1000;
    else
        R(ta,v)= (TD(v)-lastd)*CE(v)/ndsg/1000;
    end
    arrini(v,1)=ta;
    if ta==1
    ta=T;
    else
        ta=ta-1;
    end
end

% Assign uncontrolled charge for arriving home travel.
if arrend(v,1)>T    
ta=arrend(v,1)-T;
else
    ta=arrend(v,1);
end
    leftuch=TD(v)/ndsg*CE(v)/nchg;
    uch=0;
    while leftuch>0
        if arrend(v,1)<depini(v,1)&&ta>depini(v,1)
            extrauch=leftuch;
            break
        else
        lastuch=uch;
        uch=uch+Pvmax*24/T*nchg/1000;
        leftuch=TD(v)*CE(v)/ndsg/1000-uch;
        if leftuch>0
            UC(ta,v,FR(v))=Pvmax*24/T/1000;
        else
            UC(ta,v,FR(v))=TD(v)*CE(v)/ndsg/1000-lastuch;
        end
        ta=ta+1;
        end
    end

if depend(v,1)>arrini(v,1)
    if depend(v,1)>arrend(v,1)
        if arrend(v,1)<depini(v,1)
        else
        for tc=arrend(v,1)+1:depend(v,1)
                R(tc,v)=0;
                X(tc,v)=0;
        end
        end
    else
       for tc=depini(v,1):arrini(v,1)-1
           R(tc,v)=0;
           X(tc,v)=0;
       end
    end
else
    % Assign uncotroled charge for departure
leftuch=TD(v)/ndsg*CE(v)/nchg;
if arrend(v,1)<depini(v,1)
    leftuch=leftuch+extrauch;
end
uch=0;
while leftuch>0
    lastuch=uch;
    uch=uch+Pvmax*24/T*nchg/1000;
    leftuch=TD(v)*CE(v)/ndsg/1000-uch;
    if leftuch>0
        UC(td,v,TO(v))=Pvmax*24/T/1000;
    else
        UC(td,v,TO(v))=TD(v)*CE(v)/ndsg/1000-lastuch;
    end
    td=td+1;
end
end
end


end