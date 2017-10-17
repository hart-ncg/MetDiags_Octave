function [varn]=normalisesurface(var);

% function [varn]=normalisesurface(var);
%
% normalises a variable to the standard normal distribution
% var needs to have dimensions X by Y....or...X by Y by Time

if ndims(var)==2;n1=size(var,1);n2=size(var,2);var=reshape(var,[n1*n2 1]);endif
if ndims(var)==3;n1=size(var,1);n2=size(var,2);n3=size(var,3);var=reshape(var,[n1*n2 n3]);endif
l=size(var,2);
 varm=mean(var,1);
  vars=std(var,0,1);
varn=zeros(n1*n2,l);
for n=1:l
 varn(:,n)=(var(:,n)-varm(:,n))./vars(:,n);
endfor

varn=reshape(varn,[n1 n2 l]);

endfunction
