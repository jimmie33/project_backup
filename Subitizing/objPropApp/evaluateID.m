function [X,Y,R,nP] = evaluateID(changeList,shrinkRatio,maxnum,rec,nInst,nProposal)

recChange = rec(changeList,:);
recNoChange = rec(~changeList,:);
nPChange = nProposal(changeList,:);
nPNoChange = nProposal(~changeList,:);

XChange = max(round([1:2048]*shrinkRatio),1);
if maxnum > 0
    XChange(XChange>maxnum) = maxnum;
end
recChange = recChange(:,XChange);
nPChange = nPChange(:,XChange);

R = [recChange;recNoChange];
nP = [nPChange;nPNoChange];
Y = sum([recChange;recNoChange])/sum(nInst);
X = mean(nP);