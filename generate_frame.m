function b = generate_frame(frame_size, switch_graph)
b = randi([0 1],frame_size,1);  % random integer bits 0 or 1 of dimension (49152, 1)
if switch_graph == 1
    figure('name','Binary pattern of Digital Source');
    stem(b);
    title('Binary pattern of Digital Source')
end