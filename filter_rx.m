
function z_tilde = filter_rx (s_tilde,downsampling_factor,switch_graph,switch_off)

%if switch_off == 0
    
    % Generate a square-root, raised cosine filter using the rcosdesign function..
    Low_Pass_Filter=rcosdesign(0.25,8,20, 'sqrt');  % Design of Raised cosine FIR filter.
    
    Filter_out = conv(Low_Pass_Filter, s_tilde);
    Filter_out=Filter_out/sqrt(sum(abs(Filter_out.^2))/length(Filter_out));
    z_tilde = Filter_out((length(Low_Pass_Filter)+1)/2:downsampling_factor:end-(length(Low_Pass_Filter)-1)/2);%take valus from 20 to 20
    
    if switch_graph == 1
        figure('name','Rx filter output')
        subplot(2,1,1)
        plot(real(Filter_out),'g');
        xlabel('Bits sequence');
        ylabel('Amplitude');
        title('Output of the Rx filter (Real)')
        grid on
        subplot(2,1,2)
        plot(imag(Filter_out),'r');
        grid on
        xlabel('Bits sequence');
        ylabel('Amplitude');
        title('Output of the Rx filter (Imaginary)')
    end
%else
%    z_tilde=s_tilde;
%end
end