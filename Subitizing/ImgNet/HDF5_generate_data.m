function HDF5_generate_data(outputDir,imgIdx,randomCrop)
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
chunkPivotPair = zeros(param.n_pivot_pair,1,1,param.chunkSize);
chunkSize = param.chunkSize;
loc = 1;
nImg = numel(imgIdx);
for i = 1:nImg
   try
       [im cLabel pivotPairLabel] = getGT(imgIdx(i),param);
   catch e
       warning('fail to process %s', imgIdx(i).name);
       continue;
   end
   im = permute(im, [2 1 3]);
   
   chunkData(:,:,:,loc) = double(im);
   chunkCenterLabel(:,1,1,loc) = cLabel(:);
   chunkPivotPair(:,1,1,loc) = pivotPairLabel(:);
   loc = loc+1;
   
   if loc > param.chunkSize || i == nImg
       chunkData = chunkData(:,:,:,1:(loc-1));
       chunkCenterLabel = chunkCenterLabel(:,:,:,1:(loc-1));
       chunkPivotPair = chunkPivotPair(:,:,:,1:(loc-1));
       
       h5filename = fullfile(param.outputDir,sprintf('%05d.h5',chunkNum));
       
       h5create(h5filename, '/data', [param.imageSize 3 Inf], 'Datatype', ...
           'single', 'ChunkSize', [param.imageSize 3 chunkSize]); % width, height, channels, number 
       h5write(h5filename, '/data', single(chunkData), [1 1 1 1], size(chunkData));
       
       h5create(h5filename, '/centerLabel', [size(center,2),1,1,Inf], 'Datatype', ...
           'single', 'ChunkSize', [size(center,2),1,1,chunkSize]); % width, height, channels, number 
       h5write(h5filename, '/centerLabel', single(chunkCenterLabel), [1 1 1 1], size(chunkCenterLabel));
       
       h5create(h5filename, '/pivotPair', [size(chunkPivotPair,1),1,1,Inf], 'Datatype', ...
           'single', 'ChunkSize', [size(chunkPivotPair,1),1,1,chunkSize]); % width, height, channels, number 
       h5write(h5filename, '/pivotPair', single(chunkPivotPair), [1 1 1 1], size(chunkPivotPair));
            
       fprintf('%05d batch processed\n',chunkNum)
       fprintf(fID2,'%s\n', fullfile(pwd,h5filename));
       
       chunkData = zeros(param.imageSize(1), param.imageSize(2),3,param.chunkSize);
       chunkCenterLabel = zeros(size(center,2),1,1,param.chunkSize);
       chunkPivotPair = zeros(param.n_pivot_pair,1,1,param.chunkSize);
       loc = 1;
       chunkNum = chunkNum +1;
   end
end

fclose(fID2);