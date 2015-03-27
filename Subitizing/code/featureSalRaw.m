function feat = featureSalRaw(salmap,sz)

salmap = imresize(salmap,sz,'box');
salmap = salmap(:,:,1);
salmap = im2double(salmap);
feat = salmap(:);