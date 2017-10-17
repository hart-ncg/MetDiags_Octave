function [qgw,latqg,lonqg]=compute_qgw(DVA,LOTA,w,fsigma,lat,lon,lev);
%
% function [qgw,A_mod,B_mod]=compute_qgw(squeeze(DVA(:,find(latddd==-10):find(latddd==-50),find(londdd==0):find(londdd==70),1)),squeeze(LOTA(:,find(latddd==-10):find(latddd==-50),find(londdd==0):find(londdd==70),1)),squeeze(omega(:,find(lat==-10)-1:find(lat==-50)+1,find(lon==0)-1:find(lon==70)+1,1)),squeeze(fsigma(:,find(latddd==-10):find(latddd==-50),find(londdd==0):find(londdd==70),1)),latddd,londdd,lev);
%
% Calculates quasigeostrophic omega (qgw) using finite element analysis methods
% fullomega grid need be xdim-2;ydim-2;zdim-2 of DVA and LOTA fields
% DVA and LOTA grid is the one on which qgw will be produced
%
% [qgw,latq,lonq,levq]=(DVA(:,1:end,1:end,:),LOTA(:,1:end,1:end,:),omega(2:end-1,4:end-3,4:end-3,:),latddd,londdd,levd)
% Calculate RHS terms of Omega Equation (possibly to be implemented)
%[DVA,LOTA,latddd,londdd,levd]=compute_omegaterms(u,v,air,gph,levm,lat,lon,lev,time);
%
% DVA=DVA(:,7:14,10:16,3);LOTA=LOTA(:,7:14,10:16,3);w=omega(:,9:18,12:20,3);lat=latddd(6:15);lon=londdd(9:17);lev=lev;
% fsigma=fsigma(:,7:14,10:16,3);
%
% whos -v DVA LOTA w fsigma dx2 dy2 dp2 dd_lon dd_lat
%
%
DVA=permute(DVA,[3 2 1]);dva=DVA;
LOTA=permute(LOTA,[3 2 1]);lota=LOTA;
w=permute(w,[3 2 1]);
fsigma=permute(fsigma,[3 2 1]);fsig=fsigma;
nlon=size(w,1);nlat=size(w,2);nlev=size(w,3);
nln=nlon-2;nlt=nlat-2;nlv=nlev-2;
[nln nlt nlv];
% Get grid spacing
[dd_lat,dd_lon,latd,lond]=dd_latlon(lat,lon);dp=[lev(3:end,:)-lev(1:end-2,:)].*100.^2;
d=repmat(dd_lon,[1 1 nlv]);dx=permute(d,[2 1 3]);dx2=1./dx.^2;
d=repmat(dd_lat,[1 1 nlv]);dy=permute(d,[2 1 3]);dy2=1./dy.^2;
d=repmat(dp,[1 nlt nln]);dp=permute(d,[3 2 1]);dp2=1./dp.^2;
% Intialize variables
 REF='w-ii-jj-kk';
 REF=0;REF=repmat(REF,[nln*nlt*nlv 1]);REF=num2cell(REF);
 REF2=zeros(nln*nlt*nlv,1);
A=zeros(nln*nlt*nlv,nln*nlt*nlv);
B=zeros(nln*nlt*nlv,1);
 idx=[1:nln*nlt*nlv];
 idx=reshape(idx,[nln nlt nlv]);
%%%%%%%% MAIN LOOP TO SET UP SIMULATANEOUS EQUATION ARRAY
%  Equation that is implemented: is (d2/dx2+d2/dy2+(f0^2/sigma)*d2/dp2)qgw
%  dx2(w(i+1,j,k)+w(i-1,j,k)) + dy2(w(i,j+1,k)+w(i,j-1,k)) + ...
%   ...  fsigma*dp2(w(i,j,k-1)+w(i,j,k+1)) - 2*(dx2+dy2+k*dp2)*w(i,j,k) = -DVA(i,j,k)-LOTA(i,j,k)
cnt=1;
for i=1:nln;I=i+1;
 for j=1:nlt;J=j+1;
  for k=1:nlv;K=k+1;
     [i j k];
      fs=fsigma(i,j,k);
# #     A(cnt,(i+1)*(j)*(k))=dx2(i,j,k);         A(cnt,(i-1)*(j)*(k))=dx2(i,j,k);
# #     A(cnt,(i)*(j+1)*(k))=dy2(i,j,k);         A(cnt,(i)*(j-1)*(k))=dy2(i,j,k);  
# #     A(cnt,(i)*(j)*(k+1))=fs.*dp2(i,j,k);  A(cnt,(i)*(j)*(k-1))=fs.*dp2(i,j,k);
# #     A(cnt,(i)*(j)*(k))=-2*dx2(i,j,k)+dy2(i,j,k)+fs.*dp2(i,j,k);
   
    B(cnt,1)=-DVA(i,j,k)-LOTA(i,j,k);
    REF{cnt}=['w','-',num2str(i),'-',num2str(j),'-',num2str(k),'-',num2str(cnt)];
    REF2(cnt,1)=idx(i,j,k);

      if (i==1);
       A(cnt,idx(i+1,j,k))=dx2(i,j,k);    
#          A(cnt,idx(i-1,j,k))=0;
#        a1=dx2(i,j,k)*w(I+1,J,K);
       a2=dx2(i,j,k)*w(I-1,J,K);
       B(cnt,1)=B(cnt,1) - a2;
      elseif (i==nln); 
#        A(cnt,idx((i+1)*(j)*(k)))=0;         
       A(cnt,idx(i-1,j,k))=dx2(i,j,k);
       a1=dx2(i,j,k)*w(I+1,J,K);
#        a2=dx2(i,j,k)*w(I-1,J,K);
       B(cnt,1)=B(cnt,1) - a1;
      else
       A(cnt,idx(i+1,j,k))=dx2(i,j,k);         A(cnt,idx(i-1,j,k))=dx2(i,j,k);
      endif
     
      if (j==1);
       A(cnt,idx(i,j+1,k))=dy2(i,j,k);         
#       A(cnt,idx(i,j-1,k))=0;
#        a3=dy2(i,j,k)*w(I,J+1,K);
       a4=dy2(i,j,k)*w(I,J-1,K);
       B(cnt,1)=B(cnt,1) - a4;
      elseif (j==nlt);
#        A(cnt,idx(i,j+1,k))=0;         
       A(cnt,idx(i,j-1,k))=dy2(i,j,k);
       a3=dy2(i,j,k)*w(I,J+1,K);
#        a4=dy2(i,j,k)*w(I,J-1,K);
       B(cnt,1)=B(cnt,1) - a3;
      else
       A(cnt,idx(i,j+1,k))=dy2(i,j,k);         A(cnt,idx(i,j-1,k))=dy2(i,j,k);
      endif

      if (k==1);
       A(cnt,idx(i,j,k+1))=fs.*dp2(i,j,k); 
#       A(cnt,idx(i,j,k-1))=0;
#       a5=fs*dp2(i,j,k)*w(I,J,K+1);
       a6=fs.*dp2(i,j,k)*w(I,J,K-1);
       B(cnt,1)=B(cnt,1) - a6;
      elseif (k==nlv);
#        A(cnt,idx(i,j,k+1))=0;  
       A(cnt,idx(i,j,k-1))=fs.*dp2(i,j,k);
       a5=fs*dp2(i,j,k)*w(I,J,K+1);
#        a6=fs.*dp2(i,j,k)*w(I,J,K-1);
       B(cnt,1)=B(cnt,1) - a5;
      else
       A(cnt,idx(i,j,k+1))=fs.*dp2(i,j,k);  A(cnt,idx(i,j,k-1))=fs.*dp2(i,j,k);
      endif
      
      A(cnt,idx(i,j,k))=-2.*(dx2(i,j,k)+dy2(i,j,k)+fs.*dp2(i,j,k));
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END BOUNDARIES
      cnt=cnt+1;
   end
 end
end
[vl,ii]=sort(REF2);
A_mod=zeros(nln*nlt*nlv,nln*nlt*nlv);
for n=1:length(REF2)
 A_mod(n,:)=A(ii(n),:);
  B_mod(n,1)=B(ii(n),1);
end
 qgomega=A_mod\B_mod;
 qgwt=reshape(qgomega,[nln nlt nlv]);
 qgw=qgwt;
# qgw=0;
latqg=latd;
lonqg=lond;
endfunction