function feat = featureSalMulti(salmap)

salmap = im2double(salmap);
salmap = salmap(:,:,1);
salmap = imresize(salmap,[128,128]);

salmap1 = imresize(salmap,[16 16],'box');
feat1 = salmap1(:);

salmap2 = imresize(salmap,[8 8],'box');
feat2 = salmap2(:);

feat = [feat1; feat2];