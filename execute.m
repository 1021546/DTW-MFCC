% get_end_point_detection_info('fileName',Position); for plot figure
clear;
clc;

file_repeat_count=5;
file_content_count=6;

for g = 1:file_repeat_count
    
    for n = 1:file_content_count

        fileID = fopen('result.txt','a');
        test_file_name = strcat(num2str(n-1), '_jackson_',num2str(g-1),'.wav');
        fprintf(fileID,'%s\n', test_file_name);
        fclose(fileID);

        % number_jackson_repeat.wav
        reference_file_name = strcat('../free-spoken-digit-dataset-master/recordings/', num2str(n-1), '_jackson_',num2str(g-1),'.wav');
        [epd_y, fs]=get_end_point_detection_info(reference_file_name);
        cepDpDD_test=my_mfcc(epd_y, fs);
        [feature_dimension_test, frame_number_test]=size(cepDpDD_test);
        
        clear accurancy;
        accurancy(file_repeat_count)=0;

        for m = 1:file_repeat_count
            clear average_dist;
            average_dist(file_content_count)=0;

            for f = 1:file_content_count
                target_file_name = strcat('../free-spoken-digit-dataset-master/recordings/', num2str(f-1), '_jackson_', num2str(m-1), '.wav');
                [epd_y, fs]=get_end_point_detection_info(target_file_name);
                cepDpDD=my_mfcc(epd_y, fs);
                [feature_dimension, frame_number]=size(cepDpDD);

                % 建立dtw表格
                clear dist;
                dist(frame_number_test, frame_number) = 0;
                for r = 1:frame_number_test % Reference vector
                    for t = 1:frame_number % Target vector
                        for i = 1:feature_dimension % feature_dimension_test == feature_dimension
                            dist(r, t) = dist(r,t) + (cepDpDD_test(i, r)-cepDpDD(i, t))^2;
                        end
                        dist(r, t) = sqrt(dist(r, t));
                    end
                end
                
                clear dtw_grid;
                dtw_grid(frame_number_test, frame_number) = 0;
                for i = 1:frame_number_test % Reference vector
                    for j = 1:frame_number % Target vector
                        if (i==1) && (j==1)
                            dtw_grid(i,j) = dist(i,j);
                        elseif i==1
                            dtw_grid(i,j) = dist(i,j-1);
                        elseif j==1
                            dtw_grid(i,j) = dist(i-1,j);
                        else
                            dtw_grid(i,j) = dist(i,j) + min([dtw_grid(i,j-1),dtw_grid(i-1,j-1),dtw_grid(i-1,j)]);
                        end
                    end
                end

        %         dtw_grid(frame_number_test, frame_number)

                % dtw步數
                dtw_count=0;
                temp_x=frame_number_test;
                temp_y=frame_number;
                for k = 1:(frame_number_test+frame_number)
                    if (temp_x == 1) && (temp_y == 1)
                        break;
                    elseif temp_x == 1
                        emp_y = temp_y-1;
                    elseif temp_y == 1
                        temp_x = temp_x-1;
                    else
                        [min_temp, min_temp_index] = min([dtw_grid(temp_x-1,temp_y),dtw_grid(temp_x,temp_y-1),dtw_grid(temp_x-1,temp_y-1)]);
                        if min_temp_index == 1
                            temp_x = temp_x-1;
                        elseif min_temp_index == 2
                            temp_y = temp_y-1;
                        else
                            temp_x = temp_x-1;
                            emp_y = temp_y-1;
                        end
                    end
                    dtw_count = dtw_count + 1;
                end
        %         dtw_count

                average_dist(f) = dtw_grid(frame_number_test, frame_number) / dtw_count;
        %         average_dist(f)
            end

        %     average_dist

            [min_dist, min_dist_index] = min(average_dist);

    %         min_dist_index

            if min_dist_index == n
                accurancy(m)=1;
            end
        end

%         accurancy

        fileID = fopen('result.txt','a');
        fmt = '%5d %5d %5d %5d %5d\n';
        fprintf(fileID,fmt, accurancy);
        fclose(fileID);
    end
end
