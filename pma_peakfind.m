clear all;

%% import file

c = "/media/ghkim/HDD1/smb/fret-tracking/9_06_analysis";

peak = findPeakFromPMA(c, "hel2.pma");

stacked_peak = stackPeak(peak);

%% normalize stacked peak
sub_size = 10;
norm_stacked_image = zeros(size(stacked_peak));
for x = sub_size+1:511-sub_size
    for y = sub_size+1:511-sub_size
        temp = sum(sum(stacked_peak(x-sub_size:x+sub_size, y-sub_size:y+sub_size)));
        norm_stacked_image(x,y) = stacked_peak(x,y)/(temp/((2*sub_size +1)*(2*sub_size +1)));
    end
end


% p = FastPeakFind(norm_stacked_image);
mask = ones(3); mask(5) = 0;
masked_stacked_image = ordfilt2(norm_stacked_image, 8, mask);
peaks = norm_stacked_image > masked_stacked_image;
k = 1;
p = zeros(1);
for i = 1:length(masked_stacked_image)
    for j = 1:length(masked_stacked_image)
        if peaks(i,  j) == 1
            p(2*k-1) = j;
            p(2*k) = i;
            k = k + 1;
        end
    end
end

%% peak select

I = zeros(1, 1);
k = 1;
for i = 1:length(p)/2
    x = p(2*i-1);
    y = p(2*i);
    if (x>sub_size && x < 512 - sub_size)&&(y>sub_size && y < 512 - sub_size)
        I(k) = norm_stacked_image(x,y);
        k = k + 1;
    end    
end

[his, bin] = hist(I, floor(length(p)/200));
histf = fit(bin', his', 'exp1');


thre_inper = 1.5;
% NN = 2;
% thre = thre_inper * (histf.b1+histf.c1*NN);
tau = -1/histf.b;
thre = thre_inper * tau;

sub_size = 3;
sub_image = zeros(2*sub_size + 1);
real_peak = zeros(1,2);
k = 1;
for i = 1:length(p)/2
    x = p(2*i-1);
    y = p(2*i);
    if (x>sub_size && x < 512 - sub_size)&&(y>sub_size && y < 512 - sub_size)
        sub_image = norm_stacked_image(x-sub_size:x+sub_size, y-sub_size:y+sub_size);
        if sum(sum(sub_image)) > thre
            if k == 1
                real_peak(1) = x;
                real_peak(2) = y;
                k = k + 1;
            else
                real_peak(k, 1) = x;
                real_peak(k, 2) = y;
                k = k + 1;
            end
        end
    end
    
end
hold off;
imagesc(norm_stacked_image);
hold on;

% scatter(real_peak(:,1), real_peak(:,2), 'ro');

%% make trace

fclose('all');
file_name1 = file_name;
fid_pma1 = fopen(file_name1,'r');
file_info1=dir(file_name1);

ysize=fread(fid_pma1,1,'int16'); 
xsize=fread(fid_pma1,1,'int16');
    
film_length=(file_info1.bytes-4)/xsize/ysize;
subimage = zeros(sub_size*2+1,sub_size*2+1, length(real_peak),film_length);
trace = zeros(length(real_peak), film_length);
temp = zeros(sub_size*4+1,sub_size*4+1);
for i=1:film_length
    one_frame = fread(fid_pma1,[ysize,xsize], 'uint8');
    for j = 1:length(real_peak)
        x = real_peak(j,1);
        y = real_peak(j,2);
        subimage(:,:,j, i) = one_frame(x-sub_size:x+sub_size, y-sub_size:y+sub_size);
        temp = one_frame(x-sub_size*2:x+sub_size*2, y-sub_size*2:y+sub_size*2);
        trace(j, i) = sum(sum(subimage(:,:,j,i)))/((2*sub_size+1)^2) - sum(sum(temp))/((4*sub_size + 1)^2);
    end
end
