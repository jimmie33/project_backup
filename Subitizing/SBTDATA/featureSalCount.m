function feat = featureSalCount(salmap,thresh)

salmap = imresize(salmap,[30,30]);
salmap = im2double(salmap(:,:,1));

bw = salmap > 2*mean(salmap(:));
S = regionprops(bw,'Area');
a = [S.Area];
a = sqrt(a);
a = a/max(a);
n = sum(a>thresh);


feat=zeros(1,4);
if n<4 && n>0
    feat(n)=1;
elseif n>0
    feat(4)=1;
else
    feat(1)=1;
end
