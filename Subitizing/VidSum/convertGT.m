rootDir = 'egocentric_GT';

subj = {'P01','P02','P03','P04'};

for i = 1:numel(subj)
    outDir = fullfile('GT',subj{i});
    mkdir(outDir);
    
    D = dir(fullfile(rootDir,subj{i},'pos_gtimages','*.mat'));
    filelist = {D.name};
    
    for kk = 1:numel(filelist)
        load(fullfile(rootDir,subj{i},'pos_gtimages',filelist{kk}));
        name = filelist{kk}(1:end-8);
        img = GT.gt_im;
        imwrite(img,fullfile(outDir,[name '.png']));
    end
end