function feat = featureSalMulti(salmap,I)

salmap = im2double(salmap);
salmap = salmap(:,:,1);
salmap = imresize(salmap,[128,128]);
I = imresize(I,[128 128]);
I = im2double(I);

edgemap = abs(imfilter(I,fspecial('sobel'),'replicate'));
edgemap = sum(edgemap,3);
edgemap = edgemap./max(edgemap(:));
edgemap = edgemap.*salmap;


salmap1 = imresize(salmap,[16 16],'box');
feat1 = salmap1(:);

salmap2 = imresize(salmap,[8 8],'box');
feat2 = salmap2(:);

edgemap1 = imresize(edgemap,[16 16],'box');
feat3 = edgemap1(:);

edgemap2 = imresize(edgemap,[8 8],'box');
feat4 = edgemap2(:);

feat = [feat1; feat2; feat3; feat4];