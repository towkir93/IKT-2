function d_bar = equalize_ofdm(D_tilde, pilot_symbols, switch_graph)

    pilot_symbols__old = pilot_symbols;
    Data_unequalized = D_tilde(:,2:end);
    
    for i = 1:1024   % fft_size = 1024
       pilot_1(i,1) = D_tilde(i,1)./pilot_symbols__old(i,1); 
    end
    
    [m,n] = size(Data_unequalized);
    
    Data_equalized = zeros(m,n);
    
   
    for i=1:m
     for j=1:n
        Data_equalized(i,j) = (Data_unequalized(i,j))/pilot_1(i,1);
     end
    end
        
    d_bar=reshape(Data_equalized,m*n,1);
    
    if switch_graph==1
        figure('name','Constellation diagram after Equalizer');
        plot(d_bar,'r*');
        title('Constellation diagram after Equalizer');
        xlabel('In-phase Amplitude');
        ylabel('Quadrature Amplitude');
    end 
end
        
        
   
    