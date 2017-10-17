function [var_daily,timedaily]=daily(var,time,action);
%
% function [var_daily,timedaily]=daily(var,time,'action');
%
% Function to perform the daily mean/sum of ncep 4xDaily data (or any other 4xdaily dataset)
% USAGE: Ensure that time is the last dimension in the input variable
% for ACTION: ensure a string is given here, options: 'mean'/'sum';
if nargin()==2;action='mean';end

% set daily timestep stride here (4 for 4xdaily)
st=4;

n1=size(var,1);n2=size(var,2);n3=size(var,3);n4=size(var,4);
nt=n4;if (nt ~= length(time));return;end

nds=nt/4;
var_daily=zeros(n1,n2,n3,nds);timedaily=zeros(nds,1);

if strcmp(action,'mean')
 for n=0:nds-1
  var_daily(:,:,:,n+1)=mean(var(:,:,:,1+n*4:st+n*4),4);
   timedaily(n+1)=mean(time(1+n*4:st+n*4));
 end
end

if strcmp(action,'sum')
 for n=0:nds-1
  var_daily(:,:,:,n+1)=sum(var(:,:,:,1+n*4:st+n*4),4);
   timedaily(n+1)=mean(time(1+n*4:st+n*4));
 end
end
