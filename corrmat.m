% permet de calculer les correlations
% entre une matrice et une serie.
% les valeurs sont standardisees au
% prealable sino on obtient la matrice de covariance
% x=matrice
% y=serie
% cor=corrmat(x,y);
function cor=corrmat(x,y);
if nargin < 2,
 error('ERREUR : 2 arguments sont necessaires');
else
[nlig ncol]=size(x);
[nlig1 ncol2]=size(y);
if nlig ~=nlig1;
 error('ERREUR : les series doivent avoir le meme nombre d observations')
end;
x=zscore(x);
y=zscore(y);
cor=(y'*x)/(nlig-1);
end;
