function [GVDf,GVDt]=Geo_Veh_Dist(TScf,nbus,V,s)
GVDf=zeros(nbus,1);
GVDt=zeros(nbus,1);
for v=1:V
for b=1:nbus
    if TScf(s,v,1)==b
        GVDf(b,1)=GVDf(b,1)+1;
    end
    if TScf(s,v,2)==b
        GVDt(b,1)=GVDt(b,1)+1;
    end
end
end
end