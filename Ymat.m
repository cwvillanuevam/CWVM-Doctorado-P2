function [Ymatriz]=Ymat(type)
    [Title,Bus,Branch]=readcdf2(type);
    i=sqrt(-1);j=sqrt(-1);
    nk=Branch.NumIniRam;
    nl=Branch.NumFinRam;
    L=length(nk(:,1));
    r=Branch.Rram;
    x=Branch.Xram;
    b=j*Branch.BChargRam/2;
    bshb=i*Bus.BShuntBus;
    a=Branch.TapNomRam;
    z=r+i*x;
    y=ones(L,1)./z;
    nbus=length(Bus.NumBus(:,1));
    Y=zeros(nbus,nbus);
    Ydiag=zeros(nbus,1);
    Ykm=zeros(L,1);
    %Ym=zeros(nbus,nbus);
    %t=zeros(nbus,nbus);
    for l=1:L
        if a(l,1)<=0 % lines a (tap number)
            a(l,1)=1; % correct value
        end
        Ykm(l,1)=Ykm(l,1)-y(l,1)/a(l,1);
        Y(nk(l,1),nl(l,1))=Y(nk(l,1),nl(l,1))-y(l,1)/a(l,1);
        Y(nl(l,1),nk(l,1))=Y(nk(l,1),nl(l,1));
    end
for  k=1:nbus
     for l=1:L
         if nk(l,1)==k
             Ydiag(k,1)=Ydiag(k,1)+y(l,1)/(a(l,1)^2)+b(l,1);
         Y(k,k) = Y(k,k)+y(l,1)/(a(l,1)^2) + b(l,1);
         elseif nl(l,1)==k
             Ydiag(k,1)=Ydiag(k,1)+y(l,1)+b(l,1);
         Y(k,k) = Y(k,k)+y(l,1) +b(l,1);
         end
     end
     Ydiag(k,1)=Ydiag(k,1)+bshb(k,1);
     Y(k,k)=Y(k,k)+bshb(k,1);
end
Ymatriz.Y_Gdiag=real(Ydiag);
Ymatriz.Y_Bdiag=imag(Ydiag);
Ymatriz.Y_Gkm=real(Ykm);
Ymatriz.Y_Bkm=imag(Ykm);
Ymatriz.YG=real(Y);
Ymatriz.YB=imag(Y);
Ymatriz.Ym=abs(Y);
Ymatriz.Yt=angle(Y);
end