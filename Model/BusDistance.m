function [L,LM,lmin,E]=BusDistance(BUS,BRANCH)
nbr=length(BRANCH.NumIniRam());
nbus=length(BUS.NumBus());
L=zeros(nbus,nbus);
LM=zeros(nbus,nbus);
lmin=zeros(nbus,nbus);
E=zeros(nbus,nbus);
for l=1:nbr
    L(BRANCH.NumIniRam(l),BRANCH.NumFinRam(l))=BRANCH.Length(l);
    L(BRANCH.NumFinRam(l),BRANCH.NumIniRam(l))=BRANCH.Length(l);
    LM(BRANCH.NumIniRam(l),BRANCH.NumFinRam(l))=BRANCH.Length(l);
    LM(BRANCH.NumFinRam(l),BRANCH.NumIniRam(l))=BRANCH.Length(l);
    lmin(BRANCH.NumIniRam(l),BRANCH.NumFinRam(l))=BRANCH.Length(l);
    lmin(BRANCH.NumFinRam(l),BRANCH.NumIniRam(l))=BRANCH.Length(l);
    E(BRANCH.NumIniRam(l),BRANCH.NumFinRam(l))=1;
    E(BRANCH.NumFinRam(l),BRANCH.NumIniRam(l))=1;
end
for k=1:nbus
    for m=1:nbus
        if  E(k,m)==1 || E(m,k)==1
        elseif k==m
            E(k,m)=1;
            E(m,k)=1;
        else
            
            for n=1:nbus
                if n==k || n==m
                else
                    if E(k,n)==1 && E(n,m)==1
                    if E(k,m)==0
                        LM(k,m)=L(k,n)+L(n,m);
                        LM(m,k)=L(k,n)+L(n,m);
                        E(k,m)=2;
                        E(m,k)=2;
                    elseif LM(k,m)>L(k,n)+L(k,m)
                        LM(k,m)=L(k,n)+L(n,m);
                        LM(m,k)=L(k,n)+L(n,m);
                        E(k,m)=2;
                        E(m,k)=2;
                    end
                    end
                    if E(k,n)==1 && E(m,n)==1
                        if E(k,m)==0
                            lmin(k,m)=L(k,n)-L(m,n);
                            lmin(m,k)=L(k,n)-L(m,n);
                            E(k,m)=2;
                            E(m,k)=2;
                        elseif lmin(k,m)<L(k,n)-L(m,n)
                            lmin(k,m)=L(k,n)-L(m,n);
                            lmin(m,k)=L(k,n)-L(m,n);
                            E(k,m)=2;
                            E(m,k)=2;
                        end
                    end
                    if E(n,m)==1 && E(n,k)==1
                        if E(k,m)==0
                            lmin(k,m)=L(n,m)-L(n,k);
                            lmin(m,k)=L(n,m)-L(n,k);
                            E(k,m)=2;
                            E(m,k)=2;
                        elseif lmin(k,m)<L(n,m)-L(n,k)
                            lmin(k,m)=L(n,m)-L(n,k);
                            lmin(m,k)=L(n,m)-L(n,k);
                            E(k,m)=2;
                            E(m,k)=2;
                        end
                    end
                end
            end
        end
    end
end
exi=0;
ite=2;
while exi<1 && ite<10
    ite=ite+1;
        exi=1;
for k=1:nbus
    for m=1:nbus
        if k==m || E(k,m)>0 || E(m,k)>0
        else
            for n=1:nbus
                if n==k || n==m
                else
                    if E(k,n)>0 && E(n,m)>0 && E(k,n)<ite && E(n,m)<ite
                    if E(k,m)==0
                        LM(k,m)=LM(k,n)+LM(n,m);
                        LM(m,k)=LM(k,n)+LM(n,m);
                        E(k,m)=ite;
                        E(m,k)=ite;
                    elseif LM(k,m)>LM(k,n)+LM(n,m)
                        LM(k,m)=LM(k,n)+LM(n,m);
                        LM(m,k)=LM(k,n)+LM(n,m);
                        E(k,m)=ite;
                        E(m,k)=ite;
                    end
                    end
                    if E(k,n)>0 && E(m,n)>0 && E(k,n)<ite && E(m,n)<ite
                        if E(k,m)==0
                            lmin(k,m)=lmin(k,n)-LM(m,n);
                            lmin(m,k)=lmin(k,n)-LM(m,n);
                            E(k,m)=ite;
                            E(m,k)=ite;
                        elseif lmin(k,m)<lmin(k,n)-LM(m,n)
                            lmin(k,m)=lmin(k,n)-LM(m,n);
                            lmin(m,k)=lmin(k,n)-LM(m,n);
                            E(k,m)=ite;
                            E(m,k)=ite;
                        end
                    end
                    if E(n,m)>0 && E(n,k)>0 && E(n,m)<ite && E(n,k)<ite 
                        if E(k,m)==0
                            lmin(k,m)=lmin(n,m)-LM(n,k);
                            lmin(m,k)=lmin(n,m)-LM(n,k);
                            E(k,m)=ite;
                            E(m,k)=ite;
                        elseif lmin(k,m)<lmin(n,m)-LM(n,k)
                            lmin(k,m)=lmin(n,m)-LM(n,k);
                            lmin(m,k)=lmin(n,m)-LM(n,k);
                            E(k,m)=ite;
                            E(m,k)=ite;
                        end
                    end
                end
            end
        end
        exi=exi*E(k,m);
    end
end
    
end
end