function [cv,savingdir]=opfejecutablewol(Type)
eval(Type);
tempDB=DB;
opfdatawolNLP;
% system 'gams opf lo=3'; %ejecutamos el programa en gams opf.gms

fprintf('run opf and set out.gdx in path');
pause();
%leemos los resultados
r1s.name='F';
r1s.form='full';
r1=rgdx('out.gdx',r1s);
cv=r1.val

r2s.name='Vm';
r2s.form='sparse';
r2=rgdx('out.gdx',r2s);
Vm=r2.val

r3s.name='delta';
r3s.form='sparse';
r3=rgdx('out.gdx',r3s);
delta=r3.val

r4s.name='Pg';
r4s.form='sparse';
r4=rgdx('out.gdx',r4s);
Pg=r4.val

r5s.name='Qg';
r5s.form='sparse';
r5=rgdx('out.gdx',r5s);
Qg=r5.val

r6s.name='Sfrom';
r6s.form='sparse';
r6=rgdx('out.gdx',r6s);
Sfrom=r6.val

r7s.name='Sto';
r7s.form='sparse';
r7=rgdx('out.gdx',r7s);
Sto=r7.val

r8s.name='PENS';
r8s.form='sparse';
r8=rgdx('out.gdx',r8s);
PENS=r8.val

r9s.name='Pd';
r9s.form='sparse';
r9=rgdx('out.gdx',r9s);
Pd=r9.val

r10s.name='Qd';
r10s.form='sparse';
r10=rgdx('out.gdx',r10s);
Qd=r10.val



 %% Seteamos el nombre del archivo txt de resultados
savingtxt=strcat(Type,'validacion.txt');
savingdir=strcat(Type,'validacion');
version=1;
while exist(savingtxt,'file')==2
    savingtxt=strcat(Type,'validacion','v',num2str(version),'.txt');
    savingdir=strcat(Type,'validacion','v',num2str(version));
    version=version+1;
end
cd(pwd);
fres=fopen(savingtxt,'w');
    fprintf(fres,'Resultados de la optimizacion \n');
    fprintf(fres,'Función objetivo: \t %8f4 \n',cv);
for ii=1:nbr
    fprintf(fres,'Numero total de lineas del tipo \t %d \t que van de \t %d \t a \t %d \t: \t %d \t \n',ii,nl(ii),nr(ii),ntl(ii));
    fprintf(fres,'Costo de invercion relativo a este tipo de lineas: \t %8f4 \n',tempDB.reinforces(ii,4)*(ntl(ii)-tempDB.reinforces(ii,2)));
end
mkdir(savingdir)
 for le=1:nole
         letxt=strcat('le',num2str(le));
    mkdir (letxt);
    fprintf(fres,'\n Escenario de Carga: \t %d \n',le);
      %% Definimos cvgen, cens, bus and charges
 for op=1:ncont+1
 fv=0;
 CvG=0;
 Cens=0;
 bus=zeros(nbus,10);
 charges=zeros(nbus,7);
 generation=zeros(ngenval,5);
 PENStemp=zeros(nbus,1);

 %% Seteamos los valores de operación normal
 fprintf(fres,'Condiciones de operación: \t %d \n',op);
 for n=1:nbus
     bus(n,1)=n;
     Vmi=length(Vm(:,1));
     for i=1:Vmi
         if Vm(i,1)==n && Vm(i,2)==op && Vm(i,3)==le
     bus(n,2)=Vm(i,4);
         end
     end
     deltai=length(delta(:,1));
     for i=1:deltai
         if delta(i,1)==n && delta(i,2)==op && delta(i,3)==le
     bus(n,3)=delta(i,4);
         end
     end
     Pdi=length(Pd(:,1));
     for i=1:Pdi
         if Pd(i,1)==n && Pd(i,2)==le
     bus(n,4)=Pd(i,3);
         end
     end
     Qdi=size(Qd,1);
     if Qdi==0
     else
     for i=1:Qdi
         if Qd(i,1)==n && Qd(i,2)==le     
     bus(n,5)=Qd(i,3);
         end
     end
     end
     Pgi=length(Pg(:,1));
     for i=1:Pgi
         if tempDB.gencost(Pg(i,1),1)==n && Pg(i,2)==op && Pg(i,3)==le
             CvG=CvG+(ag(Pg(i,1))*Pg(i,4)^2+bg(Pg(i,1))*Pg(i,4)+cg(Pg(i,1)));
     bus(n,6)=Pg(i,4)+bus(n,6);
         end
     end
     Qgi=length(Qg(:,1));
     for i=1:Qgi
         if Qg(i,1)==n && Qg(i,2)==op && Qg(i,3)==le
     bus(n,7)=Qg(i,4);
         end
     end     
     bus(n,8)=Qsh(n);
     
     bus(n,9)=(ag(n)*bus(n,6)^2+bg(n)*bus(n,6)+cg(n));
     PENSi=length(PENS(:,1));
     for i=1:PENSi
         if PENS(i,1)==n && PENS(i,2)==op && PENS(i,3)==le
     PENStemp(n,1)=PENS(i,4);
         end
     end       
     Cens=Cens+6*PENStemp(n,1);
     bus(n,10)=PENStemp(n,1);
     bus(n,11)=6*PENStemp(n,1);
 end
 foundfrom=zeros(nbr,1);
 foundto=zeros(nbr,1);
 for l=1:nbr
 charges(l,1)=nl(l);
 charges(l,2)=nr(l);
 Sfromi=length(Sfrom(:,1));
 for i=1:Sfromi
     if Sfrom(i,1)==l && Sfrom(i,4)==op && Sfrom(i,5)==le
         charges(l,3)=(Sfrom(i,6))*basemva;
     end
 end
 Stoi=length(Sto(:,1));
 for i=1:Stoi
     if Sto(i,1)==l && Sto(i,4)==op && Sto(i,5)==le
 charges(l,4)=(Sto(i,6))*basemva;
     end
 end
 charges(l,5)=max(charges(l,3),charges(l,4));
 charges(l,6)=Smax(l)*ntl(l);
 charges(l,7)=charges(l,5)/charges(l,6);
 if charges(l,7)>1
     fprintf(fres,'Sobrecarga en línea: \t %d \t condicion de operacion: \t %d \t escenario: \t %d \t Indice de carga: \t %8.4f \t \n',l,op,le,charges(l,7));
 end
 end
 fv=CvG+Cens;
 
 for g=1:ngenval
     generation(g,1)=g;
     generation(g,2)=tempDB.gencost(g,1);
     generation(g,3)=tempDB.gendata(g,2*le);
     Pgi=length(Pg(:,1));
     for i=1:Pgi
         if Pg(i,1)==g && Pg(i,2)==op && Pg(i,3)==le
     generation(g,4)=Pg(i,4);
         end
     end
     generation(g,5)=tempDB.gendata(g,2*le+1);
 end
 
fprintf(fres,'fv:\t %8f4 \t CvG:\t %8f4 \t Cens:\t %8f4 \t',fv,CvG,Cens);
txtbus=[{'n'},{'Vm'},{'delta'},{'Pd'},{'Qd'},{'Pg'},{'Qg'},{'Qsh'},{'CvG'},{'Pens'},{'Cens'}];
txtcharges=[{'nfrom'},{'nto'},{'Sfrom'},{'Sto'},{'Smax'},{'Slimite'}];
txtgeneration=[{'ngen'},{'nbus'},{'Pgmin'},{'Pg'},{'Pgmax'}];
    xlswrite(strcat(Type,'V',num2str(version),'op',num2str(op),'.xlsx'),txtbus,'buses','A1');
    xlswrite(strcat(Type,'V',num2str(version),'op',num2str(op),'.xlsx'),txtcharges,'cargas','A1');
    xlswrite(strcat(Type,'V',num2str(version),'op',num2str(op),'.xlsx'),txtgeneration,'generacion','A1');       
    xlswrite(strcat(Type,'V',num2str(version),'op',num2str(op),'.xlsx'),bus,'buses','A2');
    xlswrite(strcat(Type,'V',num2str(version),'op',num2str(op),'.xlsx'),charges,'cargas','A2');
    xlswrite(strcat(Type,'V',num2str(version),'op',num2str(op),'.xlsx'),generation,'generacion','A2');
    fprintf(fres,'Save in %s;',strcat(Type,'V',num2str(version),'op',num2str(op),'.xlsx'));
fprintf(fres,'\n');
movefile(strcat(Type,'V',num2str(version),'op',num2str(op),'.xlsx'),letxt);
 end
 movefile(letxt,savingdir)
 end
 fclose(fres);
end