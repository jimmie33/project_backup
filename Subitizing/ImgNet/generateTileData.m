function generateTileData(bigfilelist,range,num)

srcdir = 'ILSVRC2012_img/train';
dstdir = 'ILSVRC2012_img/tileImgVal';
if ~exist(dstdir,'dir')
    mkdir(dstdir)
end

D = dir(fullfile(srcdir,'n*'));
catlist = {D.name};
% if exist('bigfilelist.mat','file')
%     load('bigfilelist')
% else
%     bigfilelist = getBigFileList(srcdir,catlist);
% end
for i = 1:numel(catlist)
    bigfilelist{i} = bigfilelist{i}(ceil(range/1300*numel(bigfilelist{i})));
end

parfor catid = 1:numel(catlist)
    fprintf('%s...',catlist{catid});
    indir = fullfile(srcdir,catlist{catid});
    outdir = fullfile(dstdir,catlist{catid});
    if ~exist(outdir,'dir')
        mkdir(outdir);
    end
    imglist = bigfilelist{catid};
    count = 0;
    fid = fopen(fullfile(outdir,'tileImgList.txt'),'w');
    while count < num
        tmplist = imglist(randsample(numel(imglist),3));
        for kk = 1:numel(tmplist)
            tmplist{kk} = fullfile(indir,tmplist{kk});
        end
        randcat = randi(1000);
        noise = bigfilelist{randcat}{randi(numel(bigfilelist{randcat}))};
        tmplist = [tmplist fullfile(srcdir,catlist{randcat},noise)];
        tmplist = tmplist(randperm(numel(tmplist)));
        try
            I = getImList(tmplist);
        catch e
            fprintf('fail to open file\n');
            continue
        end
        tileim = getTileIm(I);
        imname = fullfile(outdir,sprintf('%05d.JPEG',count));
        imwrite(tileim,imname)
        fprintf(fid,'%s %d\n',imname,catid-1);
        count = count+1;
    end
    fclose(fid);
    fprintf('\n');
end


function I = getIm(name)
[I cmap] = imread(name);
if size(cmap,2) > 0
    newim = cell(1, size(cmap,2));
    for j=1:size(cmap,2)
        ch = cmap(:,j);
        newim{j} = ch(I+1);
    end
    I = cat(3, newim{:});
end
if size(I,3) == 1
    I = repmat(I,[1 1 3]);
end

function I = getImList(name)
for i = 1:numel(name)
    I{i} = getIm(name{i});
end

function bigfilelist = getBigFileList(srcdir, catlist)
for i = 1:numel(catlist)
    fprintf('%s\n',catlist{i});
    D = dir(fullfile(srcdir,catlist{i},'*.JPEG'));
    tmp = {D.name};
    bigfilelist{i} = tmp;
end
save('bigfilelist','bigfilelist','-v7.3')

function tileim = getTileIm(I)
tileim = zeros(224,224,3,'uint8');
for i = 1:4
    im = prepareIm(I{i});
    rn = floor((i-1)/2);
    cn = mod((i-1),2);
    tileim((rn*112+1):(rn*112+112),(cn*112+1):(cn*112+112),:) = im;
end

function I = prepareIm(I)
sz = size(I);
sz = sz(1:2);
dim = min(sz);
r = floor((sz(1)-dim)/2 + 1);
c = floor((sz(2)-dim)/2 + 1);
I = I(r:(r+dim-1),c:(c+dim-1),:);
I = imresize(I,[112 112]);


