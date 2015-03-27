function [Fscore] = calcFscore(confmat)

Fscore = nan(size(confmat,1),1);

for i = 1:numel(Fscore)
    recall = confmat(i,i)/sum(confmat(i,:));
    precision = confmat(i,i)/sum(confmat(:,i));
    Fscore(i) = 2*(recall*precision)/(recall+precision);
end
