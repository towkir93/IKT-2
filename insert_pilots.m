function D = insert_pilots (d,fft_size,N_blocks, switch_graph, pilot_symbols) % length(pilot_symbols)= 1024*1

D_2 = reshape(d,fft_size,N_blocks); %(21504, 1024, 7 ) # 1024*7

D = [pilot_symbols,D_2]; %D = 1024*8 ; Pilot symbols of 1 coloumn is added.

%if switch_graph == 1 
 %   figure('name','Insertion of Pilot');
  %  plot(D,'b*');
end