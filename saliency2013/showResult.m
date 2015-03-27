function showResult(data, model)

auc = [];
sigma = [];
avg = zeros(1,numel(model));
for dataIdx = 1:numel(data)
    saveDir = fullfile('result/EFP_Judd/noCB',data{dataIdx}.name);
    fprintf('\n%s:\n', data{dataIdx}.name);
    for modelIdx = 1:numel(model)
        resultFile = fullfile(saveDir,[model{modelIdx}.name,'.mat']);
        if exist(resultFile,'file')
            load(fullfile(saveDir,[model{modelIdx}.name,'.mat']));
        else
            fprintf('%s does not exist', resultFile);
            continue
        end
        [mxaux mxidx] = max(auc);
        avg(modelIdx) = avg(modelIdx) + mxaux;
        fprintf('%s: %f, %f\n', model{modelIdx}.name, mxaux, sigma(mxidx));
    end
end

avg = avg./numel(data);
fprintf('\nAVG:\n')
for modelIdx = 1:numel(model)
    fprintf('%s: %f\n', model{modelIdx}.name, avg(modelIdx));
end


end