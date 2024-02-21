function d = map2symbols(c,constellation_order,switch_graph)
QAM_point=[];

% Based on the constellation_order parameter QAM modulation is performed.

if constellation_order == 2 % 4-QAM
    QAM_point = [-1-1i;1-1i;-1+1i;1+1i];
    M = 2;
    MP = 2; %from literature
    
elseif constellation_order == 4   % 16-QAM
    QAM_point = [-3-3i;-3-1i;-3+3i;-3+1i;-1-3i;-1-1i;-1+3i;-1+1i;3-3i;3-1i;3+3i;3+1i;1-3i;1-1i;1+3i;1+1i];
    M=4;
    MP=10;  %from literature
    
else      % 64-QAM
    QAM_point = [-7+7i;-7 + 5i;-7 + 1i;-7 + 3i;-7-7i;-7-5i;-7-1i;-7-3i;-5+7i;-5+5i;-5+1i;-5+3i;-5-7i;-5-5i;-5-1i;-5-3i;-1+7i;-1+5i;-1+1i;-1+3i;-1-7i;-1-5i;-1-1i;-1-3i;-3+7i;-3+5i;-3+1i;-3+3i;-3-7i;-3-5i;-3-1i;-3-3i;5+7i;5+5i;5+1i;5+3i;5-7i;5-5i;5-1i;5-3i;7+7i;7+5i;7+1i;7+3i;7-7i;7-5i;7-1i;7-3i;3+7i;3+5i;3+1i;3+3i;3-7i;3-5i;3-1i;3-3i;1+7i;1+5i;1+1i;1+3i;1-7i;1-5i;1-1i;1-3i];
    M=6;
    MP=42;  %from literature
end

QAM_points=QAM_point/sqrt(MP); %Normalize the average QAM power to 1

d = [];
for index = 1:M:length(c)
    modulated_index = bi2de(c(index:index+M-1)', 'left-msb'); % binary to decimal, from Left MSB
    d = [d; QAM_points(modulated_index+1)];  %mapping
end
if(switch_graph == 1)
    scatterplot(d)
    title('QAM Modulation');
    grid on
    axis([-2 2 -2 2]);
end

end