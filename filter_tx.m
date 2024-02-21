function s = filter_tx (z, sampling_factor, switch_graph, switch_off)

%if switch_off == 0
    
    % Generate a square-root, raised cosine filter using the rcosdesign function.
    % rrcFilter = rcosdesign(rolloff, span, oversampling_factor, shape);
    Low_Pass_Filter=rcosdesign(0.25,8,20, 'sqrt');  % Raised cosine FIR filter design
    
    
    fvtool(Low_Pass_Filter,'Analysis','impulse','color','[1 0.4 0.6]') % filter Visualization
    
    z_oversampled=[];
    
    z_oversampled=upsample(z,sampling_factor); % Upsample input signal by inserting N-1 zeros between input samples.
    
    Filter_out_1 = conv(Low_Pass_Filter,z_oversampled); % low pass filtering
    
    [m,n]=size(Filter_out_1); % get the filter size of dim mxn = (1x563360)
    
    Filter_out_2=Filter_out_1/sqrt(sum(abs(Filter_out_1.^2))/length(Filter_out_1));  %normalizes the values in Filter_out_1 by dividing them by the square root of the average power of the signal. 
                                                                                     %This operation normalizes the amplitude of the signal.
    
    Filter_out= Filter_out_2((length(Low_Pass_Filter)+1)/2:end-(length(Low_Pass_Filter)-1)/2); %subtraction of sides
                                                                                               %performs cropping on the Filter_out_2 vector to remove the unwanted edges caused by the convolution operation. 
                                                                                               %The cropped section is defined by taking the middle portion of Filter_out_2 using the length of the Low_Pass_Filter.
    
    [m,n]=size(Filter_out); % dim mxn = 1x563200
    
    s=reshape(Filter_out,n,1); % reshape filter_out into 563200x1
    
    if switch_graph==1
        [H W] = freqz(Filter_out,1,1024); % Frequency response of digital filter
        figure('name','Tx Filter in normalize frequency domain');
        plot(W/pi,20*log10(abs(H)));
        xlabel('\omega/pi');
        ylabel('H in DB');
        title('Tx Filter in normalize frequency domain');
       
        figure('name','Tx filter output');
        subplot(2,1,1)
        
        plot(real(s),'g');
        ylabel('output of Tx filter(real)')
        title('Tx filter output');
        grid on
        hold on
        
        %figure('name','Output of Tx filter(imaginary)')
        subplot(2,1,2)
        plot(imag(s),'r');
        grid on
        hold off
        ylabel('Output of Tx filter(imaginary)')
    end
%else
 %   s=z;
end
