function [rgbvals]=map2rgb(Rvar,Gvar,Bvar,opt)
%
% function [rgbvals]=map2rgb(var1,var2,var3)
% [rgbvals]=map2rgb(uwnd(1,:,:,1),vwnd(1,:,:,1),omega(1,:,:,1));
% This function maps the values of the three given variables to the RGB scale 0-255
% var needs to have dimensions X by Y....or...X by Y by Time
Rvar=squeeze(Rvar);
 Gvar=squeeze(Gvar);
  Bvar=squeeze(Bvar);
if strcmp(opt,'std')
  [Rvar]=normalisesurface(Rvar);
   [Gvar]=normalisesurface(Gvar);
    [Bvar]=normalisesurface(Bvar);
endif
% RESHAPING OF INPUT ARRAYS
n1=size(Rvar,1);n2=size(Rvar,2);n3=size(Rvar,3);
Rvar=reshape(Rvar,[n1*n2 n3]);
 Gvar=reshape(Gvar,[n1*n2 n3]);
  Bvar=reshape(Bvar,[n1*n2 n3]);

RGBvar(1,:,:)=Rvar;RGBvar(2,:,:)=Gvar;RGBvar(3,:,:)=Bvar;
% DETERMINE RANGE OF VARIABLE IN EACH INPUT ARRAYS AND CREATE ARRAY OF REFERENCE VALUES TO MAP
% TO SCALE 0:255
mapvals=[0:1:255]';
lmpv=length(mapvals);
for n=1:3
 for m=1:size(RGBvar,3)
  RGBmin=min(RGBvar(n,:,m));RGBmax=max(RGBvar(n,:,m));
   RGBmap(n,:,m)=linspace(0,RGBmax,lmpv);
 endfor
endfor

% MAIN LOOP: ASSIGNS EACH ELEMENT OF EACH INPUT ARRAY A VALUE BETWEEN 0 & 255 
% (i.e. a brightness value for display)
rgbvals=zeros(size(RGBvar,1),size(RGBvar,2),size(RGBvar,3));
 idmat=NaN(2,n2);
for n=1:3
 for m=1:size(RGBvar,3)
  for p=1:lmpv-1
   idmat(:,:)=NaN;
    id1=find(RGBvar(n,:,m) >= RGBmap(n,p,m));idmat(1,id1)=7;
     id2=find(RGBvar(n,:,m) <= RGBmap(n,p+1,m));idmat(2,id2)=7;
      iddiff=idmat(1,:)-idmat(2,:);
       id=find( iddiff==0 );
        rgbvals(n,id,m)=mapvals(p+1);
   endfor
 endfor
endfor
% RESHAPE OUTPUT VARIABLE
rgbvals=reshape(rgbvals,[3 n1 n2 n3]);
rgbvals=permute(rgbvals,[2 3 1]);
endfunction
