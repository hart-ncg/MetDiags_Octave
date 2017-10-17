function [var_on_isen]=var2isen(yyyy,var,p_on_isen,iup,idn,isk,p);
%
% function [var_on_isen]=var2isen(yyyy,var,p_on_isen,iup,idn,isk,p);
% Interpolate VARIABLE to isentropic surface using method described in section 4.(b) of
% Shen et al., Mon.Wea.Rev.,1986. using equation no.19

% Get dimensions
nisk=size(isk,1);nlevs=size(var,1);nlat=size(var,2);nlon=size(var,3);ntime=size(var,4);
% Data preparation for loop to follow
var=reshape(var,[nlevs nlat*nlon*ntime]);
iup=reshape(iup,[nisk nlat*nlon*ntime]);
idn=reshape(idn,[nisk nlat*nlon*ntime]);
p=reshape(p.*100,[nlevs nlat*nlon*ntime]);
p_on_isen=reshape(p_on_isen,[nisk nlat*nlon*ntime]);
var_on_isen=NaN(nisk,nlat*nlon*ntime);

 for n=1:nisk
  for j=1:nlat*nlon*ntime
    iu=(iup(n,j));if isnan(iu);continue;endif
    id=(idn(n,j));if isnan(id);continue;endif
     if (iu==id);continue;endif
      var_u=var(iu,j);var_d=var(id,j);var_uu=var(iu+1,j);
       p_u=p(iu,j);p_d=p(id,j);p_uu=p(iu+1,j);
         p_isen=p_on_isen(n,j);
%%%%%%% Calculate variable on isen surface 
         c1=1/(log(p_d/p_u)*log(p_d/p_uu));if (isnumeric(c1) != 1);continue;endif
          c2=1/(log(p_u/p_d)*log(p_u/p_uu));if (isnumeric(c2) != 1);continue;endif
           c3=1/(log(p_uu/p_d)*log(p_uu/p_u));if (isnumeric(c3) != 1);continue;endif
           
var_on_isen(n,j)=c1*log(p_isen/p_u)*log(p_isen/p_uu)*var_d + ...
                     c2*log(p_isen/p_d)*log(p_isen/p_uu)*var_u + ...
                       c3*log(p_isen/p_d)*log(p_isen/p_u)*var_uu;
   %   if (var_on_isen(n,j)>75);disp([var_on_isen(n,j) p_d p_u p_uu p_isen n j]);endif
  endfor
 endfor
    var_on_isen=reshape(var_on_isen,[nisk nlat nlon ntime]);

save('-v6',['var2isen',num2str(yyyy),'.mat'],'var_on_isen')
endfunction
