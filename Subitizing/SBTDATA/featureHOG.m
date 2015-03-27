function feat = featureHOG(I,sz)

I = imresize(I,sz);
I = im2single(I);

feat = vl_hog(I,8);
