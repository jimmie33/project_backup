outDir = 'salBoxProp';

for i=0:4
%     if ~exist(fullfile('img',['imgList_' num2str(i) '.mat']),'file')
%         D = dir(fullfile('img',num2str(i),'*.jpg'));
%         imgList = {D.name};
%         save(fullfile('img',['imgList_' num2str(i)]),'imgList');
%     end
    
    load(fullfile('img',['imgList_' num2str(i)]));
    
    rectList = {};
    for kk = 1:numel(imgList)
        [~,salname,~] = fileparts(imgList{kk});
        I = imread(fullfile('img',num2str(i),imgList{kk}));
        salmap = imread(fullfile('salmap',num2str(i),[salname,'.png']));
        salmap = imresize(salmap,[size(I,1) size(I,2)]);
        rects = getBBoxOtsu(salmap);
        rects(:,3:4) = rects(:,3:4)+rects(:,1:2)-1;
        boxes = rects;
        save(fullfile(outDir,num2str(i),salname),'boxes');
    end 
%     save(fullfile('results',['rectList_' num2str(i) '_otsu']),'rectList');
end