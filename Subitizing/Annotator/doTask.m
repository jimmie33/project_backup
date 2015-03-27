function doTask(name)

param = makeParam();
load('imgList');

%% initialize, creat the folder, image list and task list
dstDir = fullfile('data',name);
taskFile = fullfile(dstDir,'task.mat');
if ~exist(dstDir,'dir')
    mkdir(dstDir);
end

if exist(taskFile,'file')
    load(taskFile)
else % initialize file list
    rImgIdx = randperm(numel(imgList));
    
    % creat task list
    nTasks = ceil(numel(imgList)/param.taskBatchSize);
    mTaskList = cell(nTasks,1);
    for idxTask = 1:nTasks
        iIdx = rImgIdx([(idxTask-1)*param.taskBatchSize+1 : ...
            min(idxTask*param.taskBatchSize, numel(imgList))]); 
        mTaskList{idxTask} = struct('imgIdx',iIdx);
    end
    save(taskFile,'mTaskList','-v7.3');
end

flag = false;

if ~exist(fullfile(dstDir,'0.mat'),'file')
    % do tutorial
    load tutorialList;
    taskImgs = tutorialList;
    idxTask = 0;
    nTask = numel(mTaskList);
    save(fullfile('tmp','runData'),'name','idxTask','taskImgs','param','nTask');
    ui;
    flag = true;
else
    for idxTask = 1:numel(mTaskList)
        if exist(fullfile(dstDir,[num2str(idxTask) '.mat']),'file')
            continue;
        else
            taskImgs = imgList(mTaskList{idxTask}.imgIdx);
            nTask = numel(mTaskList);
            save(fullfile('tmp','runData'),'name','idxTask','taskImgs','param','nTask');
            ui;
            flag = true;
            break;
        end
    end
end

if ~flag
    msgbox('All tasks have been completed!');
end


