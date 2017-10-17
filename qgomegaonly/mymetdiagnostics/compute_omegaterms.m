function [DVA,LOTA,latddd,londdd,levd,fsigma]=compute_omegaterms(u,v,air,gph,levm,lat,lon,lev,time,lat0);
%
% function [DVA,LOTA]=compute_DVA(uwnd,vwnd,air,lat,lon,lev,time)
%
% Computes Differential Vorticity Advection (DVA) term in Quasi-geostrophic Omega Equation
% Computes Laplacian of Temperature Advection (LOTA) term too
% Operates on datasets with dims lev x lat x lon x time

%%%% Compute Geostrophic winds
[ug,vg,ua,va,latd,lond]=compute_gwind(u,v,gph,lat,lon);
%%%%% Compute stability factor sigma and constant k
pot_t=air.*(1000./levm).^0.286;
 [dp_pot_t,levd]=compute_dp(pot_t,lev);
  [dp_levm,levd]=compute_dp(levm,lev);dp=dp_levm.*100;
Sp=(-1.*air(2:end-1,:,:,:)./pot_t(2:end-1,:,:,:)).*(dp_pot_t./dp);
 sigma=287.*Sp./levm(2:end-1,:,:,:)./100;

 f0=2*7.29e-5.*sin(lat0.*pi()./180);
  k=f0./sigma;
k2=(f0.^2)./sigma;
 fsigma=k2(:,4:end-3,4:end-3,:);

%%% COMPUTATION OF DVA
%%%% Compute geostrophic relative vorticity
%  [var_curl,latdd,londd]=compute_curl(ug,vg,latd,lond,lev,time);
%%%%% Compute horizontal gradient of geo.rel.vort.
%  [xgrad,ygrad,latddd,londdd]=compute_gradient(var_curl,latdd,londd);vortgrad=xgrad+ygrad;
%  %%%%% differential vorticity advection
%  UVA=-1.*ug(:,3:end-2,3:end-2,:).*vortgrad;
%   VVA=-1.*vg(:,3:end-2,3:end-2,:).*vortgrad;
%  [DUVA,levd]=compute_dp(UVA,lev);
%   [DVVA,levd]=compute_dp(VVA,lev);
%  DVA=k(:,4:end-3,4:end-3,:).*DUVA./dp_levm(:,4:end-3,4:end-3,:)+k(:,4:end-3,4:end-3,:).*DVVA./dp_levm(:,4:end-3,4:end-3,:);
[xgrad,ygrad,latdd,londd]=compute_gradcurl(ug,vg,latd,lond,lev,time);
df1=size(ug,1)-size(xgrad,1);df2=size(ug,2)-size(xgrad,2);df3=size(ug,3)-size(xgrad,3);
xad=xgrad.*(-1).*ug(1+df1/2:end-df1/2,1+df2/2:end-df2/2,1+df3/2:end-df3/2,:); yad=ygrad.*(-1).*vg(1+df1/2:end-df1/2,1+df2/2:end-df2/2,1+df3/2:end-df3/2,:);
vortadvec=xad+yad;
[DVA,levd]=compute_dp(vortadvec,lev);

df1=size(k,1)-size(DVA,1);df2=size(k,2)-size(DVA,2);df3=size(k,3)-size(DVA,3);

DVA=k(1+df1/2:end-df1/2,1+df2/2:end-df2/2,1+df3/2:end-df3/2,:).*DVA./dp(1+df1/2:end-df1/2,1+df2/2:end-df2/2,1+df3/2:end-df3/2,:);

%%%%% COMPUTATION OF LOTA
%%%%% Compute horizontal gradient of Temperature
%  [xgrad,ygrad,latd,lond]=compute_gradient(air,lat,lon);tempgrad=xgrad+ygrad;
%  UTA=-1.*ug.*tempgrad;
%   VTA=-1.*vg.*tempgrad;
%   TA=VTA+UTA; 
%  [xgrad,ygrad,latdd,londd]=compute_gradient(TA,latd,lond);gradTA=xgrad+ygrad;
%   [xgrad,ygrad,latddd,londdd]=compute_gradient(gradTA,latdd,londd);
%  LOTA=(xgrad(2:end-1,:,:,:)+ygrad(2:end-1,:,:,:))./Sp(:,4:end-3,4:end-3,:);
[tempadvec,latdd,londd]=compute_advection(air(:,2:end-1,2:end-1,:),ug,vg,latd,lond,lev);
[xlap,ylap,latddd,londdd]=compute_laplacian_horiz(tempadvec,latdd,londd);LOTA=xlap+ylap;
df1=size(Sp,1)-size(LOTA,1);df2=size(Sp,2)-size(LOTA,2);df3=size(Sp,3)-size(LOTA,3);

LOTA=LOTA(2:end-1,:,:,:)./Sp(:,1+df2/2:end-df2/2,1+df3/2:end-df3/2,:);
DVA=DVA(:,2:end-1,2:end-1,:);

endfunction
