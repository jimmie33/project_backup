function [sample label] = getTask(srcDir,c, feats)

% feats: struct array, with fields type dscr


neg = [];
pos = [];

for i = 0:4
    if i == c
        for j = 1:numel(feats)
            load(fullfile(srcDir,feats{j}.type,[num2str(i) '_' feats{j}.dscr]));
            pos = [pos feat];
        end
    else
        temp = [];
        for j = 1:numel(feats)
            load(fullfile(srcDir,feats{j}.type,[num2str(i) '_' feats{j}.dscr]));
            temp = [temp feat];
        end
        neg = [neg;temp];
    end
end

sample = [pos;neg];
label = [ones(size(pos,1),1);zeros(size(neg,1),1)];