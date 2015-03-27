function param = getParam2(outputDir,randomCrop)

param.outputDir = outputDir;
param.randomCrop = randomCrop; % random sampling window
param.chunkSize = 100;
param.imageSize = [224 224];%224
param.gtMapSize = [7 7];
param.imageMean = [103.939 116.779 123.68]; % BGR
