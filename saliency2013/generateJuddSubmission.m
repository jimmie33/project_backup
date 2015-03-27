inputdir = 'salmaps/Judd300/output_CWS';
outputdir = 'uploadJudd/Judd300/CWS';
sigma_scale = 0.2;

blobx = repmat(abs([1:600]-300)',[1,600]);
bloby = repmat(abs([1:600]-300),[600,1]);
blobMap = (blobx.^2+bloby.^2).^0.5;
blobMap = blobMap./(max(blobMap(:)));
blobMap = 1-blobMap;

mkdir(outputdir);

D = dir(fullfile(inputdir,'*.png'));
filelist = {D.name};

parfor i = 1:numel(filelist)
    a = imread(fullfile(inputdir,filelist{i}));
    
    sigma=round(max(size(a,1),size(a,2))*sigma_scale);
    if sigma~=0
        h=fspecial('gaussian',[2*sigma,2*sigma],sigma);
        a=imfilter(a,h);%
    end
    
    a=im2double(a);
    
    if ~isempty(blobMap)
        cm = imresize(blobMap,size(a));
        a = double(a).*cm;
    end
    a = a-min(a(:));
    a = a/max(a(:));
    
    imwrite(a,fullfile(outputdir,[filelist{i}(1:end-4),'.jpg']));
    
end