% extract image name, url, image size, bounding boxes,
%%
D = dir('annotation/Annotation/n*');
filelist = {D.name};

% struct array

for i = numel(filelist):-1:1
    fprintf('processing folder %d: %s...', i, filelist{i})
    synsetPath = fullfile('annotation/Annotation',filelist{i});
    synsetName = filelist{i};
    if exist(fullfile('imageIdx',[synsetName, '.mat']),'file')
        fprintf('skipped\n');
        continue
    end
    % download name url mapping
    nameURL = [];
    if exist(fullfile('imgURL',[synsetName, '.txt']),'file')
        fid = fopen(fullfile('imgURL',[synsetName, '.txt']),'r');
        nameURL = textscan(fid,'%s','delimiter','\n');
        fclose(fid);
    else
        temp = urlread(['http://www.image-net.org/api/text/imagenet.synset.geturls.getmapping?wnid=' synsetName]);
        fid = fopen(fullfile('imgURL',[synsetName, '.txt']),'w');
        fprintf(fid,'%s',temp); 
        fclose(fid);
        nameURL = textscan(temp,'%s','delimiter','\n');
    end
    
    if isempty(nameURL)
        fprintf('error loading urls\n');
        continue
    end
    
    imgIdx = {};
    imgList = nameURL{1};   
    
    count = 1;
    for fileIdx = 1:numel(imgList)
        if isempty(imgList{fileIdx})
            break;
        end
        temp = textscan(imgList{fileIdx},'%s', 'delimiter', ' ');

        % read annotation
        annoFile = fullfile(synsetPath,[temp{1}{1},'.xml']);
        if ~exist(annoFile,'file')
            continue
        end
        annotation = xmlread(annoFile);
        width = str2double(annotation.item(0).getElementsByTagName('size')...
            .item(0).getElementsByTagName('width').item(0).getFirstChild.getData);
        height = str2double(annotation.item(0).getElementsByTagName('size')...
            .item(0).getElementsByTagName('height').item(0).getFirstChild.getData);
        
        nBox = annotation.item(0).getElementsByTagName('object').getLength;
        box = nan(nBox,4);
        for boxIdx = 0:(nBox-1)
            box(boxIdx+1,1) = str2double(annotation.item(0).getElementsByTagName('object')...
                .item(boxIdx).getElementsByTagName('xmin').item(0).getFirstChild.getData);
            box(boxIdx+1,2) = str2double(annotation.item(0).getElementsByTagName('object')...
                .item(boxIdx).getElementsByTagName('xmax').item(0).getFirstChild.getData);
            box(boxIdx+1,3) = str2double(annotation.item(0).getElementsByTagName('object')...
                .item(boxIdx).getElementsByTagName('ymin').item(0).getFirstChild.getData);
            box(boxIdx+1,4) = str2double(annotation.item(0).getElementsByTagName('object')...
                .item(boxIdx).getElementsByTagName('ymax').item(0).getFirstChild.getData);
        end
        
        imgIdx(count).imgName = temp{1}{1};
        imgIdx(count).imgURL = temp{1}{2};
        imgIdx(count).size = [width height];
        imgIdx(count).nBox = nBox;
        imgIdx(count).box = box;
        
        count = count+1;
    end
    
    save(fullfile('imageIdx',synsetName),'imgIdx','-v7.3');
    fprintf('done\n');
end