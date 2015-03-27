modelName = 'AllCat_CNN_SalCNN_Sal_pca250';
for i=1
    if true%~exist(fullfile('img',['imgList_' num2str(i) '.mat']),'file')
        D = dir(fullfile('img',num2str(i),'*.jpg'));
        imgList = {D.name};
        save(fullfile('img',['imgList_' num2str(i)]),'imgList');
    end
    
%     load(fullfile('img',['imgList_' num2str(i)]));
%     load(fullfile('img',['pred_' modelName '_' num2str(i)]));
%     rectList = {};
%     parfor kk = 1:numel(imgList)
%         [~,salname,~] = fileparts(imgList{kk});
%         I = imread(fullfile('img',num2str(i),imgList{kk}));
%         salmap = imread(fullfile('salmap',num2str(i),[salname,'.png']));
%         salmap = imresize(salmap,[size(I,1) size(I,2)]);
%         if pred(kk) > 0
%             rectList{kk} = getBBox(salmap,pred(kk));
%         else
%             rectList{kk} = getBBox(salmap);
%         end
%     end 
%     save(fullfile('results',['rectList_' num2str(i) '_' modelName '_test']),'rectList');
end