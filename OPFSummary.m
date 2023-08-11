opftext=strcat(savefilename,'OPFSummary.txt');
fopf=fopen(opftext,'w');
fprintf(fopf,'Name of scenary: %s',SCdir);
fprintf(fopf,'\n\t\t\t\t\tPS only load:\t\tMin MCS\t\tMax MCS');

EnSupOL=sum(Genol)*24/T;
NSEOL=sum(ENSol)*24/T;
EnLoadOL=sum(Loadol)*24/T;
EnLostOL=EnSupOL-EnLoadOL;
maxNSPOL=max(ENSol);

EnSupmin=sum(Genmin)*24/T;
NSEmin=sum(ENSmin)*24/T;
EnLoadmin=sum(Loadmin)*24/T;
EnLostmin=EnSupmin-EnLoadmin;
maxNSPmin=max(ENSmin);

EnSupmax=sum(Genmax)*24/T;
NSEmax=sum(ENSmax)*24/T;
EnLoadmax=sum(Loadmax)*24/T;
EnLostmax=EnSupmax-EnLoadmax;
maxNSPmax=max(ENSmax);

fprintf(fopf,'\nEnergy Supplied:    \t%7.2f\t%7.2f\t%7.2f',EnSupOL,EnSupmin,EnSupmax);
fprintf(fopf,'\nEnergy Lost:        \t%7.2f\t%7.2f\t%7.2f',EnLostOL,EnLostmin,EnLostmax);
fprintf(fopf,'\nNot-Served Energy:  \t%7.2f\t%7.2f\t%7.2f',NSEOL,NSEmin,NSEmax);
fprintf(fopf,'\nMaximum NSP:        \t%7.2f\t%7.2f\t%7.2f',maxNSPOL,maxNSPmin,maxNSPmax);
fclose all;
