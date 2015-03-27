function [label] = gatherLabel(username)

label = nan(1000,1);

load(fullfile('data',username,'task'));

for i=1:numel(mTaskList)
    dataname = fullfile('data',username,[num2str(i),'.mat']);
    if exist(dataname,'file')
        load(dataname)
        label(mTaskList{i}.imgIdx) = anno;
    end
end