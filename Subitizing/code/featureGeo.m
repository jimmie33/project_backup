function feat = featureGeo(I)

dim = 32;

if(size(I,3)==1)
    I = repmat(I,[1 1 3]);
end

feat = getFeatVec2(I,dim);
