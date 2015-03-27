function im = grey2rgb(im)
if ndims(im == 2)
    im2 = im;
    im = zeros(size(im2, 1), size(im2, 2), 3, 'uint8');
    for k = 1:3
        im(:, :, k) = im2;
    end
end
end