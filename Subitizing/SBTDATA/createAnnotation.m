function createAnnotation(imgIdx,nInst)

global quitProgram;
quitProgram = false;

src = 'overall';
dst = 'bboxAnno';
if ~exist(dst,'dir')
    mkdir(dst);
end

label = [imgIdx.label];
filelist = {imgIdx.name};
filelist = filelist(label == nInst);

figure(1);
set(1,'KeyPressFcn', @handleKey); 

for i = 1:numel(filelist)
    if exist(fullfile(dst,[filelist{i}(1:end-4) '.mat']),'file')
        continue
    end
    anno = [];
    img = imread(fullfile(src,filelist{i}));
    imshow(img);
    if nargin == 1
        nInst = input('nInst: ');
    end
    for kk = 1:nInst
        h = imrect(gca);
        addNewPositionCallback(h,@(p) title(mat2str(p,3)));
        fcn = makeConstrainToRectFcn('imrect',get(gca,'XLim'),get(gca,'YLim'));
        setPositionConstraintFcn(h,fcn);
        pause
        if quitProgram
            return
        end
        rect = getPosition(h);
        anno(end+1,:) = rect;
        rectangle('Position',anno(end,:),'edgeColor',[0 1 0]);
    end
    anno(:,3) = anno(:,1)+anno(:,3)-1;
    anno(:,4) = anno(:,2)+anno(:,4)-1;
    save(fullfile(dst,[filelist{i}(1:end-4) '.mat']),'anno')
end


