%Group: 8

clc;
close all;
clear all;


switch_graph = 0;    %For BER, switch_graph = 0 %For graph if 1>>show, else>>not show.
switch_off = 0;    % If 1>>switch off, If 0>>switch on the function
N_blocks = 14; %length(d)/fft_size;
fft_size = 1024;   % FFT length



[parity_check_matrix,generator_matrix] = hammgen(3); % 3x7 matrix
generator_matrix = generator_matrix.'; % generator_matrix = 4x7, generator_matrix.' =7x4
% generate the parity check and generator matrix

sampling_factor = 20;
down_sampling_factor = 20;

constellation_order = 4; % 2 = 4QAM, 4 = 16QAM, 6 = 64QAM

cp_size = 256;  % 25% of the fft_size

tx_clipping_threshold = 20;

channel_type = 'AWGN'; % channel type: 'AWGN', 'FSBF'

                   % snr = 1:1:20; % SNR in db
 
                   % for snr_db = 1 : length(snr)
    
%--------TRANSMITTER--------
    
    % ----- digital source -----
 
    frame_size = floor(( fft_size * N_blocks * constellation_order)/7)* 4; %According to the OFDM parameters
    b = generate_frame (frame_size, switch_graph);
    
    %------Channel coding------
    pad_zero = length(b);
    pad_zero_1 = 7 * (pad_zero/4);
    pad_zero_2 = mod(pad_zero_1, 1024); 
    
    % Pad zeroes after encoding based on their respective lengths.
    if pad_zero_2 == 0
        n_zero_padded_bits = 0;
    else
        n_zero_padded_bits = pad_zero_2;
    end
    
   % switch_off = 1;
    
    c = encode_hamming (b, generator_matrix, n_zero_padded_bits, switch_off);
    
%-------Modulation-------

    d = map2symbols (c, constellation_order, switch_graph);
    
%-----Pilot insertion------
    
    N_blocks = length(d)/fft_size; % 7 = 7168/1024
    
    if constellation_order == 2
        QAM = [-1-1i;1-1i;-1+1i;1+1i];
        p = randi([1 4],fft_size,1); % pick random Integers from 1 to 4 of size 1024*1
        for i=1:length(p)  %length(p) = 1024
            pilot_symbols(i,1)= QAM(p(i),1);
        end
        pilot_symbols = pilot_symbols/sqrt(2); % from literature
    elseif constellation_order == 4
        QAM = [-3-3i;-3-1i;-3+3i;-3+1i;-1-3i;-1-1i;-1+3i;-1+1i;3-3i;3-1i;3+3i;3+1i;1-3i;1-1i;1+3i;1+1i];
        p = randi([1 16],fft_size,1); % pick random Integers from 1 to 16 of size 1024*1
        for i=1:length(p)
            pilot_symbols(i,1)= QAM(p(i),1);
        end
        pilot_symbols = pilot_symbols/sqrt(10);
    else
        QAM = [-7+7i;-7 + 5i;-7 + 1i;-7 + 3i;-7-7i;-7-5i;-7-1i;-7-3i;-5+7i;-5+5i;-5+1i;-5+3i;-5-7i;-5-5i;-5-1i;-5-3i;-1+7i;-1+5i;-1+1i;-1+3i;-1-7i;-1-5i;-1-1i;-1-3i;-3+7i;-3+5i;-3+1i;-3+3i;-3-7i;-3-5i;-3-1i;-3-3i;5+7i;5+5i;5+1i;5+3i;5-7i;5-5i;5-1i;5-3i;7+7i;7+5i;7+1i;7+3i;7-7i;7-5i;7-1i;7-3i;3+7i;3+5i;3+1i;3+3i;3-7i;3-5i;3-1i;3-3i;1+7i;1+5i;1+1i;1+3i;1-7i;1-5i;1-1i;1-3i];
        p = randi([1 64],fft_size,1); % pick random Integers from 1 to 64 of size 1024*1
        for i=1:length(p)
            pilot_symbols(i,1)=QAM (p(i),1);
        end
        pilot_symbols = pilot_symbols/sqrt(42);
    end
    
    D = insert_pilots (d, fft_size, N_blocks, switch_graph, pilot_symbols);
    
    %------OFDM_TX------
    
    z = modulate_ofdm (D, fft_size, cp_size, switch_graph);
    
    %------Tx Filter-----
    
  %  switch_off = 1;
    
    s = filter_tx (z, sampling_factor, switch_graph, switch_off);
    
    %--------Non-Linear Hardware-------
    
    x = impair_tx_hardware(s, tx_clipping_threshold, switch_graph);
    
   %-------CHANNEL------
snr = 1:1:20; % SNR in db   
if switch_graph ==  1
    
    snr_db = 20;
    
    y = simulate_channel(x, snr_db, channel_type );
    
    figure('name','Channel AWGN/FSBF'); %to display Channel.p file, could not write inside
    plot(real(x),'g','LineWidth',2);
    title('Channel')
    grid on
    hold on
    plot(real(y),'m','LineWidth',1);
    xlabel('Oversampled Sequence');
    ylabel('Amplitude');
    legend('y, before Noise', 'after Noise');
    grid on
%-------Reciever---------

       %--------Non-Linear Hardware------
    
    s_tilde = impair_rx_hardware(y, tx_clipping_threshold, switch_graph);
    
     %-------RX-Filter--------
 %   switch_off = 1;
    z_tilde = filter_rx (s_tilde, down_sampling_factor, switch_graph, switch_off);
    
    %---------OFDM-Demodulation-----
    
    D_tilde = demodulate_ofdm (z_tilde, fft_size, cp_size, switch_graph);
    
    %----------Equalizer---------
    
    d_bar = equalize_ofdm (D_tilde, pilot_symbols, switch_graph);
    
    %---------Demodulation--------
    
    c_hat = detect_symbols (d_bar, constellation_order, switch_graph);
    
    %----- Channel Decoding -------
    
 %   switch_off = 1;
    b_hat = decode_hamming (c_hat, parity_check_matrix,n_zero_padded_bits, switch_off, switch_graph);
    
    
    %-------  Digital Sink -----
    
 %   [BER_1(snr_db),BER_2(snr_db)] = digital_sink(b, b_hat, c, c_hat);

    BER_1(snr_db) = digital_sink(b, b_hat);
     if switch_off==0
         BER_2(snr_db) = digital_sink(c,c_hat);
    end    
    
else    
    
    snr = 1:1:20; % SNR in db
    
    for snr_db = 1 : length(snr)
        
        y = simulate_channel(x, snr_db, channel_type );
        
        %------Reciever---------
        
        %--------Non-Linear Hardware------
        
        s_tilde = impair_rx_hardware(y, tx_clipping_threshold, switch_graph);
        
        %--------RX-Filter-----
        %   switch_off = 1;
        z_tilde = filter_rx (s_tilde, down_sampling_factor, switch_graph, switch_off);
        
        %-------OFDM-Demodulation-------
        
        D_tilde = demodulate_ofdm (z_tilde, fft_size, cp_size, switch_graph);
        
        %--------Equalizer-------
        
        d_bar = equalize_ofdm (D_tilde, pilot_symbols, switch_graph);
        
        %--------Demodulation------
        
        c_hat = detect_symbols (d_bar, constellation_order, switch_graph);
        
        %------- Channel Decoding ---
        
        %   switch_off = 1;
        b_hat = decode_hamming (c_hat, parity_check_matrix,n_zero_padded_bits, switch_off, switch_graph);
        
        
        %--------  Digital Sink -------
        
         %  [BER_1(snr_db),BER_2(snr_db)] = digital_sink(b, b_hat, c, c_hat);
        
        BER_1(snr_db) = digital_sink(b, b_hat);
        if switch_off==0
            BER_2(snr_db) = digital_sink(c,c_hat);
        end
        
        
    end
    
    % Figures

% SNR vs BER Plot
figure('name','BER VS SNR ')
semilogy(snr, BER_1,'k*-','linewidth',1,'color','c');
title('Coded and Uncoded BER')
hold on
grid on;
xlabel('SNR(dB) -->');
ylabel('BER -->');
semilogy(snr, BER_2,'k*-','linewidth',1,'color','m');
legend('coded BER','uncoded BER')
% legend('BER')
hold off

k = length(x)/(fft_size+cp_size);
l = k/sampling_factor;
y = x(1:sampling_factor:end);
ss = reshape(y,(fft_size+cp_size),l);
S = ss(1+cp_size:(fft_size+cp_size),:);
users = 1:1:fft_size;
peak = zeros(1,fft_size);
Avg = zeros(1,fft_size);
PAPR = zeros(1,fft_size);
energy = zeros(l,1);
f = 0;
for i = 1:fft_size
    
    peakpower1 = S(i,:);
    
    for j = 1:length(peakpower1)
        energy(j,1) = (peakpower1(1,j) * conj(peakpower1(1,j)));
    end
    
    f = f+1;
    peak(1,f) = max(energy);
    Average = mean(energy);
    Avg(1,f) = Average;
    PAPR(1,f) = peak(1,f)/Avg(1,f);
end

% PAPR Plot
figure('name','Users VS PAPR');
plot(users,10*log10(PAPR),'k*-','linewidth',1,'color','g');
title ('User VS PAPR');
xlabel ('Samples');
ylabel ('Max Power in dB');
    
end




