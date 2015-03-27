function output = geodesicSmooth(img,dis,sigma)
% img: double, normalized

aff = exp(-dis./sigma.^2);
aff = bsxfun(@times, aff, 1./sum(aff,2));

output = aff*reshape(img,size(img,1)*size(img,2),[]);
output = reshape(output,size(img,1), size(img,2), []);