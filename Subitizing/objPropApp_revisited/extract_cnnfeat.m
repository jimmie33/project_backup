function F = extract_cnnfeats(imgs, params)
% EXTRACT_CNNFEATS       Extracts cnn features from images.
%
% Input: imgs - a cell array of images.
%        params - see extract_cnnfeat for setting the param values.
% 
% Output: feature matrix, F(i, :) is the cnn feature of image i.
%
% Author: Shugao Ma
% Date Last Modified: 9/28/2014

% Converts image to BGR and single and normalize the size.
n = length(imgs);
imgs2 = zeros(params.height, params.width, 3, n, 'single');
for i = 1:n
    im = imgs{i};
    if size(im,3)<3
        keyboard
    end
    imgs2(:, :, :, i) = imresize(im(:, :, [3 2 1]),...
        [params.height, params.width], 'bilinear', 'antialiasing', false);
    imgs2(:, :, :, i) = imgs2(:, :, :, i) ...
        - params.image_mean(1:params.height, 1:params.width, :);
end

% Extracts cnn features from each stsegment.
num_batches = ceil(n / params.batch_size);
F = cell(num_batches, 1);

for b = 1 : num_batches
    fprintf('batch %d\n',b);
    batch_start = (b - 1) * params.batch_size + 1;
    batch_end = min(n, batch_start + params.batch_size - 1); 
    ims = zeros(params.height, params.width, 3, params.batch_size, 'single');
    
    % swaps dims 1 and 2 to make width the fastest dimension (for caffe).
    for i = batch_start : batch_end 
        ims(:, :, :, i - batch_start + 1) = permute(imgs2(:, :, :, i), [2 1 3]);
    end
    f = caffe('forward', {ims});
    f = f{1};
    f = f(:);
    feat_dim = length(f) / params.batch_size;
    f = reshape(f, [feat_dim params.batch_size])';
    F{b} = f(1 : min(batch_end - batch_start + 1, params.batch_size), :);
end
F = cell2mat(F);
end

