function amplitude = hamming_window(sample, hamming_size)
amplitude = 0.54-0.46*cos(2*pi*sample/(hamming_size-1)); 