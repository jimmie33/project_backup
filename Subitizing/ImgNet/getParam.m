function param = getParam(outputDir,center,pivot_center,randomCrop)

param.outputDir = outputDir;
param.center = center; % bbox kmeans center
param.pivot_center = pivot_center; % bbox center kmeans center
param.pivot_idx_tab = getIdxTab(size(pivot_center,2));
param.n_pivot_pair = max(param.pivot_idx_tab(:));
param.randomCrop = randomCrop; % random sampling window
param.chunkSize = 100;
param.imageSize = [224 224];%224
param.imageMean = [103.939 116.779 123.68]; % BGR

function idx_tab = getIdxTab(N)

idx_tab = zeros(N);
count = 1;
for i = 1:N
    for j = 1:N
        if j>=i
            idx_tab(i,j) = count;
            count = count+1;
        else
            idx_tab(i,j) = idx_tab(j,i);
        end
    end
end