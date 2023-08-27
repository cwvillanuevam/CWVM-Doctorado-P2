function [G1SD,G2SD,G3SD,G4SD]=mkPSgraph(xb,yb,BUS,BRANCH,Title,GVDfM,GVDtM,GVDfm,GVDtm,GrafDir)
nbus=length(BUS.NumBus(:,1));
x=imread(GrafDir);
% figure; imshow(x);
% [xb,yb]=ginput(nbus+1)
%% Fig 1
F1=figure;
print('djpg','-r500')
xF1=x;
% xF1(:,:,3)=1;
[F1max,F1pos]=max(GVDfM(:,1));
F1M=ceil(F1max/100)*100;
for b=1:nbus
    if BUS.PCarBus(b)==0
    else
    for xax=round(xb(b)):1:round(xb(b))+10
        for yax=round(yb(b)):1:round(yb(b))+10
            xF1(yax,xax,1)=255;
            xF1(yax,xax,2)=(1-GVDfM(b,1)/F1M)*255;
            xF1(yax,xax,3)=0;
        end
    end
    end
end

 for xax=round(xb(nbus+1)):1:round(xb(nbus+1))+100
     for yax=round(yb(nbus+1))-5:1:round(yb(nbus+1))+5
         xF1(yax,xax,1)=255;
         xF1(yax,xax,2)=(1-(xax-round(xb(nbus+1)))/100)*255;
         xF1(yax,xax,3)=0;
     end
 end
 
 pos1=[xb(nbus+1)-15,yb(nbus+1)-15;xb(nbus+1)+100,yb(nbus+1)-15;xb(nbus+1)-2,yb(nbus+1)-35];
 txt1=cell(3,1);
% pos2=[xb(nbus+1)+805,yb(nbus+1)];
txt1{1}=[num2str(0,'%d')];
txt1{2}=[num2str(F1M,'%d'),'EVs'];
txt1{3}=['Legend ',':'];
RGB1=insertText(xF1,pos1,txt1,'FontSize',15,'BoxColor',{'white','white','white'},'TextColor','black');
% RGB2=insertText(xF1,pos2,txt2,'FontSize',10,'TextColor','red');
 

%  F1=imshow(xF1);
 imshow(RGB1);
%  imshow(RGB2);
 title('Electric Vehicles per bus, Departure in Maximum MCS output');
 G1SD=strcat(Title.case,'F1FrMax.jpg');
 saveas(F1,G1SD);
%  exportgraphics(F1,G1SD,'Resolution',600); R2020a only
 %% F2
 xF2=x;
F2=figure;
print('djpg','-r500');
% xF2(:,:,3)=1;
[F2max,F2pos]=max(GVDtM(:,1));
F2M=ceil(F2max/100)*100;
for b=1:nbus
    if BUS.PCarBus(b)==0
    else
    for xax=round(xb(b)):1:round(xb(b))+10
        for yax=round(yb(b)):1:round(yb(b))+10
            xF2(yax,xax,1)=255;
            xF2(yax,xax,2)=(1-GVDtM(b,1)/F2M)*255;
            xF2(yax,xax,3)=0;
        end
    end
    end
end

 for xax=round(xb(nbus+1)):1:round(xb(nbus+1))+100
     for yax=round(yb(nbus+1))-5:1:round(yb(nbus+1))+5
         xF2(yax,xax,1)=255;
         xF2(yax,xax,2)=(1-(xax-round(xb(nbus+1)))/100)*255;
         xF2(yax,xax,3)=0;
     end
 end
 
 pos2=[xb(nbus+1)-15,yb(nbus+1)-15;xb(nbus+1)+100,yb(nbus+1)-15;xb(nbus+1)-2,yb(nbus+1)-35];
 txt2=cell(3,1);
% pos2=[xb(nbus+1)+805,yb(nbus+1)];
txt2{1}=[num2str(0,'%d')];
txt2{2}=[num2str(F2M,'%d'),'EVs'];
txt2{3}=['Legend ',':'];
RGB2=insertText(xF2,pos2,txt2,'FontSize',15,'BoxColor',{'white','white','white'},'TextColor','black');
% RGB2=insertText(xF1,pos2,txt2,'FontSize',10,'TextColor','red');
 

%  F1=imshow(xF1);
 imshow(RGB2);
%  imshow(RGB2);
 title('Electric Vehicles per bus, Arrive in Maximum MCS output');
 G2SD=strcat(Title.case,'F2ToMax.jpg');
 saveas(F2,G2SD);
%  exportgraphics(F1,G1SD,'Resolution',600); R2020a only
 %% F3
 xF3=x;
F3=figure;
print('djpg','-r500');
% xF1(:,:,3)=1;
[F3max,F3pos]=max(GVDfm(:,1));
F3M=ceil(F3max/100)*100;
for b=1:nbus
    if BUS.PCarBus(b)==0
    else
    for xax=round(xb(b)):1:round(xb(b))+10
        for yax=round(yb(b)):1:round(yb(b))+10
            xF3(yax,xax,1)=255;
            xF3(yax,xax,2)=(1-GVDfm(b,1)/F3M)*255;
            xF3(yax,xax,3)=0;
        end
    end
    end
end

 for xax=round(xb(nbus+1)):1:round(xb(nbus+1))+100
     for yax=round(yb(nbus+1))-5:1:round(yb(nbus+1))+5
         xF3(yax,xax,1)=255;
         xF3(yax,xax,2)=(1-(xax-round(xb(nbus+1)))/100)*255;
         xF3(yax,xax,3)=0;
     end
 end
 
 pos3=[xb(nbus+1)-15,yb(nbus+1)-15;xb(nbus+1)+100,yb(nbus+1)-15;xb(nbus+1)-2,yb(nbus+1)-35];
 txt3=cell(3,1);
% pos2=[xb(nbus+1)+805,yb(nbus+1)];
txt3{1}=[num2str(0,'%d')];
txt3{2}=[num2str(F3M,'%d'),'EVs'];
txt3{3}=['Legend ',':'];
RGB3=insertText(xF3,pos3,txt3,'FontSize',15,'BoxColor',{'white','white','white'},'TextColor','black');
% RGB2=insertText(xF1,pos2,txt2,'FontSize',10,'TextColor','red');
 

%  F1=imshow(xF1);
 imshow(RGB3);
%  imshow(RGB2);
 title('Electric Vehicles per bus, Departure in Minimum MCS output');
 G3SD=strcat(Title.case,'F3FrMin.jpg');
 saveas(F3,G3SD);
%  exportgraphics(F1,G1SD,'Resolution',600); R2020a only
 %% F4
 xF4=x;
F4=figure;
print('djpg','-r500');
% xF1(:,:,3)=1;
[F4max,F4pos]=max(GVDtm(:,1));
F4M=ceil(F4max/100)*100;
for b=1:nbus
    if BUS.PCarBus(b)==0
    else
    for xax=round(xb(b)):1:round(xb(b))+10
        for yax=round(yb(b)):1:round(yb(b))+10
            xF4(yax,xax,1)=255;
            xF4(yax,xax,2)=(1-GVDtm(b,1)/F4M)*255;
            xF4(yax,xax,3)=0;
        end
    end
    end
end

 for xax=round(xb(nbus+1)):1:round(xb(nbus+1))+100
     for yax=round(yb(nbus+1))-5:1:round(yb(nbus+1))+5
         xF4(yax,xax,1)=255;
         xF4(yax,xax,2)=(1-(xax-round(xb(nbus+1)))/100)*255;
         xF4(yax,xax,3)=0;
     end
 end
 
 pos4=[xb(nbus+1)-15,yb(nbus+1)-15;xb(nbus+1)+100,yb(nbus+1)-15;xb(nbus+1)-2,yb(nbus+1)-35];
 txt4=cell(3,1);
% pos2=[xb(nbus+1)+805,yb(nbus+1)];
txt4{1}=[num2str(0,'%d')];
txt4{2}=[num2str(F4M,'%d'),'EVs'];
txt4{3}=['Legend ',':'];
RGB4=insertText(xF4,pos4,txt4,'FontSize',15,'BoxColor',{'white','white','white'},'TextColor','black');
% RGB2=insertText(xF1,pos2,txt2,'FontSize',10,'TextColor','red');
 

%  F1=imshow(xF1);
 imshow(RGB4 );
%  imshow(RGB2);
 title('Electric Vehicles per bus, Arrive in Minimum MCS output');
 G4SD=strcat(Title.case,'F4ToMin.jpg');
 saveas(F4,G4SD);
%  exportgraphics(F1,G1SD,'Resolution',600); R2020a only
end