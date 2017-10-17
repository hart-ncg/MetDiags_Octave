function [ddp_lev,levd]=dd_vert(lev,n1,n2,n3,n4);

% function [ddp_lev,levd]=dd_vert(lev);
%
% Computes finite difference in vertical, generally for use with pressure as the vertical dimension
% so essential the vertical gradient
levd=lev(2:end-1);
lev=repmat(lev.*100,[n1 n2 n3 n4]);

dp_lev = (lev(2:end,:,:,:) + lev(1:end-1,:,:,:))./2;
ddp_lev= dp_lev(2:end,:,:,:) - dp_lev(1:end-1,:,:,:);

endfunction
