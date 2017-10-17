function [topo_w,latd,lond,lat1,lon1,grad]=compute_topo_w(uwnd,vwnd,air,lev,latnew,lonnew,ltmn,ltmx,lnmn,lnmx);
%
% function [topo_w,latd,lond]=compute_topo_w(uwnd,vwnd,latnew,lonnew,ltmn,ltmx,lnmn,lnmx);

load /home/neil/data/Topo/satopo.mat
% Get Lats and lons for final product
 [m,ilnew(1)]=min(abs(ltmn-latnew));
 [m,ilnew(2)]=min(abs(ltmx-latnew));
 [m,ilnew(3)]=min(abs(lnmn-lonnew));
 [m,ilnew(4)]=min(abs(lnmx-lonnew));
latfinal=latnew(ilnew(1):ilnew(2));
lonfinal=lonnew(ilnew(3):ilnew(4));
u=uwnd(:,ilnew(1):ilnew(2),ilnew(3):ilnew(4),:);
v=vwnd(:,ilnew(1):ilnew(2),ilnew(3):ilnew(4),:);

air=air(:,ilnew(1):ilnew(2),ilnew(3):ilnew(4),:);
levm=repmat(lev.*100,[1 size(air,2) size(air,3) size(air,4)]);
nlv=size(air,1);ntime=size(air,4);
%% Prepare grid to interpolate to
 [m,ilnew(1)]=min(abs(ltmn-latnew));
 [m,ilnew(2)]=min(abs(ltmx-latnew));
 [m,ilnew(3)]=min(abs(lnmn-lonnew));
 [m,ilnew(4)]=min(abs(lnmx-lonnew));
latnew=latnew(ilnew(1):ilnew(2));
lonnew=lonnew(ilnew(3):ilnew(4));
ltdiff=abs(latnew(1)-latnew(2))./2;lndiff=abs(lonnew(1)-lonnew(2))./2;\
ltdiff=0.25;lndiff=0.25;
lat1=[latnew(1)+1.25:-ltdiff:latnew(end)-1.25]';
lon1=[lonnew(1)-1.25:lndiff:lonnew(end)+1.25]';


%  lat1=repmat(lat1,[1 length(lon1)]);
%  lon1=repmat(lon1,[1 size(lat1,1)]);lon1=permute(lon1,[2 1]);

%% Prepare data to interpolate from
 [m,il(1)]=min(abs(ltmn+1.25-lat));
 [m,il(2)]=min(abs(ltmx-1.25-lat));
 [m,il(3)]=min(abs(lnmn-1.25-lon));
 [m,il(4)]=min(abs(lnmx+1.25-lon));
latT=lat(il(2):il(1));latT=flipud(latT);
lonT=lon(il(3):il(4));

%  latT=repmat(latT,[1 length(lonT)]);
%  lonT=repmat(lonT,[1 size(latT,1)]);lonT=permute(lonT,[2 1]);

topo=topo(il(2):il(1),il(3):il(4));
topo=flipdim(topo,1);

%% Interpolate Topo to new grid
topo2=interp2(lonT',latT,topo,lon1',lat1);

ix=find(topo2<0);topo2(ix)=NaN;


dtopo_x = topo2(2:end-1,3:end) - topo2(2:end-1,1:end-2);
dtopo_y = topo2(1:end-2,2:end-1) - topo2(3:end,2:end-1);
[d_lat,d_lon,latd,lond]=delta_latlon(lat1,lon1);
xgrad=dtopo_x./d_lon;
ygrad=dtopo_y./d_lat;grad=xgrad+ygrad;


%  xgrad=interp2(lond',latd,xgrad,lonfinal',latfinal);
%  ygrad=interp2(lond',latd,ygrad,lonfinal',latfinal);grad=ygrad+xgrad;
%  xgrad=repmat(xgrad,[1 1 size(u,1) size(u,4)]);xgrad=permute(xgrad,[3 1 2 4]);
%  ygrad=repmat(ygrad,[1 1 size(u,1) size(u,4)]);ygrad=permute(ygrad,[3 1 2 4]);
%  
%  
%  xw=u.*xgrad;
%  yw=v.*ygrad;
%  
%  topo_w=yw+xw;

%  [topo_w]=convert_omega2pa(topo_w,air,levm);

xgrad=repmat(xgrad,[1 1 size(u,1) size(u,4)]);xgrad=permute(xgrad,[3 1 2 4]);
ygrad=repmat(ygrad,[1 1 size(u,1) size(u,4)]);ygrad=permute(ygrad,[3 1 2 4]);

uwnd=zeros(nlv,length(latd),length(lond),ntime);
vwnd=zeros(nlv,length(latd),length(lond),ntime);
T=vwnd;
P=vwnd;
for lv=1:nlv
 for nt=1:ntime
  uwnd(lv,:,:,nt)=interp2(lonfinal',latfinal,squeeze(u(lv,:,:,nt)),lond',latd);
  vwnd(lv,:,:,nt)=interp2(lonfinal',latfinal,squeeze(v(lv,:,:,nt)),lond',latd);
  T(lv,:,:,nt)=interp2(lonfinal',latfinal,squeeze(air(lv,:,:,nt)),lond',latd);
  P(lv,:,:,nt)=interp2(lonfinal',latfinal,squeeze(levm(lv,:,:,nt)),lond',latd);
 endfor
endfor


xw=uwnd.*xgrad;
yw=vwnd.*ygrad;

topo_w=yw+xw;

[tw]=convert_omega2pa(topo_w,T,P);

topo_w=zeros(nlv,length(latfinal),length(lonfinal),nt);
for lv=1:nlv
 for nt=1:ntime
  topo_w(lv,:,:,nt)=interp2(lond',latd,squeeze(tw(lv,:,:,nt)),lonfinal',latfinal);
 endfor
endfor

latd=latfinal;
lond=lonfinal;
%    ix=find(topo<0);topo(ix)=NaN;






