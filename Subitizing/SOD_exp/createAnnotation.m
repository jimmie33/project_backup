function createAnnotation(catName,nInst)

global quitProgram;
quitProgram = false;

src = fullfile('img',catName);
D = dir(fullfile(src,'*.jpg'));
filelist = {D.name};
dst = fullfile('gt',catName);
if ~exist(dst,'dir')
    mkdir(dst);
end

figure(1);
set(1,'KeyPressFcn', @handleKey); 

for i = 1:numel(filelist)
    if exist(fullfile('gt',catName,[filelist{i}(1:end-4) '.mat']),'file')
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
    save(fullfile('gt',catName,[filelist{i}(1:end-4) '.mat']),'anno')
end


