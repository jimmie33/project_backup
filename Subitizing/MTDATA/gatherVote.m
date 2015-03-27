function newvote=gatherVote(imgIdx, voteidx, vote, anno)

if size(vote,1)~=numel(imgIdx)
    newvote = zeros(numel(imgIdx),5);
    newvote(1:size(vote),:) = vote;
else
    newvote = vote;
end

for i = 1:5
    idxmask = anno == (i-1);
    newvote(voteidx(idxmask),i) = newvote(voteidx(idxmask),i)+1;
end

