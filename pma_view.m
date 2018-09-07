clear all;

c = "/media/ghkim/HDD1/smb/fret-tracking/9_06_analysis";
addpath(c)
file_name = strcat(c, "/","hel3.pma");

fid_pma = fopen(file_name,'r');
file_info=dir(file_name);

ysize=fread(fid_pma,1,'int16'); 
xsize=fread(fid_pma,1,'int16');
    
film_length=(file_info.bytes-4)/xsize/ysize;


for i=1:film_length
    
    one_frame = fread(fid_pma,[ysize,xsize], 'uint8');
    
    %    disp(sprintf('%d %d',max(max(one_frame)),min(min(one_frame))));
    %     if mod(i,2)==0
    figure(1)
    %       subplot(2,1,1);
    image(one_frame')
    title(sprintf('%d',i));
    colormap(hot);
    
    drawnow
    %         image_green = image_green + one_frame;
%     else
%         image_red = image_red + one_frame;
%         
%     end
    %    F(i) = im2frame(one_frame,X);
    if mod(i,100) == 1
        disp(sprintf('%d/%d',i,film_length));
    end
end

return

image_green = image_green * 2/film_length;
image_red = image_red * 2/film_length;

figure(2)
image(image_green');

figure(3)
image(image_red');

