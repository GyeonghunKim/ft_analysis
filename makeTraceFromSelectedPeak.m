function [trace, subimage] = makeTraceFromSelectedPeak(c, filename, real_peak)
    file_name = strcat(c, "/", filename);
    fclose('all');
    fid_pma = fopen(file_name,'r');
    file_info =dir(file_name);

    ysize=fread(fid_pma,1,'int16'); 
    xsize=fread(fid_pma,1,'int16');

    film_length=(file_info.bytes-4)/xsize/ysize;
    subimage = zeros(sub_size*2+1,sub_size*2+1, length(real_peak),film_length);
    trace = zeros(length(real_peak), film_length);
    temp = zeros(sub_size*4+1,sub_size*4+1);
    for i=1:film_length
        one_frame = fread(fid_pma,[ysize,xsize], 'uint8');
        for j = 1:length(real_peak)
            x = real_peak(j,1);
            y = real_peak(j,2);
            subimage(:,:,j, i) = one_frame(x-sub_size:x+sub_size, y-sub_size:y+sub_size);
            temp = one_frame(x-sub_size*2:x+sub_size*2, y-sub_size*2:y+sub_size*2);
            trace(j, i) = sum(sum(subimage(:,:,j,i)))/((2*sub_size+1)^2) - sum(sum(temp))/((4*sub_size + 1)^2);
        end
    end
end