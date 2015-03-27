function [sample] = getTaskMulti(srcDir,feats)

% feats: struct array, with fields type dscr
% label = [];
sample = [];
for i = 0:4
    temp = [];
    for j = 1:numel(feats)
        load(fullfile(srcDir,feats{j}.type,[num2str(i) '_' feats{j}.dscr]));
%         label = [label; i*ones(size(feat,1),1)];
        temp = [temp feat];
    end
    sample = [sample;temp];    
end