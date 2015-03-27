function [X,Y,R,nP,scoreThresh] = evaluateScoreThresh(score,rec,nProposal,nInst)

maxScore = max(score(:));
minScore = min(score(:));
step = (maxScore-minScore)/100;
scoreThresh = [maxScore:-step:minScore,minScore];

R = zeros(size(score,1),numel(scoreThresh));
nP = zeros(size(score,1),numel(scoreThresh));

for i = 1:size(R,1)
    for j = 1:size(R,2)
        idx = find(score(i,:) < scoreThresh(j),1);
        if isempty(idx)
            idx = size(rec,2)+1;
        end
        if idx > 1
            R(i,j) = rec(i,idx-1);
            nP(i,j) = nProposal(i,idx-1);
        end 
    end
end


Y = sum(R)/sum(nInst);
X = sum(nP)/size(rec,1);