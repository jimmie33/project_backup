function feat = featureSIFT(I)

binSize = 8;
step = 32;

if (size(I,3)>1)
    I = rgb2gray(I);
end
I = single(imresize(I, [256 256]));
[F, D] = vl_dsift(I,'size',binSize,'step',step,'norm');
[F_, D_] = vl_dsift(255-I,'size',binSize,'step',step,'norm');

feat = D+D_;
mask = repmat([ones(1,4) zeros(1,4)],[1 16]);
feat(mask>0,:) = [];
feat = double(feat(:))';
% eng = F(3,:);
% feat(:,eng<mean(eng)) = 0; 