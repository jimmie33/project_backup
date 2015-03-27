data = { struct('name','ImgNet'),...
    struct('name','MIT'),...
    };

imgList={};
for dataIdx = 1:numel(data)
    srcDir = fullfile(data{dataIdx}.name,'4');
    D = dir(srcDir);
    filelist = {D.name};
    for i = 1:numel(filelist)
        name = filelist{i};
        [~,~,ext]=fileparts(name);
        if isequal(ext,'.jpg') || isequal(ext,'.png') ||...
                isequal(ext,'.jpeg') || isequal(ext,'.bmp')
            imgList{numel(imgList)+1} = fullfile(srcDir,name);
        end
    end
end
save('c4.mat','imgList');