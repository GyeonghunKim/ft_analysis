function p = findLocalMaximaWithMask(norm_stacked_image)
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
end