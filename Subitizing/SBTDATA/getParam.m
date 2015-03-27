function param = getParam()


param_baseline1 = {...
    struct('name','AllCat_HOG_pca100','label_set',{{0,1,2,3,4}},'feature',...
        {{struct('name','HOG/HOG_128','pca',100,'norm',false)}}),...
    struct('name','AllCat_SIFT_pca100','label_set',{{0,1,2,3,4}},'feature',...
        {{struct('name','SIFT/SIFT_256','pca',100,'norm',false)}}),...
    struct('name','AllCat_GIST_pca100','label_set',{{0,1,2,3,4}},'feature',...
        {{struct('name','GIST/GIST_128','pca',100,'norm',false)}}),... 
    struct('name','AllCat_Sal_pca320','label_set',{{0,1,2,3,4}},'feature',...
        {{struct('name','SAL/SAL_16_8','pca',320,'norm',false)}}),...
    };
param_baseline2 = {...
    struct('name','0_1_234_CNN_pca100','label_set',{{0,1,[2,3,4]}},'feature',...
        {{struct('name','CNN/CNN','pca',100,'norm',true)}}),...
    struct('name','1_234_CNN_pca100','label_set',{{1,[2,3,4]}},'feature',...
        {{struct('name','CNN/CNN','pca',100,'norm',true)}}),...
    };
param_our = {...
%     struct('name','AllCat_SalCNN_pca100','label_set',{{0,1,2,3,4}},'feature',...
%         {{struct('name','CNN/SalCNN','pca',100,'norm',false)}}),...
%     struct('name','AllCat_SalCNNFT_pca100','label_set',{{0,1,2,3,4}},'feature',...
%         {{struct('name','CNN/SalCNNFT','pca',100,'norm',false)}}),...  
    struct('name','AllCat_CNN_pca100','label_set',{{0,1,2,3,4}},'feature',...
        {{struct('name','CNN/CNN','pca',100,'norm',false)}}),...
    struct('name','AllCat_CNNFT_pca100_aug','label_set',{{0,1,2,3,4}},'feature',...% Use aug!!!!!
        {{struct('name','CNN/CNNFT_aug','pca',100,'norm',false)}}),...
    struct('name','AllCat_CNNFT_GIST_pca200','label_set',{{0,1,2,3,4}},'feature',...
        {{struct('name','CNN/CNNFT','pca',100,'norm',false),...
        struct('name','GIST/GIST_128','pca',100,'norm',false)}}),...
    struct('name','AllCat_CNNFT_SAL_pca420','label_set',{{0,1,2,3,4}},'feature',...
        {{struct('name','CNN/CNNFT','pca',100,'norm',false),...
        struct('name','SAL/SAL_16_8','pca',320,'norm',false)}}),...
    struct('name','AllCat_CNNFT_GIST_SAL_pca520','label_set',{{0,1,2,3,4}},'feature',...
        {{struct('name','CNN/CNNFT','pca',100,'norm',false),...
        struct('name','GIST/GIST_128','pca',100,'norm',false),...
        struct('name','SAL/SAL_16_8','pca',320,'norm',false)}}),...
    struct('name','AllCat_SIFT_IFV_327K','label_set',{{0,1,2,3,4}},'feature',...% Use aug!!!!!
        {{struct('name','SIFT/SIFT_IFV_327K','pca',0,'norm',false)}}),...
%     struct('name','AllCat_CNN_Sal_pca150','label_set',{{0,1,2,3,4}},'feature',...
%         {{struct('name','CNN/CNN','pca',100,'norm',true),...
%         struct('name','SAL/SAL_16_8','pca',50,'norm',false)}}),...
%     struct('name','0_1_234_CNN_SalCNN_Sal_pca250','label_set',{{0,1,[2,3,4]}},'feature',...
%         {{struct('name','CNN/CNN','pca',100,'norm',true),...
%         struct('name','CNN/SalCNN','pca',100,'norm',true),...
%         struct('name','SAL/SAL_16_8','pca',50,'norm',false)}}),...
%     struct('name','AllCat_CNN_SalCNN_Sal_pca250','label_set',{{0,1,2,3,4}},'feature',...
%         {{struct('name','CNN/CNN','pca',100,'norm',true),...
%         struct('name','CNN/SalCNN','pca',100,'norm',true),...
%         struct('name','SAL/SAL_16_8','pca',50,'norm',false)}}),...
%     struct('name','AllCat_CNNFT_Sal_pca150','label_set',{{0,1,2,3,4}},'feature',...
%         {{struct('name','CNN/CNNFT','pca',100,'norm',true),...
%         struct('name','SAL/SAL_16_8','pca',50,'norm',false)}}),...
%     struct('name','1_2_3_4_CNN_SalCNN_Sal_pca250','label_set',{{1,2,3,4}},'feature',...
%         {{struct('name','CNN/CNN','pca',100,'norm',true),...
%         struct('name','CNN/SalCNN','pca',100,'norm',true),...
%         struct('name','SAL/SAL_16_8','pca',50,'norm',false)}}),...
    };

param = [param_our];