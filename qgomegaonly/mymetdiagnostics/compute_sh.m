function [sh,e,es]=compute_sh(rh,temp,pres,svpf)

% function [sh,e,es]=compute_sh(rh,temp,pres,svpf)
% 
% computes specfic humdidity from temperature, relative humidity
% and pressure
% Currently has Goff-Gratch and Bolton empirical relationships
% 
% svpf='GG' or 'Bolt'

tc=temp-273.16;
%%%%%%%%%%%%%%%% Calculation of es %%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%% Goff-Gratch %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(svpf,'GG')
eilog = -7.90298.*(373.16./temp-1);
eilog2 = 5.02808.*log10(373.16./temp);
eilog3 = -1.3816e-7.*(10.^(11.344*(1-temp./373.16))-1);
eilog4 = 8.1328e-3.*(10.^(-3.49149*(373.16./temp-1))-1);
es = 1013.246.*10.^(eilog+eilog2+eilog3+eilog4);
endif
%%%%%%%%%%%%%%% Bolton %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(svpf,'Bolt')
es=0.6112.*exp(17.67.*tc./(tc+243.5));
es=es*10;
endif
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

e=rh.*es./100;
sh=0.622.*e./(pres-0.378.*e);

endfunction