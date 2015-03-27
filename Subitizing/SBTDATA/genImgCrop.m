function imgCrop = genImgCrop(I,cropConf)

% generate image crops based on cropConf; output a cell array.

if size(I,3) == 1
    I = repmat(I,[1,1,3]);
end

imsz = size(I); imsz = imsz(1:2);
sz = size(cropConf{1}.msk);
imgCrop = [];
for i = 1:numel(cropConf)
    roi = cropConf{i}.roi; 
    roi = roi([2 1 4 3]); % convert to [rmin cmin rmax cmax]
    roi = roi./[sz sz].*[imsz imsz];
    roi(1:2) = max((roi(1:2)-imsz./sz + 1),1);
    roi = round(roi);
    imgCrop{end+1} = I(roi(1):roi(3),roi(2):roi(4),:);
end