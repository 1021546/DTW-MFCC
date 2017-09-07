function zero_crossing_rate=zero_crossing_rate_contour(y,frame_num,frame_size,frame_shift)
zero_crossing_rate(frame_num) = 0;
for i = 1:frame_num % i => frame number
	temp = (i-1)*frame_shift;
	for j = 1:frame_size % j => sample point
		if temp+j-1 == 0
			continue;
		end
		zero_crossing_rate(i) = zero_crossing_rate(i) + abs(sign(y(temp+j))-sign(y(temp+j-1)))*hamming_window(i-(temp+j), frame_size);
	end
	zero_crossing_rate(i) = zero_crossing_rate(i) / frame_size;
end
