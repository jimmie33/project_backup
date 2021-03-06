% addpath(genpath('../../../../rcnn/rcnn'));
addpath(genpath('../../caffe_my/matlab/caffe'));
img_root = 'data/Overall/neg';
out_root = 'feature/CNN/';   
if ~exist(out_root,'dir')
    mkdir(out_root)
end

D = dir(fullfile(img_root, '*.*'));
imgList = {D.name};
imgList(strcmp(imgList,'.')) = [];
imgList(strcmp(imgList,'..')) = [];

% Loads and initializes CNN model.
model_def_file = ...
    '/research/cbi/jmzhang_work_dir/caffe_dev/models/VGG_ILSVRC_16/deploy_fc7.prototxt';%sbt model
model_file = ...
    '/research/cbi/jmzhang_work_dir/caffe_dev/models/VGG_ILSVRC_16/snapshot_full/VGG16_imagenet_train_iter_40000.caffemodel';%sbt model

matcaffe_init(1, model_def_file, model_file);

% Initializes the cnn feature extraction parameters.
%load('../../../../caffe-openhero/matlab/caffe/ilsvrc_2012_mean');

% cnn_params.image_mean = image_mean;
cnn_params.batch_size = 10;%10
cnn_params.width = 224;%224
cnn_params.height = 224;%224
cnn_params.shift = 4;
cnn_params.vshift_num = 4;
cnn_params.hshift_num = 4; 

% cnn_params.image_mean = imresize(image_mean,[cnn_params.height, cnn_params.width]);
cnn_params.image_mean = repmat(reshape([103.939 116.779 123.68],1,1,3),[cnn_params.height, cnn_params.width, 1]);

% 
imgs = [];
for i = 1:length(imgList)
    [imgs{i},cmap]= imread(fullfile(img_root, imgList{i}));
    
    if size(cmap,2) > 0
        fprintf(1, 'fixing %s\n', imgList{i});
        newim = cell(1, size(cmap,2));
        for j=1:size(cmap,2)
          ch = cmap(:,j);
          newim{j} = ch(imgs{i}+1);
        end
        imgs{i} = cat(3, newim{:});
    end
    
    
    if ndims(imgs{i}) < 3
        imgs{i} = grey2rgb(imgs{i});
    end
end
feat = extract_cnnfeat(imgs, cnn_params);

save(fullfile(out_root,'CNNFT_VGG16_Sbt_40000_fc7_neg'),'feat','-v7.3');
