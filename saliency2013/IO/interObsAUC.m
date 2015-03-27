function score = interObsAUC(rawEyeFix,sigma_scale,ntrial)

n = numel(rawEyeFix);
score = nan(1,n);

parfor i=1:n
    nMap = numel(rawEyeFix{i});
    auc = nan(ntrial,1);
    if nMap <2
        score(i) = 1;
        continue
    end
    
    for trial = 1:ntrial
        idxset = randperm(nMap,floor(0.5*nMap));
        target = zeros(size(rawEyeFix{i}{1}));
        for k = 1:nMap
            if any(k == idxset)
                target = target + full(rawEyeFix{i}{k});
            end
        end
        target = target > 0;
        salmap = zeros(size(rawEyeFix{i}{1}));
        for k = 1:nMap
            if any(k == idxset)
                continue
            end
            salmap = salmap + full(rawEyeFix{i}{k});
        end
        
        sigma=round(max(size(salmap,1),size(salmap,2))*sigma_scale);
        if sigma~=0
            h=fspecial('gaussian',[2*sigma,2*sigma],sigma);
            salmap=imfilter(salmap,h);%
        end
        
        salmap = double(salmap);
        auc(trial)=predictFixations(salmap,target);
    end
    score(i)= mean(auc);
end