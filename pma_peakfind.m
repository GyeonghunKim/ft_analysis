clear all;

%% import file

c = "/media/ghkim/HDD1/smb/fret-tracking/9_06_analysis";
filename = "hel2.pma";
peak = findPeakFromPMA(c, filename);

stacked_peak = stackPeak(peak);

%% normalize stacked peak
sub_size = 10;
norm_stacked_image = normalizeStackImage(stacked_peak, sub_size);


% p = FastPeakFind(norm_stacked_image);
p = findLocalMaximaWithMask(norm_stacked_image);

%% peak select

real_peak = selectPeakFromHist(norm_stacked_image, p, sub_size);
hold off;
imagesc(norm_stacked_image);
hold on;

%% make trace

fclose('all');
[trace, subimage] = makeTraceFromSelectedPeak(c, filename, real_peak, 4);
