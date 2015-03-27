function HDF5_generate_data_Rec(outputDir,imgIdx,randomCrop)
% pay attention ot the size of the image: [224 224] or [227 227].

load ../SBTDATA/HDF5_demo/bboxAnnoData/center100
load ../SBTDATA/HDF5_demo/bboxAnnoData/pivot_center16


%% initialize param
param = getParam(outputDir,center,pivot_center,randomCrop);

if ~exist(param.outputDir,'dir')
    mkdir(param.outputDir);
end

%% Output
fID2 = fopen(fullfile(param.outputDir,'h5List.txt'),'w');
chunkNum = 0;
chunkData = zeros(param.imageSize(1), param.imageSize(2),3,param.chunkSize);
chunkCenterLabel = zeros(size(center,2),1,1,param.chunkSize);
chunkStateLabel = zeros(size(center,2),1,1,param.chunkSize);
chunkToCont = zeros(1,1,1,param.chunkSize);
chunkSize = param.chunkSize;
loc = 1;
nImg = numel(imgIdx);
for i = 1:nImg
   try
       [im cLabel stateLabel toCont] = getGT_Rec(imgIdx(i),param,true);
   catch e
       warning('fail to process %s', imgIdx(i).name);
       continue;
   end
   im = permute(im, [2 1 3]);
   
   chunkData(:,:,:,loc) = double(im);
   chunkCenterLabel(:,1,1,loc) = cLabel(:);
   chunkStateLabel(:,1,1,loc) = stateLabel(:);
   chunkToCont(:,1,1,loc) = toCont;
   loc = loc+1;
   
   try
       [im cLabel stateLabel toCont] = getGT_Rec(imgIdx(i),param,false);
   catch e
       warning('fail to process %s', imgIdx(i).name);
       continue;
   end
   im = permute(im, [2 1 3]);
   
   chunkData(:,:,:,loc) = double(im);
   chunkCenterLabel(:,1,1,loc) = cLabel(:);
   chunkStateLabel(:,1,1,loc) = stateLabel(:);
   chunkToCont(:,1,1,loc) = toCont;
   loc = loc+1;
   
   if loc > param.chunkSize || i == nImg
       chunkData = chunkData(:,:,:,1:(loc-1));
       chunkCenterLabel = chunkCenterLabel(:,:,:,1:(loc-1));
       chunkStateLabel = chunkStateLabel(:,:,:,1:(loc-1));
       chunkToCont = chunkToCont(:,:,:,1:(loc-1));
       
       h5filename = fullfile(param.outputDir,sprintf('%05d.h5',chunkNum));
       
       h5create(h5filename, '/data', [param.imageSize 3 Inf], 'Datatype', ...
           'single', 'ChunkSize', [param.imageSize 3 chunkSize]); % width, height, channels, number 
       h5write(h5filename, '/data', single(chunkData), [1 1 1 1], size(chunkData));
       
       h5create(h5filename, '/centerLabel', [size(center,2),1,1,Inf], 'Datatype', ...
           'single', 'ChunkSize', [size(center,2),1,1,chunkSize]); % width, height, channels, number 
       h5write(h5filename, '/centerLabel', single(chunkCenterLabel), [1 1 1 1], size(chunkCenterLabel));
       
       h5create(h5filename, '/stateLabel', [size(chunkStateLabel,1),1,1,Inf], 'Datatype', ...
           'single', 'ChunkSize', [size(chunkStateLabel,1),1,1,chunkSize]); % width, height, channels, number 
       h5write(h5filename, '/stateLabel', single(chunkStateLabel), [1 1 1 1], size(chunkStateLabel));
       
       h5create(h5filename, '/toCont', [size(chunkToCont,1),1,1,Inf], 'Datatype', ...
           'single', 'ChunkSize', [size(chunkToCont,1),1,1,chunkSize]); % width, height, channels, number 
       h5write(h5filename, '/toCont', single(chunkToCont), [1 1 1 1], size(chunkToCont));
            
       fprintf('%05d batch processed\n',chunkNum)
       fprintf(fID2,'%s\n', fullfile(pwd,h5filename));
       
       chunkData = zeros(param.imageSize(1), param.imageSize(2),3,param.chunkSize);
       chunkCenterLabel = zeros(size(center,2),1,1,param.chunkSize);
       chunkStateLabel = zeros(size(center,2),1,1,param.chunkSize);
       chunkToCont = zeros(1,1,1,param.chunkSize);
       loc = 1;
       chunkNum = chunkNum +1;
   end
end

fclose(fID2);