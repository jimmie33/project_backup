function map = getCenterMap(sz);

blobx = repmat(abs([1:sz(2)]-sz(2)/2)',[1,sz(1)]);
bloby = repmat(abs([1:sz(1)]-sz(1)/2),[sz(2),1]);
blobMap = (blobx.^2+bloby.^2).^0.5;
blobMap = blobMap./(max(blobMap(:)));
map = 1-blobMap;