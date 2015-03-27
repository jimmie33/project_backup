function [R,nProp,nInst,pred] = nRecallEvaluate(foldername,catRange)

R = [];
nInst = [];
nProp = [];
nThresh = 1:2048;
if nargout == 4
    pred = [];
end
for i = catRange
    load(fullfile('img',['imgList_' num2str(i)]));
    for fileIdx = 1:numel(imgList)
        [~,name,~] = fileparts(imgList{fileIdx});
        load(fullfile(foldername,num2str(i),name));
        if i ~= 0
            load(fullfile('gt',num2str(i),name));
            [recall nP n] = getRecall(anno,double(boxes),0.5,nThresh);
            R(end+1,:) = recall;
            nInst(end+1) = n;
            nProp(end+1,:) = nP;
        else
            R(end+1,:) = zeros(1,2048);
            nInst(end+1) = 0;
            nP = 1:2048; nP(nP>size(boxes,1)) = size(boxes,1);
            nProp(end+1,:) = nP;
        end
        
        
        if nargout == 4
            pred(end+1) = p;
        end
    end
end
