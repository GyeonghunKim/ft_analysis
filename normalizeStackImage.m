function norm_stacked_image = normalizeStackImage(stacked_peak, sub_size)
    norm_stacked_image = zeros(size(stacked_peak));
    for x = sub_size+1:511-sub_size
        for y = sub_size+1:511-sub_size
            temp = sum(sum(stacked_peak(x-sub_size:x+sub_size, y-sub_size:y+sub_size)));
            norm_stacked_image(x,y) = stacked_peak(x,y)/(temp/((2*sub_size +1)*(2*sub_size +1)));
        end
    end
end