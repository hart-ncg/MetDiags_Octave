function [dp_var,levd]=compute_dp(var,lev);

% function [dp_var,levd]=compute_dp(var,levm);
%
% Computes finite difference in vertical, generally for use with pressure as the vertical dimension
% so essential the vertical gradient

n1=size(var,1);n2=size(var,2);n3=size(var,3);n4=size(var,4);

var=reshape(var,[n1 n2*n3*n4]);


dp_var = var(3:end,:) - var(1:end-2,:);

levd=lev(2:end-1);

dp_var=reshape(dp_var,[n1-2 n2 n3 n4]);
%%%%%%%%%% OR
%  dp_var = var(2:end,:) - var(1:end-1,:);
%  
%  levd=lev(2:end)+lev(1:end-1);levd=levd./2;
%  
%  dp_var=reshape(dp_var,[n1-1 n2 n3 n4]);




endfunction
