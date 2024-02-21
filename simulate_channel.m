function y = simulate_channel (x, SNR, channel_type)

p = length (x);

if channel_type == 'AWGN'; % Type of channel
     SNR = 10^(SNR/10);   % convert SNR to linear scale
     awgn=(1/sqrt(2)).*(randn(1,length(x))+j*randn(1,p)).';  % AWGN channel
     y=(x+(1/sqrt(SNR)).*awgn);    % y = awgn(x,SNR) = additive of noise + input signal   
else
   
   % comm.RayleighChannel creates a frequency-selective or
   % frequency-flat multipath Rayleigh fading channel System object.
 
    channel_ofdm = comm.RayleighChannel();
    y = channel_ofdm(x);
end