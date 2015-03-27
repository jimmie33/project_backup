addpath ../../../vlfeat-0.9.18/toolbox/
vl_setup;

outputDir = 'HDF5/ImgNet224X224_sbtmap_train/';

load trainValImgIdx
% trainImgIdx = trainImgIdx(randperm(numel(valImgIdx)));
HDF5_generate_data_sbtmap(outputDir,trainImgIdx,false);