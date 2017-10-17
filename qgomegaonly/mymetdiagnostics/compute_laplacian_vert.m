function [zlap,levd]=compute_laplacian_vert(vrb,lev);

% [ddp_vrb,levd]=compute_laplacian_vert(vrb,lev);
%
% Computes finite difference in vertical, generally for use with pressure as the vertical dimension
% so essential the vertical gradient

n1=size(vrb,1);n2=size(vrb,2);n3=size(vrb,3);n4=size(vrb,4);

dp_var = vrb(2:end,:,:,:) - vrb(1:end-1,:,:,:);
ddp_var= dp_var(2:end,:,:,:) - dp_var(1:end-1,:,:,:);

[ddp_lev,levd]=dd_vert(lev,n1,n2,n3,n4);

zlap=ddp_var./(ddp_lev.^2);

endfunction