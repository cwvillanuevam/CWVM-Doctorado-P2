ENefunction [PDF,CDF]=pruebav0(mu,sigma)
x=-0:0.01:1;
pd=makedist('normal','mu',mu,'sigma',sigma);
PDF=pdf(pd,x);
CDF=cdf(pd,x);
plot(x,CDF);
end