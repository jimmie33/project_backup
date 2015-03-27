function getRawPatternCNN(dscr)

fd = 4096;% uint8
mkdir ../trainSample/CNN
mkdir ../testSample/CNN
for imgCatIdx = 0:4
    load(fullfile('../DATA/SBT/cnnfeat/',...
        ['train_cnnfeat_c' num2str(imgCatIdx) '_fc7_']));
    feat = double(trainCNNFeat(1:16:end,:));
    save(fullfile('../trainSample/CNN',[num2str(imgCatIdx) '_' dscr]),'feat','-v7.3');
    load(fullfile('../DATA/SBT/cnnfeat/',...
        ['test_cnnfeat_c' num2str(imgCatIdx) '_fc7_']));
    feat = double(testCNNFeat);
    save(fullfile('../testSample/CNN',[num2str(imgCatIdx) '_' dscr]),'feat','-v7.3');
end