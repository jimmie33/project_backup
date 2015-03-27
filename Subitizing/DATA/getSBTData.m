datasets = {...
    struct('name','COCO','ext','.jpg'),...
    struct('name','ImgNet','ext','.jpg'),...
    struct('name','SUN','ext','.jpg')...
    };

for dataIdx = 1:numel(datasets)
    for i = 0:4
        srcDir = fullfile(datasets{dataIdx}.name,num2str(i));
        if ~exist(srcDir,'dir')
            continue
        end
        saveDir = fullfile('SBT',num2str(i));
        if ~exist(saveDir)
            mkdir(saveDir)
        end
        D = dir(fullfile(srcDir,['*', datasets{dataIdx}.ext]));
        filelist = {D.name};
        for idx = 1:numel(filelist)
            copyfile(fullfile(srcDir,filelist{idx}),...
                fullfile(saveDir,[datasets{dataIdx}.name '_' filelist{idx}]));
        end
    end
end