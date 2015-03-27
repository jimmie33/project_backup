D = dir(fullfile('imageIdx','*.mat'));

filelist = {D.name};

processedSynsetId = [];
imgIdxDownload = {{},{},{},{}};%1 2 3 4
if exist('imgIdxDownload.mat','file')
    load('imgIdxDownload.mat');
end 

for i=1:numel(filelist)
    fprintf('processing %s...', filelist{i});
    if any(processedSynsetId == str2double(filelist{i}(2:end-4)))
        fprintf('skipped\n');
        continue
    end
    load(fullfile('imageIdx',filelist{i}));
    if numel(imgIdx) == 0
        fprintf('no index found\n');
        continue;
    end
    nBox = cell2mat({imgIdx.nBox});
    for k=1:4
        if k==1
            idx = find(nBox == 1);
        elseif k<4
            idx = find(nBox == k);
        else
            idx = find(nBox >= k);
        end
        if numel(idx) == 0
            continue
        end
        if numel(idx) > 2
            idx = randsample(idx,2);
        end
        for tt = 1:numel(idx)
            imgIdxDownload{k}{numel(imgIdxDownload{k})+1} = imgIdx(idx(tt));
        end
    end
    processedSynsetId(numel(processedSynsetId)+1) = str2double(filelist{i}(2:end-4));
    fprintf('\n');
end

save('imgIdxDownload','imgIdxDownload','processedSynsetId','-v7.3');