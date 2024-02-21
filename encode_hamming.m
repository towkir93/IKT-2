function c = encode_hamming(b, generator_matrix, n_zero_padded_bits, switch_off)

% if switch_off is 0, no channel coding is performed

if switch_off == 1
    c_add = zeros(n_zero_padded_bits, 1);
    c = cat(1, b, c_add);  % Concatenate arrays b and c_add along the dimension 1
    
else
    L = length(b); % L=49152
    N = L/4; %N = 12288
    
    % Size of b must be = 4*N ( multiplied b by 7*4 "G" matrix)
    b_new = reshape(b, 4, N); % reshape b of dimension (49152*1) into (4*12288 )
    c1 = generator_matrix * b_new; %(G = 7*4, b_new = 4*12288) = c1 =7*12288
    c2 = mod(c1, 2); % Convert c1 to binary (0 or 1), c2 = 12288
    
    N2 = 7 * N; % N2 = 86016
    c_no_zeros = reshape(c2, N2, 1);      % c_w_z =86016*1
    c_add = zeros(n_zero_padded_bits, 1); % c_add = 0
    c = [c_no_zeros; c_add]; % c = 86016*1
    
end
end