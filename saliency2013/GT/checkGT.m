function checkGT(fixMaps)

for i = 1:numel(fixMaps)
    map = full(fixMaps{i}.fixMap);
    if mean(map(:))>0.5
        keyboard
    end
end