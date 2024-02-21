function b_hat = decode_hamming (c_hat, parity_check_matrix, n_zero_padded_bits, switch_off, switch_graph)




if  switch_off == 1
    b_hat=c_hat;  
else
  b_hat=zeros(length(c_hat):1); % length(c_hat) = 1024; % b_hat = received_signal
    
    %Create a table of syndromes to facilitate error detection.
    T = syndtable(parity_check_matrix); %creating a syndrome table from P_C_M
    
    for k=1:(length(c_hat)/7) % so, k= 1 to 146
        % The variable 'ham_dec' stores 7 bits in a successive manner.
        ham_dec=c_hat((7*(k-1))+1:7*k)'  ;    % 00000001
        %syndrome calculation
        syndrome=rem(ham_dec* parity_check_matrix',2);
        syndrome_int = bi2de(syndrome,'left-msb'); % Convert the syndrome to its decimal representation
%        disp(['Syndrome = ',num2str(syndrome_int),' (decimal), ',num2str(syndrome),' (binary)']);
        %Check whether the syndrome is zero or not. If it is not zero,perform error correction.
       
        if syndrome_int>0    % If a syndrome exists, locate the corresponding error in the syndrome table.
            corr_vect = T(1+syndrome_int,:); % Correction vector #column 6, #00000001
            %%error correction
            ham_dec=rem(corr_vect+ham_dec,2); %Corrected word ,mod 2 add = mod 2 subtract
            %taking the last three bits.
            b_hat((4*(k-1))+1:4*k) = ham_dec(4:7);
        else
            %if no syndrome
            b_hat((4*(k-1))+1:4*k)=ham_dec(4:7);
        end
    end
     b_hat=b_hat';
end

