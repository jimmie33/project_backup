DATA={...
    struct('name','ImgSal','sigma',0.04:0.01:0.07),...
    };


for i = 1:numel(DATA)
    load(['rawEyeFix_' DATA{i}.name]);
    score = [];
    for sigma = DATA{i}.sigma
        score(numel(score)+1) = mean(interObsSAUC(rawEyeFix,shufflemap,sigma,3));
    end
    [maxauc idx] = max(score);
    sigma = DATA{i}.sigma;
    fprintf('%s: %f %f\n', DATA{i}.name, maxauc, sigma(idx));
    save(['sauc_record_' DATA{i}.name], 'score', 'sigma');
end

%%

DATA={...
    struct('name','MIT','sigma',0.07:0.01:0.1),...
    struct('name','Toronto','sigma',0.07:0.01:0.1),...
    struct('name','Cerf','sigma',0.07:0.01:0.1),...
    struct('name','Kootstra','sigma',0.07:0.01:0.1),...
    struct('name','DUTOmron','sigma',0.07:0.01:0.1),...
    struct('name','SBU_VOC','sigma',0.1:0.01:0.15),...
    struct('name','ImgSal','sigma',0.07:0.01:0.1),...
    };


for i = 1:numel(DATA)
    load(['rawEyeFix_' DATA{i}.name]);
    score = [];
    for sigma = DATA{i}.sigma
        score(numel(score)+1) = mean(interObsAUC(rawEyeFix,sigma,3));
    end
    [maxauc idx] = max(score);
    sigma = DATA{i}.sigma;
    fprintf('%s: %f %f\n', DATA{i}.name, maxauc, sigma(idx));
    save(['auc_record_' DATA{i}.name], 'score', 'sigma');
end