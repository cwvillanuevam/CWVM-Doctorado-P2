opfNtext=strcat(savefilename,'OPFNPSSummary.txt');
fopfNPS=fopen(opfNtext,'w');
fprintf(fopfNPS,'Name of scenary: %s',SCdir);
fprintf(fopfNPS,'\n\t\t\t\t\tPS only load:\t\tMin MCS\t\tMax MCS');

EnSupNOL=sum(GenNol)*24/T;
NSENOL=sum(ENSNol)*24/T;
EnLoadNOL=sum(LoadNol)*24/T;
EnLostNOL=EnSupNOL-EnLoadNOL;
maxSupNOL=max(GenNol);

EnSupNmin=sum(GenNmin)*24/T;
NSENmin=sum(ENSNmin)*24/T;
EnLoadNmin=sum(LoadNmin)*24/T;
EnLostNmin=EnSupNmin-EnLoadNmin;
maxSupNmin=max(GenNmin);

EnSupNmax=sum(GenNmax)*24/T;
NSENmax=sum(ENSNmax)*24/T;
EnLoadNmax=sum(LoadNmax)*24/T;
EnLostNmax=EnSupNmax-EnLoadNmax;
maxSupNmax=max(GenNmax);

fprintf(fopfNPS,'\nEnergy_Supplied:   \t%7.2f\t%7.2f\t%7.2f',EnSupNOL,EnSupNmin,EnSupNmax);
fprintf(fopfNPS,'\nEnergy_Lost:       \t%7.2f\t%7.2f\t%7.2f',EnLostNOL,EnLostNmin,EnLostNmax);
fprintf(fopfNPS,'\nNot_Served_Energy: \t%7.2f\t%7.2f\t%7.2f',NSENOL,NSENmin,NSENmax);
fprintf(fopfNPS,'\nPeak_Supply_Power: \t%7.2f\t%7.2f\t%7.2f',maxSupNOL,maxSupNmin,maxSupNmax);
fclose all;
