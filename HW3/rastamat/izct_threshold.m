function izct_sill=izct_threshold(Zero_Crossing_Rate)
% izctªùÂe
izct_count = 10;
izct_sill = 0;
izct_mean = 0;
izct_sigma = 0; % Standard Deviation¡@¡@

for n = 1:izct_count
	izct_mean = izct_mean + Zero_Crossing_Rate(n);
end
izct_mean = izct_mean/izct_count;
for n = 1:izct_count
	izct_sigma = izct_sigma + (Zero_Crossing_Rate(n)-izct_mean)^2;
end
izct_sigma = sqrt(izct_sigma/izct_count);
izct_sill = izct_mean + 4*izct_sigma;