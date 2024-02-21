function z = modulate_ofdm(D, fft_size, cp_size, switch_graph)
D_ifft = ifft(D); % Perform IDFT
[numRows, numCols] = size(D_ifft);

cp = zeros(cp_size, numCols);
for i = 1:cp_size
    cp(i, :) = D_ifft(fft_size - cp_size + i, :);
end

frame = [cp; D_ifft];
[frameRows, frameCols] = size(frame);

z = reshape(frame, 1, frameRows * frameCols); % Convert to series data

if switch_graph == 1
    a = fft_size + cp_size;
    B = z(1:a);
    
    [H, W] = freqz(z, 1, 512); % Compute amplitude and frequency values
    
    figure('name', 'OFDM symbol in Time Domain');
    plot(real(B));
    title('OFDM Symbol in Time Domain');
    xlabel('OFDM Symbol Sequence');
    ylabel('Amplitude');
    
    figure('name', 'OFDM symbol in Frequency Domain');
    plot(W, 20 * log10(abs(H)));
    xlabel('\omega');
    ylabel('H in dB');
    title('OFDM Symbol in Frequency Domain');
end