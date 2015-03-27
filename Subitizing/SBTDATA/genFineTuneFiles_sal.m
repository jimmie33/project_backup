outDir = 'overall_rectified_sal';
mkdir(outDir);

%%

load imgIdx
load testIdx

trainvalIdx = imgIdx(~testIdx);

idx = randperm(numel(trainvalIdx));
split = round(0.8*numel(idx));
trainIdx = trainvalIdx(idx(1:split));
valIdx = trainvalIdx(idx((split+1):end));

%%

f = fopen('sal_train.txt','w');
for i = 1:numel(trainIdx)
    [im cmap] = imread(fullfile('feature/salmap/SO',[trainIdx(i).name(1:end-4) '_wCtr_Optimized.png']));
    if size(cmap,2) > 0
        fprintf(1, 'fixing %s\n', trainIdx(i).name);
        newim = cell(1, size(cmap,2));
        for j=1:size(cmap,2)
          ch = cmap(:,j);
          newim{j} = ch(im+1);
        end
        im = cat(3, newim{:});
    end
    im = imresize(im,[280 280],'bilinear');
    
    im1 = im(1:256,1:256,:);
    imwrite(im1,fullfile(outDir,['aug1_' trainIdx(i).name]),'Quality', 100);
    fprintf(f,'%s %d\n', ['aug1_' trainIdx(i).name], trainIdx(i).label);
    
    im2 = im(1:256,end-255:end,:); 
    imwrite(im2,fullfile(outDir,['aug2_' trainIdx(i).name]),'Quality', 100);
    fprintf(f,'%s %d\n', ['aug2_' trainIdx(i).name], trainIdx(i).label);
    
    im3 = im(end-255:end,1:256,:); 
    imwrite(im3,fullfile(outDir,['aug3_' trainIdx(i).name]),'Quality', 100);
    fprintf(f,'%s %d\n', ['aug3_' trainIdx(i).name], trainIdx(i).label);
    
    im4 = im(end-255:end,end-255:end,:); 
    imwrite(im4,fullfile(outDir,['aug4_' trainIdx(i).name]),'Quality', 100);
    fprintf(f,'%s %d\n', ['aug4_' trainIdx(i).name], trainIdx(i).label);
    
    im = imresize(im,[256 256]);
    imwrite(im,fullfile(outDir,trainIdx(i).name),'Quality', 100);
    fprintf(f,'%s %d\n', trainIdx(i).name, trainIdx(i).label);
end
fclose(f);

%%

f = fopen('sal_val.txt','w');
for i = 1:numel(valIdx)
    [im cmap] = imread(fullfile('feature/salmap/SO',[valIdx(i).name(1:end-4) '_wCtr_Optimized.png']));
    if size(cmap,2) > 0
        fprintf(1, 'fixing %s\n', valIdx(i).name);
        newim = cell(1, size(cmap,2));
        for j=1:size(cmap,2)
          ch = cmap(:,j);
          newim{j} = ch(im+1);
        end
        im = cat(3, newim{:});
    end
    im = imresize(im,[256 256],'bilinear');
    imwrite(im,fullfile(outDir,valIdx(i).name),'Quality', 100);
    fprintf(f,'%s %d\n', valIdx(i).name, valIdx(i).label);
end
fclose(f);