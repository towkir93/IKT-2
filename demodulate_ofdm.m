function D_tilde = demodulate_ofdm (z_tilde, fft_size, cp_size, swich_graph)

L= length(z_tilde); %length of z_tilde is taken. Here z_tilde = 28160x1 matrix and length(z_tilde)= 28160,

% the received signal reshaped into a 1-by-L matrix, i.e, 1x28160 matrix
signal_reshaped = reshape(z_tilde,1,L);

M = fft_size+cp_size; % 1024+256

N = (L-mod(L,M))/M; % n = 8, make the length of z_tilde dividable by M

A = signal_reshaped(1:M*N);

A_1 = reshape(A,M,N);  % serial to parallel conversion

A_2 = A_1(1+cp_size:M,:);

D_tilde = fft(A_2); % doing fft

if swich_graph == 1
    K_reshape = reshape(D_tilde,fft_size*N,1);
    scatterplot(K_reshape);  % Create a constellation diagram by visualizing the data using a scatter plot.
    title('Constellation diagram after OFDM demodulation')
end
end



