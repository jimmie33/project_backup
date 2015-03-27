function newvote=gatherVoteFromCSV(imgIdx, vote, filename)

nCol = 5; % 5 images per task
prefix = 'https://s3.amazonaws.com/testimgjmzhang/task1/masterImage/';

fid = fopen(filename);
C = textscan(fid,'%s%s%s%s%s%d%d%d%d%d','Delimiter',',');

fclose(fid);

nPrefix = numel(prefix);
imgName = {imgIdx.imgName};

%%


if size(vote,1)~=numel(imgIdx)
    newvote = zeros(numel(imgIdx),5);
    newvote(1:size(vote),:) = vote;
else
    newvote = vote;
end



for i = 1:nCol
    for j =1:numel(C{i})
        name = C{i}{j}((nPrefix+1):end);
        idx = (strcmp(imgName,name));
        l = C{i+nCol}(j);
        if l>=0
            newvote(idx,l+1) = newvote(idx,l+1)+1;
        end
    end
end
