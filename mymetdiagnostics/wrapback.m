function [lonnew,varnew]=wrapback(lon,var);
%
% function [lonnew,varnew]=wrapback(lon,var);
%
% This is essentially the reciprocil function of wraparound.m

nlevs=size(var,1);nlat=size(var,2);nlon=size(var,3);ntime=size(var,4);

idx_neglons=find(lon < 0);
 lonfill=360+lon(idx_neglons);nlonfill=length(lonfill);
  varfill=var(:,:,idx_neglons,:);
  idmatch=find(lonfill(1)==lon);
  
lonnew=zeros(idmatch-1,1);
 lonnew(1:end-nlonfill+1)=lon(nlonfill+1:idmatch);
  lonnew(end-nlonfill+1:end)=lonfill;

varnew=zeros(nlevs,nlat,idmatch-1,ntime);
 varnew(:,:,1:end-nlonfill+1,:)=var(:,:,nlonfill+1:idmatch,:);
  varnew(:,:,end-nlonfill+1:end,:)=varfill;





endfunction
