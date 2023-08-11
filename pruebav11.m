function val=pruebav11(pd,xmin,xmax,pop)
% x=xmin:xint:xmax;
% xl=length(x);
% PDF=pdf(pd,x);
% CDF=cdf(pd,x);
% plot(x,PDF,x,CDF);
% pis=zeros(pop,1);
val=zeros(pop,1);
     rng('shuffle');
for i=1:pop
    sval=random(pd);
    if sval<xmin
        val(i,1)=xmin;
    elseif sval>xmax
        val(i,1)=xmax;
    else
        val(i,1)=sval;
    end
%     svalind=1;
%     j=1;
%     while sval>x(j)
%             svalind=svalind+1;
%             j=j+1;
%             if j>=xl
%                 break
%             end
%     end
%     if svalind>xl
%         svalind=xl;
%     end
%     pis(i,1)=PDF(svalind);
end
end