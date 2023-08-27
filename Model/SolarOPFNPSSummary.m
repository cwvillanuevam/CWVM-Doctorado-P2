SopfNtext=strcat(savefilename,'SolarStorageSummary.txt');
fsopfNPS=fopen(SopfNtext,'w');
fprintf(fsopfNPS,'Name of scenary: %s\nbus:\tSolar Power Capacity:',SCdir);
fprintf(fsopfNPS,'\nBatery Storage System Energy Capacity:\t');
for n=1:nbus
    fprintf(fsopfNPS,'\n%2d\t\t%4.6f\t\t%4.6f',n,NSPcap(n),BSScap(n));
end
fprintf(fsopfNPS,'\nPhoto Voltaic - Storage System cost: %f',PVSScost);
fprintf(fsopfNPS,'\n\t\t\t\t\tPS only load:\t\tMin MCS\t\tMax MCS');

SEnSupNOL=sum(SGenNol)*24/T;
SNSENOL=sum(SENSNol)*24/T;
SEnLoadNOL=sum(SLoadNol)*24/T;
SEnLostNOL=SEnSupNOL-SEnLoadNOL;
SmaxSupNOL=max(SGenNol);

SEnSupNmin=sum(SGenNmin)*24/T;
SNSENmin=sum(SENSNmin)*24/T;
SEnLoadNmin=sum(SLoadNmin)*24/T;
SEnLostNmin=SEnSupNmin-SEnLoadNmin;
SmaxSupNmin=max(SGenNmin);

SEnSupNmax=sum(SGenNmax)*24/T;
SNSENmax=sum(SENSNmax)*24/T;
SEnLoadNmax=sum(SLoadNmax)*24/T;
SEnLostNmax=SEnSupNmax-SEnLoadNmax;
SmaxSupNmax=max(SGenNmax);

fprintf(fsopfNPS,'\nEnergy_Supplied:   \t%7.2f\t%7.2f\t%7.2f',SEnSupNOL,SEnSupNmin,SEnSupNmax);
fprintf(fsopfNPS,'\nEnergy_Lost:       \t%7.2f\t%7.2f\t%7.2f',SEnLostNOL,SEnLostNmin,SEnLostNmax);
fprintf(fsopfNPS,'\nNot_Served_Energy: \t%7.2f\t%7.2f\t%7.2f',SNSENOL,SNSENmin,SNSENmax);
fprintf(fsopfNPS,'\nPeak_Supply_Power: \t%7.2f\t%7.2f\t%7.2f',SmaxSupNOL,SmaxSupNmin,SmaxSupNmax);
fclose all;
