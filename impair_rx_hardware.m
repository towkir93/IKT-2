function s_tilde = impair_rx_hardware (y,clipping_threshold,switch_graph)

Filter_in_abs = abs(y);
Filter_in_angle = angle(y);
Filter_in_abs_1 = zeros(1,length(Filter_in_abs));


for i = 1: length(Filter_in_abs)
    
    % Clip when Filter_in_abs(i)> rx_clipping_threshold = 1;
    if Filter_in_abs(i) > clipping_threshold
        Filter_in_abs_1(i)= 1;
    else
        Filter_in_abs_1(i)=Filter_in_abs(i);
    end
end

[a,b] = pol2cart(Filter_in_angle,Filter_in_abs_1'); % polar to Cartesian coordinates conversion.

s_tilde = a+b*1i;


if switch_graph == 1
    figure('name','Rx Hardware');
    subplot(2,1,1)
    plot(real(y),'g');
    title('Recieved signal')
    grid on
    subplot(2,1,2)
    plot(real(s_tilde),'r');
    grid on
    title('Output of Rx non-linear hardware')
end
