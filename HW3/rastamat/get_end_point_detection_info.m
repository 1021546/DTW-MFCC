function [epd_y,Fs]=get_end_point_detection_info(fileName)
% get audio information
[y, Fs] = audioread(fileName);  % Fs == audioInfo.SampleRate
audioInfo = audioinfo(fileName);

% -----------------------------------------------
% variable declaration
frame_size_ms = 32;
frame_shift_ms = 16;
frame_size = frame_size_ms*0.001*audioInfo.SampleRate;
frame_shift = frame_shift_ms*0.001*audioInfo.SampleRate;
frame_num = floor((audioInfo.TotalSamples-(frame_size-frame_shift))/frame_shift); % insufficient frame size to abort
frame_autocorrelation_no = 113;

% -----------------------------------------------
% Energy
Energy=energy_contour(y,frame_num,frame_size,frame_shift);

% -----------------------------------------------
% Zero Crossing Rate
Zero_Crossing_Rate=zero_crossing_rate_contour(y,frame_num,frame_size,frame_shift);

% -----------------------------------------------
% Pitch
energy_sill=energy_threshold(Energy);

% -----------------------------------------------
% End Point Detection
izct_sill=izct_threshold(Zero_Crossing_Rate);
epd_y=end_point_detection(y,frame_num,frame_shift,audioInfo,Energy,Zero_Crossing_Rate,energy_sill,izct_sill);
