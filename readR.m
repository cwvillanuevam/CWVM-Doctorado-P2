function [R,]=readR(PStype,cdfile) %[Title,Buses,Lines]
fID=fopen(PStype); %First open file
C=textscan(fID,'%s','delimiter','\n'); %Reading all lines in a a cell called C
E=length(C{1}); %Determining E: the value of total reading lines in type file
[date,base,year,txt]=textread(PStype,'%s %*s %*s %f %f %*s %7c',1);%Read Elements in Title
%% Set Title Data to output
Title.date=date;
Title.baseMVA=base;
Title.year=year;
Title.case=txt;
%% Continue proccesing information
frewind(fID); %Refresh file to start again in first row
%Predefine indexes and temporary variables
line=0;buscategory=0;linecategory=0; 
linestopbus=E+1;
busindex=1;
lineindex=1;
%% Start Loop to read line by line the cdf file
while ~feof(fID) %Reaching end stop criteria
    temp=fgets(fID); %read each line and set it in temp string
    line=line+1;% Criteria to index this line
    if length(temp)>=4
    temp2=temp(1:4);%Set temp2 string used to stop bus or line criteria
    end
    if line==3 %Start Bus criteria condition
buscategory=1; %Bus criteria started
    end
    if str2num(temp2)==-999; %Ending criteria
        if buscategory==1 
            buscategory=0;%Ending Bus criteria 
            linestopbus=line; %Predefine Line where bus was stopped
        elseif linecategory==1
            linecategory=0;%Ending Branch Criteria
        end
    end
    if linestopbus+2==line
        linecategory=1; %Start Branch Criteria
    end
    %% Reading and setting all information in bus criteria to the BUS output object
    if buscategory==1
    [nbus,name,area,losszone,btype,v,delta,PL,QL,PG,QG,vbase,vdes,Qmax,Qmin,Sg,Sb,bcontrol]=strread(temp,'%4d %12c %2d %3d %2d %6f %7f %9f %10f %8f %8f %7f %6f%8f%8f%8f%8f %4f',1);
    BUS.NumBus(busindex,1)=nbus;
    BUS.NombreBus{busindex,1}=name;
    BUS.AreaFCBus(busindex,1)=area;
    BUS.ZonaPerBus(busindex,1)=losszone;
    BUS.TipoBus(busindex,1)=btype;
    BUS.VFinBus(busindex,1)=v;
    BUS.ThFinBus(busindex,1)=delta;
    BUS.PCarBus(busindex,1)=PL;
    BUS.QCarBus(busindex,1)=QL;
    BUS.PGenBus(busindex,1)=PG;
    BUS.QGenBus(busindex,1)=QG;
    BUS.VBaseBus(busindex,1)=vbase;
    BUS.VEspBus(busindex,1)=vdes;
    BUS.QGenMaxBus(busindex,1)=Qmax;
    BUS.QGenMinBus(busindex,1)=Qmin;
    BUS.GShuntBus(busindex,1)=Sg;
    BUS.BShuntBus(busindex,1)=Sb;
    BUS.ConRemBus(busindex,1)=bcontrol;
    busindex=busindex+1;
    end
    %% Reading and setting all information in line criteria to the BRANCH output object
    if linecategory==1
    [tapn,Zn,area,losszone,circuit,ltype,R,X,B,MVA1,MVA2,MVA3,bcontrol,side,a,psdelta,tapmin,tapmax,tapstepsize,Vminram,Vmaxram,LineLength]=strread(temp,'%4d %4d %2d%2d %1d %1d%10f%11f%10f%5f %5f %5f %4d %1d  %6f %7f%7f%7f %6f %6f %7f %7f',1);
    BRANCH.NumIniRam(lineindex,1)=tapn;
    BRANCH.NumFinRam(lineindex,1)=Zn;
    BRANCH.AreaFcRam(lineindex,1)=area;
    BRANCH.ZonPerRam(lineindex,1)=losszone;
    BRANCH.NumCircRam(lineindex,1)=circuit;
    BRANCH.TipoRam(lineindex,1)=ltype;
    BRANCH.Rram(lineindex,1)=R;
    BRANCH.Xram(lineindex,1)=X;
    BRANCH.BChargRam(lineindex,1)=B;
    BRANCH.MVANormNorRam(lineindex,1)=MVA1;
    BRANCH.MVANormEmeRam(lineindex,1)=MVA2;
    BRANCH.MVANormExtRam(lineindex,1)=MVA3;
    BRANCH.ConResBusRam(lineindex,1)=bcontrol;
    BRANCH.LadoContRam(lineindex,1)=side;
    BRANCH.TapNomRam(lineindex,1)=a;
    BRANCH.TapAngRam(lineindex,1)=psdelta;
    BRANCH.TapMinRam(lineindex,1)=tapmin;
    BRANCH.TapMaxRam(lineindex,1)=tapmax;
    BRANCH.TapPasRam(lineindex,1)=tapstepsize;
    BRANCH.VMinRam(lineindex,1)=Vminram;
    BRANCH.VMaxRam(lineindex,1)=Vmaxram;
    BRANCH.Length(lineindex,1)=LineLength;
    lineindex=lineindex+1;
    end
end %Closing the reading loop

fclose(fID); %Close the file
end %Ending our reading function