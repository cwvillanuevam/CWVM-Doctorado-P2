function val=prueba11(pd,xmin,xmax)
% x=xmin:xint:xmax;
% xl=length(x);
% PDF=pdf(pd,x);
% CDF=cdf(pd,x);
% plot(x,PDF,x,CDF);
% pis=zeros(pop,1);
    rng('shuffle');
    sval=random(pd);
    if sval<xmin
        val=xmin;
    elseif sval>xmax
        val=xmax;
    else
        val=sval;
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