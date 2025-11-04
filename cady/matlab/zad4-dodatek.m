function bh_err(img, approx)
    err = 0;
    for color=[1,2,3]
        if !any(any(approx(:,:,color)))
            continue;
        end
        err += sum(sum((img(:,:,color) - approx(:,:,color)).^2));
    end
    err = sum(err,3);
    err / (size(img, 1) * size(img, 2))
end
