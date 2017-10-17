# trmmexcat.m trmm extract and concatenator for octave
# Currently implemented for daily accumulated rainfall
#    one file per month
clear all

# Region to extract
# This boxes essential extracts South Africa only
ltmn=-35.125;
ltmx=-22.125;
lnmn=17.125;
lnmx=33.125;
trmmAll_sa=[];
tic()
for yr=1998:2007
  for m=1:12
    if m<10
     load('-v7',['dailytt_',num2str(yr),'0',num2str(m),'.mat']);
      else
       load('-v7',['dailytt_',num2str(yr),num2str(m),'.mat']);
    endif

    ilt1=find(lat2==ltmx);
    ilt2=find(lat2==ltmn);
    iln1=find(lon2==lnmn);
    iln2=find(lon2==lnmx);

      subset=dailytotal(ilt1:ilt2,iln1:iln2,:);
      sztr=size(trmmAll_sa,3);szss=size(subset,3);
         trmmAll_sa(:,:,sztr+1:sztr+szss)=subset;
     clear lat2 lon2 dailytotal
  endfor
endfor
toc()
trmmAll_sa(:,:,1)=[];
trmm4xd=permute(trmmAll_sa,[3 1 2]);
trmm4xd=reshape(trmm4xd,size(trmm4xd,1),size(trmm4xd,2)*size(trmm4xd,3));
trmm4xd=permute(trmm4xd,[2 1]);
time=datenum(1998,1,1):datenum(2007,12,31);
timestr=datestr(time,[29]);
time=timestr;clear timestr