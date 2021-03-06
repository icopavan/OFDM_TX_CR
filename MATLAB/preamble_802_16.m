pall= ...
[ 1-1i, 1-1i,-1-1i, 1+1i, 1-1i, 1-1i,-1+1i, 1-1i, 1-1i, 1-1i, ...
  1+1i,-1-1i, 1+1i, 1+1i,-1-1i, 1+1i,-1-1i,-1-1i, 1-1i,-1+1i, ...
  1-1i, 1-1i,-1-1i, 1+1i, 1-1i, 1-1i,-1+1i, 1-1i, 1-1i, 1-1i, ...
  1+1i,-1-1i, 1+1i, 1+1i,-1-1i, 1+1i,-1-1i,-1-1i, 1-1i,-1+1i, ...
  1-1i, 1-1i,-1-1i, 1+1i, 1-1i, 1-1i,-1+1i, 1-1i, 1-1i, 1-1i, ...
  1+1i,-1-1i, 1+1i, 1+1i,-1-1i, 1+1i,-1-1i,-1-1i, 1-1i,-1+1i, ...
  1+1i, 1+1i, 1-1i,-1+1i, 1+1i, 1+1i,-1-1i, 1+1i, 1+1i, 1+1i, ...
 -1+1i, 1-1i,-1+1i,-1+1i, 1-1i,-1+1i, 1-1i, 1-1i, 1+1i,-1-1i, ...
 -1-1i,-1-1i,-1+1i, 1-1i,-1-1i,-1-1i, 1+1i,-1-1i,-1-1i,-1-1i, ...
  1-1i,-1+1i, 1-1i, 1-1i,-1+1i, 1-1i,-1+1i,-1+1i,-1-1i, 1+1i, ...
  0+0i, ...
 -1-1i, 1+1i,-1+1i,-1+1i,-1-1i, 1+1i, 1+1i, 1+1i,-1-1i, ...
  1+1i, 1-1i, 1-1i, 1-1i,-1+1i,-1+1i,-1+1i,-1+1i, 1-1i,-1-1i, ...
 -1-1i,-1+1i, 1-1i, 1+1i, 1+1i,-1+1i, 1-1i, 1-1i, 1-1i,-1+1i, ...
  1-1i,-1-1i,-1-1i,-1-1i, 1+1i, 1+1i, 1+1i, 1+1i,-1-1i,-1+1i, ...
 -1+1i, 1+1i,-1-1i, 1-1i, 1-1i, 1+1i,-1-1i,-1-1i,-1-1i, 1+1i, ...
 -1-1i,-1+1i,-1+1i,-1+1i, 1-1i, 1-1i, 1-1i, 1-1i,-1+1i, 1+1i, ...
  1+1i,-1-1i, 1+1i,-1+1i,-1+1i,-1-1i, 1+1i, 1+1i, 1+1i,-1-1i, ...
  1+1i, 1-1i, 1-1i, 1-1i,-1+1i,-1+1i,-1+1i,-1+1i, 1-1i,-1-1i, ...
 -1-1i, 1-1i,-1+1i,-1-1i,-1-1i, 1-1i,-1+1i,-1+1i,-1+1i, 1-1i, ...
 -1+1i, 1+1i, 1+1i, 1+1i,-1-1i,-1-1i,-1-1i,-1-1i, 1+1i, 1-1i, 1-1i];

p4_64_p = zeros(1,100);
p4_64_n = zeros(1,100);
k=1:1:25;
p4_64_p(4*k)    = 2.*( conj(pall(4*k+101)) );
p4_64_n(101-4*k)= 2.*( conj(pall(101-4*k)) );
p4_64 = [0, p4_64_p, zeros(1, 55) p4_64_n];
STS_802_16 = ifft(p4_64,256);

peven_p = zeros(1,100);
peven_n = zeros(1,100);
k=1:1:50;
peven_p(2*k)    = sqrt(2).*( (pall(2*k+101)) );
peven_n(101-2*k)= sqrt(2).*( (pall(101-2*k)) );
peven = [0, peven_p, zeros(1, 55) peven_n];
LTS_802_16 =  ifft(peven,256);

DL_preamble_802_16 = [STS_802_16(256-CP_802_16 +1:256), STS_802_16, LTS_802_16(256-CP_802_16+1:256), LTS_802_16];
UL_preamble_802_16 = [LTS_802_16(256-CP_802_16+1:256), LTS_802_16];

pre_802_16 = DL_preamble_802_16;
