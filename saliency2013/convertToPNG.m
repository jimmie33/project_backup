function convertToPNG()

configData();
configModel();

for dataIdx = 1:numel(data)
    for modelIdx = 1:numel(model)
        salDir = fullfile('./salmaps',data{dataIdx}.name, ['output_', model{modelIdx}.name]);
        if ~exist(salDir,'dir')
            fprintf('%s not found.\n',saldir);
            continue
        end
        
%         D = dir(fullfile(salDir,'*.png'));
%         filelist = {D.name};
%         if numel(filelist) > 0
%             continue
%         end
        
        D = dir(fullfile(salDir,'*.jp.png'));
        filelist = {D.name};
%         D = dir(fullfile(salDir,'*.tif'));
%         filelist = {D.name};
%         D = dir(fullfile(salDir,'*.jpeg'));
%         filelist = [filelist, {D.name}];
%         D = dir(fullfile(salDir,'*.jpg'));
%         filelist = [filelist, {D.name}];
%         D = dir(fullfile(salDir,'*.bmp'));
%         filelist = [filelist, {D.name}];
        for i = 1:numel(filelist)
            movefile(fullfile(salDir, filelist{i}),fullfile(salDir, [filelist{i}(1:end-length('.jp.png')), '.png']));
%             salmap = imread(fullfile(salDir, filelist{i}));
%             [~,n,~] = fileparts(filelist{i});
%             imwrite(salmap,fullfile(salDir, [n(1:end-length('.')), '.png']));
        end
    end
end