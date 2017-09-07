function [epd_y]=end_point_detection(y,frame_num,frame_shift,audioInfo,Energy,Zero_Crossing_Rate,energy_sill,izct_sill)

%ITL= Lower threshold of energy. ITU= Upper threshold of energy. IZCT= Zero-crossing threshold
% 依序以itl、itu、izct為標準，找出起始與結束端點
epd_start = 1;
epd_end = frame_num;
itl = energy_sill;
itu = 5*itl;

% 以高音量(ITU)為標準，決定起始端點：將端點前後延伸到低音量(ITL)處

% itu
for i = 1:frame_num
	if Energy(i) >= itu
		epd_start = i; % epd_start is initialized to 1
		break;
	end
end
for i = 1:frame_num
	if Energy(frame_num+1-i) >= itu
		epd_end = frame_num+1-i; % epd_end is initialized to frame_num
		break;
	end
end
% itl
for i = 1:epd_start-1
	if Energy(epd_start-i) <= itl
		epd_start = epd_start-i;
		break;
    end
    if i==epd_start-1
		epd_start = 0; % avoid " Energy(epd_start-i) <= itl " invalid
	end
end
for i = 1:frame_num-epd_end
	if Energy(epd_end+i) <= itl
		epd_end = epd_end+i;
		break;
    end
    if i==frame_num-epd_end
		epd_end = frame_num; % avoid " Energy(epd_end+i) <= itl " invalid
	end
end
% izct
for i = 1:epd_start-1
	if Zero_Crossing_Rate(epd_start-i) <= izct_sill
		epd_start = epd_start-i;
		break;
    end
    if i==epd_start-1
		epd_start = 0; % avoid " Zero_Crossing_Rate(epd_start-i) <= izct_sill " invalid
	end
end
for i = 1:frame_num-epd_end
	if Zero_Crossing_Rate(epd_end+i) <= izct_sill
		epd_end = epd_end+i;
		break;
    end
    if i==frame_num-epd_end
		epd_end = frame_num; % avoid " Zero_Crossing_Rate(epd_end+i) <= izct_sill " invalid
	end
end

epd_start_point = epd_start*frame_shift;
epd_end_point = epd_end*frame_shift;
epd_y = y(epd_start_point:epd_end_point);


% subplot(12, 1, position);
% x = (1:length(y))/(audioInfo.TotalSamples/frame_num);
% 
% plot(x, y); % x and y must have same length
% axis([0, frame_num, -inf, inf]); % 限制顯示x軸0到frame_num的範圍
% title('End Point Detection'); 
% line([epd_start epd_start], [min(y) max(y)], 'color', 'r');
% line([epd_end epd_end], [min(y) max(y)], 'color', 'g');