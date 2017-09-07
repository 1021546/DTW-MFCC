function energy_sill=energy_threshold(Energy)
% energyªùÂe
energy_count = 10;
energy_sill = 0;
energy_mean = 0;
energy_sigma = 0; % Standard Deviation

for n = 1:energy_count
	energy_mean = energy_mean + Energy(n);
end
energy_mean = energy_mean/energy_count;
for n = 1:energy_count
	energy_sigma = energy_sigma + (Energy(n)-energy_mean)^2;
end
energy_sigma = sqrt(energy_sigma/energy_count);
energy_sill = energy_mean + 4*energy_sigma;