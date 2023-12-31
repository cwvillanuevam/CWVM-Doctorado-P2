inttext=strcat(savefilename,'Loadsummary.txt');
fint=fopen(inttext,'w');
fprintf(fint,'Name of scenary: %s',SCdir);
fprintf(fint,'\n\t\t\tPS only load:\t\tMin MCS\t\tMax MCS');
EnLoadOL=sum(Loadol)*24/T;
MaxLoadOL=max(Loadol);
LoadFacOL=EnLoadOL/24/MaxLoadOL;
EnLoadmin=sum(Loadmin)*24/T;
MaxLoadmin=max(Loadmin);
LoadFacmin=EnLoadOL/24/MaxLoadmin;
EnLoadmax=sum(Loadmax)*24/T;
MaxLoadmax=max(Loadmax);
LoadFacmax=EnLoadOL/24/MaxLoadmax;
fprintf(fint,'\nEnergy Load:\t %7.2f\t\t%7.2f\t\t%7.2f',EnLoadOL,EnLoadmin,EnLoadmax);
fprintf(fint,'\nPeak Load:  \t %7.2f\t\t%7.2f\t\t%7.2f',MaxLoadOL,MaxLoadmin,MaxLoadmax);
fprintf(fint,'\nLoad factor:\t %7.2f\t\t%7.2f\t\t%7.2f',LoadFacOL,LoadFacmin,LoadFacmax);
fclose all;