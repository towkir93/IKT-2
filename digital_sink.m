function BER= digital_sink(b, b_hat)

error = abs(b - b_hat);   % error 
BER = sum(error)/length(b);  % Calculate the corresponding Bit Error Rate (BER).
% error_1 = abs(b - b_hat);   % error in terms of the uncoded
% BER_1 = sum(error_1)/length(b);  % Calculate the corresponding Bit Error Rate (BER).

% error_2 = abs(c - c_hat);  % error in terms of the coded
% BER_2 = sum(error_2)/length(c); % Calculate the corresponding Bit Error Rate (BER).

end
%function [BER_1, BER_2]= digital_sink(b, b_hat,c,c_hat)
