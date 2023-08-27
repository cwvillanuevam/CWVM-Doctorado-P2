%% stocdataAUDIQUATTRO.m

%% Stocastic data
% trip time description: normal distribution tt=[mu,sigma;];
%ttdata=[.5,.5;.5,.75;.5,1;.5,1.5;.75,.75;1,.5;1,.75;1,1;1.5,.5;1.5,1];
% ttdata=[.5,.75;.75,.75;];

%% Travel distance correction factor
tdf=[1,0.125];

% spped description: normal distribution seedp=[mu,sigma;] [Km/h];
speeddata=[50,20;35,15;20,10];
%high traffic speed,, medium traffic speed,low traffic speed
charactts=[30,2;34,3;44,2;53,3;55,2;65,3;81,2;84,1];
%format: Time (1/4 H), ChTS: (1:lts,2:mts,3:hts)
% prob de shortage description: normal distribution pis=[0,sigma;];
pisdata=[10;9;8;7;6;5;4;3;2;1];
%% Battery data:
% Battery cost: normal distribution between CES=[Cmin;Cmax]
CESlim=[100;140];   
% Battery cost: normal distribution CES=[Cmu;Csigma]
CESpd=[120;10];
% Battery degradation: linear between mES=[mmin;mmax]
mESlim=[0.0006;0.0017];
% Battery capacity: [KWh]
BCES=82;
%State o charge: [SoCmin,SoCmax]
SoCmin=0.15*BCES;
SoCmax=0.95*BCES;
%% Charging data
% Maximum Charging Power [KW]
Pvmax=125;
% charging & discharging efficiency
nchg=0.9;
ndsg=0.9;
%% Riding data
% specific consumption [kWh/km]
CEmin=0.181;
CEmax=0.181; 




