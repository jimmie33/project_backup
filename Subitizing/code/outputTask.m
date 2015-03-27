task={...
    struct('type','CNN','conf',{{struct('type','CNN','dscr','vc7')}}),...
%     struct('type','HOG','conf',{{struct('type','HOG','dscr','64'),struct('type','HOG','dscr','128')}}),...
%     struct('type','GIST','conf',{{struct('type','GIST','dscr','128')}}),...
    };
pcaN = 100;
dscr = 'pca100';
load ../trainSample/label;
trainLabel = label;
load ../testSample/label;
testLabel = label;
for i = 1:numel(task)
    [sample] = getTaskMulti('../trainSample',task{i}.conf);
    [sample, m, V] = prepPCA(sample,pcaN);
    save(fullfile('../trainSample/',task{i}.type,['sample_' dscr]),...
        'sample','m','V');
%     arffwrite(fullfile('../trainSample/',task{i}.type,['sample_' dscr '.arff']),'train',[sample trainLabel]);
    [sample] = getTaskMulti('../testSample',task{i}.conf);
    sample = applyPCA(sample,m,V);
    save(fullfile('../testSample/',task{i}.type,['sample_' dscr]),...
        'sample','m','V');
%     arffwrite(fullfile('../testSample/',task{i}.type,['sample_' dscr '.arff']),'test',[sample testLabel]);
end