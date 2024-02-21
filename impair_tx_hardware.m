function x = impair_tx_hardware (s,clipping_threshold,switch_graph)

Filter_abs = abs(s);
Filter_angle = angle(s);
Filter_abs_1 = zeros(1,length(Filter_abs));

for i=1: length(Filter_abs)
    % Clip when Filter_abs(i)> tx_clipping_threshold = 1;
    if Filter_abs(i)>clipping_threshold  
        Filter_abs_1(i)=1;
    else
        Filter_abs_1(i)=Filter_abs(i);
    end
end

[a,b] = pol2cart(Filter_angle,Filter_abs_1'); % polar to Cartesian coordinates conversion.

x = a+b*1i;

if switch_graph == 1
    
    figure('name','Tx Hardware');
    subplot(2,1,1)
    plot(real(s),'g');
    title('Signal before Tx non-linear hardware')
    grid on
    subplot(2,1,2)
    plot(real(x),'r');
    grid on
    title('Output of Tx non-linear hardware')
    
end
end





