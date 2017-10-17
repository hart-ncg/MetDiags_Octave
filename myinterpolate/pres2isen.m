function [p_on_isen,sf]=pres2isen(p,t,gph,iup,idn,isk,yyyy)
%
% function [p_on_isen]=pres2isen(p,t,gph,iup,idn)
%
% uses method (d) from Ziv and Alpert, J. App. Met., 1994
% to interpolate pressure onto isentropic surfaces
% note that iup & idn have dims   nisk x nlat x nlon x ntime
% Returns p_on_isen = pressure value on isentropic surfaces
%         sf = stability factor dtheta/dp used in PV calculation
% Constants
R=287;
Cp=1005;
g=9.81;
P_o=1000.*100;
k=R/Cp;

nisk=size(isk,1);
nlevs=size(t,1);nlat=size(t,2);nlon=size(t,3);ntime=size(t,4);
t=reshape(t,[nlevs nlat*nlon*ntime]);
gph=reshape(gph,[nlevs nlat*nlon*ntime]);
p=reshape(p.*100,[nlevs nlat*nlon*ntime]);
iup=reshape(iup,[nisk nlat*nlon*ntime]);
idn=reshape(idn,[nisk nlat*nlon*ntime]);
% Calculate pressure on isen surface assuming linear dependence of temperature on height
p_on_isen=NaN(nisk,nlat*nlon*ntime);
sf=NaN(nisk,nlat*nlon*ntime);
for n=1:nisk
  for j=1:nlat*nlon*ntime
    iu=(iup(n,j));if isnan(iu);continue;endif
    id=(idn(n,j));if isnan(id);continue;endif
     if (iu==id);continue;endif
     gph_u=gph(iu,j);gph_d=gph(id,j);
        t_u=t(iu,j);t_d=t(id,j);
         p_u=p(iu,j);p_d=p(id,j);
%%%%%%% Calculate pressure on isen surface
      lr=(t_d-t_u)/(gph_u-gph_d);
       alpha=R*lr/g;
        B=(alpha-k);
         p_upper_alpha=p_u^alpha;
          A=t_u*P_o^k/p_upper_alpha;
           p_on_isen(n,j)=(isk(n)/A)^(1/B);
if (p_on_isen(n,j)<100);disp([p_d p_u iu id j n]);endif
%%%%%%%% Calculate stability factor on isen surface
         A=t_u*P_o^k/p_upper_alpha;
         sf(n,j)=B*A*(p_on_isen(n,j))^(B-1);
  endfor
endfor
    p_on_isen=reshape(p_on_isen,[nisk nlat nlon ntime]);
    sf=reshape(sf,[nisk nlat nlon ntime]);

save('-v6',['/home/neil/data/6hourly/isentropic/pres2isen',num2str(yyyy),'.mat'],'p_on_isen','sf')

endfunction

