src = fullfile('train2014');

D = dir(fullfile(src,'*.jpg'));
filelist = {D.name};

for i = 0:4
    mkdir(fullfile('COCO',num2str(i)));
end

for imgIdx = 1:numel(filelist)
    fname = filelist{imgIdx};
    imID = sscanf(fname,'COCO_train2014_%d.jpg');
    instCount = imgInstCount(imID);
    switch instCount
        case 0
            copyfile(fullfile(src,fname),fullfile('COCO/0',fname));
        case 1
            copyfile(fullfile(src,fname),fullfile('COCO/1',fname));
        case 2
            copyfile(fullfile(src,fname),fullfile('COCO/2',fname));
        case 3
            copyfile(fullfile(src,fname),fullfile('COCO/3',fname));
        otherwise
            copyfile(fullfile(src,fname),fullfile('COCO/4',fname));
    end     
end