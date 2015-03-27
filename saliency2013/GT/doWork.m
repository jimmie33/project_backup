
for i = 1:numel(fixMaps)
    map = imread(fullfile('../data/MIT/fixMap/',[fixMaps{i}.srcName(1:end-5),'_fixPts.jpg']));
    fixMaps{i}.fixMap = sparse(map>128);
end
save('MIT_GT','overallFixMap','fixMaps','-v7.3')