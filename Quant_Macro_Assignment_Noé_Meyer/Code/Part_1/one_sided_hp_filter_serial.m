function [trend, cycle] = one_sided_hp_filter_serial(y, lambda)

    [T, N] = size(y);
    trend = zeros(T, N);
    
    for t = 3:T
        y_sub = y(1:t, :);
        
        try
            x_trend = hpfilter(y_sub, lambda);
        catch
            x_trend = local_hpfilter_core(y_sub, lambda);
        end
        
        trend(t, :) = x_trend(end, :);
    end
    
    trend(1,:) = y(1,:);
    trend(2,:) = y(2,:);
    
    cycle = y - trend;
end

function tau = local_hpfilter_core(y, lambda)
    n = size(y,1);
    D = spdiags(repmat([1 -2 1], n, 1), 0:2, n-2, n);
    I = speye(n);
    tau = (I + lambda * (D' * D)) \ y;
end