thresh = 0.5;
nProp = [1:2048];

D = dir('BING_result/BBoxes/*.txt');
filelist = {D.name};

gtPath = 'bboxAnnotation';
resPath = 'precomputed/BING/mat';

nInst = zeros(numel(filelist),1);
rec = zeros(numel(filelist),numel(nProp));
nProposal = zeros(numel(filelist),numel(nProp));
score = zeros(numel(filelist),numel(nProp));
ttt = 0;
for i = 1:numel(filelist)
    [~,filename,~] = fileparts(filelist{i});
    load(fullfile(gtPath,filename));
    gt = bbox;
    load(fullfile(resPath,filename(1:4),filename));
    prop = boxes;
    sc = zeros(1,numel(nProp));
    ln = min(numel(scores),numel(sc));
    sc(1:ln) = scores(1:ln);
    ttt = ttt + max(1000-size(prop,1),0);
    [TP,nP,nGT] = getRecall(gt,prop,thresh,nProp);
    nInst(i) = nGT;
    rec(i,:) = TP';
    nProposal(i,:) = nP;
    score(i,:) = sc;
end
save('recall_BING_5_scored.mat','rec','nInst','nProposal','score');
% rec = rec/nInst;
% semilogx(nProp,sum(rec)/sum(nInst));
% axis([1 1024 0 1])