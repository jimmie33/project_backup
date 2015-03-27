% addpath(genpath('../../../../rcnn/rcnn'));
addpath(genpath('../../../caffe_my/matlab/caffe'));
out_root = 'feature/CNN/';
mkdir(out_root)
% load ../imgIdx 
% imgList = {imgIdx.name};
load('trainValImgIdx');   
imgList = {valImgIdx.path};  
% D = dir(fullfile(img_root,'*.jpg')); 
% imgList = {D.name};
% load(fullfile(img_root,'imgList'));

% display(1)
% keyboard
% Loads and initializes CNN model.
model_def_file = ...
    '/research/cbi/jmzhang_work_dir/caffe_my/models/VGG_ILSVRC_16_Exp1/deploy_pivot_pair.prototxt';
model_file = ...
    '/research/cbi/jmzhang_work_dir/caffe_my/models/VGG_ILSVRC_16_Exp1/snapshot_pp/cache_imgNetPretrain_pp16_3/VGG16_imagenet_train_iter_90000.caffemodel';
caffe('init', model_def_file, model_file);
caffe('set_mode_gpu');
caffe('set_phase_test');
% matcaffe_init(1, model_def_file, model_file);
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
    [imgs{i},cmap]= imread(imgList{i});
    
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

save(fullfile(out_root,'CNNFT_VGG16_Exp1_pp_16_90000'),'feat');