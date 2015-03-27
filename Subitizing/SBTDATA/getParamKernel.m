function param = getParamKernel()


param = {...
    struct('name','AllCat_SIFT_IFV_327K','label_set',{{0,1,2,3,4}},'kernel',...% Use aug!!!!!
        struct('name','SIFT/SIFT_IFV_327K_linear')),...
        };