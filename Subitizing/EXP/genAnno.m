function [annotation] = genAnno(imgList, userName)

annotation = nan(numel(imgList),1);
D = dir(fullfile('data',userName,'*.mat'));
load(fullfile('data',userName,'task.mat'));
for i = 1:numel(mTaskList)
    if ~exist(fullfile('data',userName,[num2str(i) '.mat']),'file')
        continue
    end
    load(fullfile('data',userName,[num2str(i) '.mat']));
    imgIdx = mTaskList{i}.imgIdx;
    annotation(imgIdx) = anno;
end