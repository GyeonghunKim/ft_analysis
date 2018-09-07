function stacked_peak = stackPeak(peak)
    stacked_peak = zeros(512);
    for i = 3:length(peak)/2
        stacked_peak(peak(2*i-1), peak(2*i)) = stacked_peak(peak(2*i-1), peak(2*i)) + 1;
    end
end