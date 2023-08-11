function [TD,FR,TO,TS]=traveldistancecharact(BUS,BRANCH,tdf,pop)
[L,LM,lmin,E]=BusDistance(BUS,BRANCH);
nbus=length(BUS.NumBus(:,1));
pdtdf=makedist('normal','mu',tdf(1),'sigma',tdf(2));
pdn01=makedist('normal','mu',0.5,'sigma',0.25);
tdfval=pruebav11(pdtdf,-0.25,0.25,pop);
ntdval=pruebav11(pdn01,0,1,pop);
TD=zeros(pop,1);
rng shuffle
for ev=1:pop
    frbus=randi(nbus);
    tobus=randi(nbus);
    while BUS.PCarBus(frbus)==0
    frbus=randi(nbus);
    end
    while BUS.PCarBus(tobus)==0 || L(frbus,tobus)==0
    tobus=randi(nbus);
    end
    if frbus==4
        while tobus==9
            tobus=randi(nbus);
        end
    elseif frbus==5
        while tobus==6
            tobus=randi(nbus);
        end
    end
    if E(frbus,tobus)==1
        TD(ev,1)=L(frbus,tobus)*tdfval(ev);
    else
        TD(ev,1)=(lmin(frbus,tobus)+ntdval(ev)*(LM(frbus,tobus)-lmin(frbus,tobus)))*tdfval(ev);
    end
    FR(ev)=frbus;
    TO(ev)=tobus;
    TS(ev,1)=frbus;
    TS(ev,2)=tobus;
end
end