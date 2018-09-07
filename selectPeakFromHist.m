function real_peak = selectPeakFromHist(norm_stacked_image, p, sub_size)
    sub_rad = 3;
    thre_inper = 1.5;
    
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

    sub_rad = 3;
    sub_image = zeros(2*sub_rad + 1);
    real_peak = zeros(1,2);
    k = 1;
    for i = 1:length(p)/2
        x = p(2*i-1);
        y = p(2*i);
        if (x>sub_rad && x < 512 - sub_rad)&&(y>sub_rad && y < 512 - sub_rad)
            sub_image = norm_stacked_image(x-sub_rad:x+sub_rad, y-sub_rad:y+sub_rad);
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
end