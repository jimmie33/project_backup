function [vhist] = getVoteStat(vote)

ss = sum(vote,2);
fprintf('---------------------------\n')
fprintf('#image vs #vote:\n');
for i=0:3
    fprintf('%d:\t%d\n', i,sum(ss==i));
end
fprintf('%d+:\t%d\n',4,sum(ss>=4));


%% vhist
fprintf('---------------------------\n')
fprintf('#image vs #instance consistently labeled:\n');
vv = max(vote,[],2);
mask = vv >= 4;
vv = (vote == repmat(vv,[1,5]));
vv = vv(mask,:);
for i=0:3
    fprintf('%d:\t%d\n',i,sum(vv(:,i+1)));
end
fprintf('4+:\t%d\n',sum(vv(:,5)));
