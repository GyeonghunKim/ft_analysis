function peak = findPeakFromPMA(c, filename, handles)
if nargin == 3
    axes(handles.axes1);
    nargin
end
%% import file
addpath(c)

file_name = strcat(c, "/",filename);

fid_pma = fopen(file_name,'r');
file_info=dir(file_name);

ysize=fread(fid_pma,1,'int16'); 
xsize=fread(fid_pma,1,'int16');
    
film_length=(file_info.bytes-4)/xsize/ysize;
    
%% find peak frame by frame

peak = zeros(2,1);
for i=1:film_length
    
    one_frame = fread(fid_pma,[ysize,xsize], 'uint8');
    imagesc(one_frame');
    peak = [peak;FastPeakFind(one_frame')];
    title(sprintf('%d',i));
    colormap(hot);
    drawnow
    if mod(i,100) == 1
        disp(sprintf('%d/%d',i,film_length));
    end
end
fclose('all');
end