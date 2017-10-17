function [idx]=getlatlon_i(ltrng,lnrng,lat,lon);
%
% function [idx]=getlatlon_i(ltrng,lnrng,lat,lon);

iltmn=find(lat==ltrng(1));
iltmx=find(lat==ltrng(2));
ilnmn=find(lon==lnrng(1));
ilnmx=find(lon==lnrng(2));
idx=[iltmn iltmx ilnmn ilnmx];

endfunction

