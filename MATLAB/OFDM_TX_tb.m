close all

%NLOP = 2;           % number of loop
NFFT = 2048;        % Number of FFT points
NC   = 1440;        % Number of subcarriers
NDS  = 2;           % Number of Data symbol per frame
NS   = NDS*NLOP;    % number of symbols
NP   = 240;         % Number of pilots in symbol
CP   = (1/4)*NFFT;  % cyclic prefix length
PRE  = 1;           % preamble symbol = 1

% Read data in ============================================================

datin_fid = fopen('OFDM_TX_bit_symbols.txt', 'r');
bit_symbols = fscanf(datin_fid, '%d ');
fclose(datin_fid);

datin_fid = fopen('OFDM_TX_bit_symbols_Len.txt', 'r');
para = fscanf(datin_fid, '%d ');
Len  = para(1);
NLOP = para(2);
fclose(datin_fid);
%Read data out of RTL ====================================================
datout_fid = fopen('RTL_OFDM_TX_datout_Re.txt', 'r');
Datout_Re_rtl = fscanf(datout_fid, '%d ');
fclose(datout_fid);
datout_fid = fopen('RTL_OFDM_TX_datout_Im.txt', 'r');
Datout_Im_rtl = fscanf(datout_fid, '%d ');
fclose(datout_fid);
Datout_rtl = (Datout_Re_rtl./2^15) + 1i*(Datout_Im_rtl./2^15);

datout_fid = fopen('RTL_OFDM_TX_Pilots_Insert_Re.txt', 'r');
Pilots_Insert_Re_rtl = fscanf(datout_fid, '%d ');
fclose(datout_fid);
datout_fid = fopen('RTL_OFDM_TX_Pilots_Insert_Im.txt', 'r');
Pilots_Insert_Im_rtl = fscanf(datout_fid, '%d ');
fclose(datout_fid);
Pilots_Insert_rtl = (Pilots_Insert_Re_rtl./2^15) + 1i*(Pilots_Insert_Im_rtl./2^15);

datout_fid = fopen('RTL_OFDM_TX_IFFT_Mod_Re.txt', 'r');
IFFT_Mod_Re_rtl = fscanf(datout_fid, '%d ');
fclose(datout_fid);
datout_fid = fopen('RTL_OFDM_TX_IFFT_Mod_Im.txt', 'r');
IFFT_Mod_Im_rtl = fscanf(datout_fid, '%d ');
fclose(datout_fid);
IFFT_Mod_rtl = (IFFT_Mod_Re_rtl./2^15) + 1i*(IFFT_Mod_Im_rtl./2^15);

% Simulate with data in ===================================================
%Len = length(bit_symbols);
NDS = Len / NC;
NS   = NDS*NLOP;
bit_symbols = reshape(bit_symbols,NC,NS);
%QPSK =====================================================================
QPSK = 1- 2.*mod(bit_symbols,2) + 1i *(1- 2.*floor(bit_symbols/2));

%insert subcarriers & pilots ==============================================
% pilot ===================================================================
pilots_CR;
pils_mod = Pils_802_22.*2-1;
symbol = zeros(NFFT,NS);

for nn = 0: NLOP-1,
    for ii = 1:NDS,
    dat_cnt = 1;
    pil_cnt = 1;
    for jj =1:NFFT,
        if (Al_Vec(jj,ii) == 1),
            symbol(jj,ii+NDS*nn) = 1;
            %pil_cnt       = pil_cnt +1;
        elseif (Al_Vec(jj,ii) == 3),
            symbol(jj,ii+NDS*nn) = -1;
            %pil_cnt       = pil_cnt +1;
        elseif(Al_Vec(jj,ii) == 2),
            symbol(jj,ii+NDS*nn) = QPSK(dat_cnt,ii+NDS*nn);
            dat_cnt       = dat_cnt +1;
        end
    end
    end
end
Pilots_Insert_sim = reshape(symbol, 1, NFFT*NS);
%IFFT =================================================================
tx_d =  ifft(symbol, NFFT);

%Add CP ===============================================================
tx_d = [tx_d(NFFT-CP+1: NFFT,:); tx_d];

IFFT_Mod_sim = reshape(tx_d, 1, (NFFT+CP)*NS);
%Add Preamble =========================================================
tx_out = zeros((NFFT+CP), (PRE + NDS)*NLOP);

preamble_CR;   
preamble_nor = [short_pre]; 
preamb = reshape(preamble_nor, NFFT+CP, PRE);
for ii = 0:NLOP -1,
    for jj = 1:PRE,
        tx_out(:,(PRE + NDS)*ii+jj) = preamb(:,jj);                  
    end
    if (NDS ~=0 )
        for jj = 1:NDS,
            tx_out(:,(PRE + NDS)*ii+PRE+jj) = tx_d(:,ii*NDS+jj);            
        end
    end
end
Datout_sim = reshape(tx_out, 1, (NFFT+CP)*(PRE + NDS)*NLOP);

% Plotting ================================================================
figure(1);
plot(1:length(Pilots_Insert_sim), real(Pilots_Insert_sim),'o-b');
hold on
plot(1:length(Pilots_Insert_rtl), real(Pilots_Insert_rtl),'x-r');
 ylim([-3 3]);
title('comparison of Pilots\_Insert output');
legend('Pilots\_Insert\_sim','Pilots\_Insert\_rtl');

figure(2);
plot(1:length(IFFT_Mod_sim), imag(IFFT_Mod_sim),'o-b');
hold on
plot(1:length(IFFT_Mod_rtl), imag(IFFT_Mod_rtl),'x-r');
title('comparison of IFFT\_Mod output');
legend('IFFT\_Mod\_sim','IFFT\_Mod\_rtl');

figure(3);
plot(1:length(Datout_sim), real(Datout_sim),'o-b');
hold on
plot(1:length(Datout_rtl), real(Datout_rtl),'x-r');
title('comparison of Data output of transmitter');
legend('Datout\_sim','Datout\_rtl');

