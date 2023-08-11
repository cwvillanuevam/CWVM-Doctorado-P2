function [V,theta]=FlatStart(Bus)
%% FLAT START for iteration number 1
    Type=Bus.TipoBus; % Set bus type
    nbus=length(Type(:,1)); 
    for k=1:nbus
        if Type(k,1)==3 % Slack bus constraint
            V(k,1)=Bus.VFinBus(k,1);
            theta(k,1)=pi/180*Bus.ThFinBus(k,1);
        elseif Type(k,1)==2 %PV bus constraint
            V(k,1)=Bus.VFinBus(k,1);
            theta(k,1)=0;
        else %PQ bus constraint
            V(k,1)=1;
            theta(k,1)=0;
        end
    end
end