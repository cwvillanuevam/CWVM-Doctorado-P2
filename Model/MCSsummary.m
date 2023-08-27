MCStext=strcat(savefilename,'MCSSummary',SCdir,'.txt');
fMCS=fopen(MCStext,'w');
fprintf(fMCS,'Minimum charge required by PS: %4f4 \t corresponding to sample %d',MCSmin,lmin);
fprintf(fMCS,'\nMaximum charge required by PS: %4f8 \t corresponding to sample %d',MCSmax,lmax);
nbus=length(BUS.NumBus(:,1));
fprintf(fMCS,'\nbus \t EVs from in min: \t EVs to in min: \t EVs from in max: \tEVs to in max: \t');
for b=1:nbus
    fprintf(fMCS,'\n %3d \t \t \t %3d \t \t \t %3d \t \t \t \t %3d \t \t \t \t %3d',b,GVDfm(b),GVDtm(b),GVDfM(b),GVDtM(b));
end
fclose all;