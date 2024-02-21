function c_hat= detect_symbols (d_bar,constellation_order,switch_graph)
decision_point=[];
if constellation_order == 2
    M = 2;
    MP = 2;
    decision_point = [-1-1i;1-1i;-1+1i;1+1i];
elseif  constellation_order == 4
    M = 4;
    MP = 10;
    decision_point = [-3-3i;-3-1i;-3+3i;-3+1i;-1-3i;-1-1i;-1+3i;-1+1i;3-3i;3-1i;3+3i;3+1i;1-3i;1-1i;1+3i;1+1i];
else
    M = 6;
    MP = 42;
    decision_point = [-7+7i;-7+5i;-7+1i;-7+3i;-7-7i;-7-5i;-7-1i;-7-3i;-5+7i;-5+5i;-5+1i;-5+3i;-5-7i;-5-5i;-5-1i;-5-3i;-1+7i;-1+5i;-1+1i;-1+3i;-1-7i;-1-5i;-1-1i;-1-3i;-3+7i;-3+5i;-3+1i;-3+3i;-3-7i;-3-5i;-3-1i;-3-3i;5+7i;5+5i;5+1i;5+3i;5-7i;5-5i;5-1i;5-3i;7+7i;7+5i;7+1i;7+3i;7-7i;7-5i;7-1i;7-3i;3+7i;3+5i;3+1i;3+3i;3-7i;3-5i;3-1i;3-3i;1+7i;1+5i;1+1i;1+3i;1-7i;1-5i;1-1i;1-3i];
end

decision_points = decision_point/sqrt(MP);
c_hat = [];

D = length(d_bar);
D_1 = length(decision_points);

for j = 1:D
    for index = 1:D_1
        % min error point is taken
        error(index) = d_bar(j) - decision_points(index);
    end
    final_decision(j) = find(error==min(error(:)))-1;
    c_hat = [c_hat; de2bi(final_decision(j) ,M, 'left-msb')'];     %  Conversion of decimal to binary.
end

if switch_graph == 1
    figure = scatterplot(d_bar,1,0,'c.');
    hold on
    scatterplot(decision_points,1,0,'k*',figure)
    title('Demodulation')
    grid
end
end


