function HDF5_generate_data_sbtmap(outputDir,imgIdx,randomCrop)
% pay attention ot the size of the image: [224 224] or [227 227].


%% initialize param
param = getParam2(outputDir,randomCrop);

if ~exist(param.outputDir,'dir')
    mkdir(param.outputDir);
end

%% Output
fID2 = fopen(fullfile(param.outputDir,'h5List.txt'),'w');
chunkNum = 0;
chunkData = zeros(param.imageSize(1), param.imageSize(2),3,param.chunkSize);
chunkSbtMap = zeros(param.gtMapSize(1),param.gtMapSize(2),1,param.chunkSize);
chunkLabel = -1*ones(1,param.chunkSize);
chunkSize = param.chunkSize;
loc = 1;
nImg = numel(imgIdx);
for i = 1:nImg
   try
       [im sbtmap nlabel] = getGT_sbtmap(imgIdx(i),param.gtMapSize,param,false);
   catch e
       warning('fail to process %s', imgIdx(i).name);
       continue;
   end
   im = permute(im, [2 1 3]);
   sbtmap = sbtmap';
   
   chunkData(:,:,:,loc) = double(im);
   chunkSbtMap(:,:,1,loc) = sbtmap;
   chunkLabel(loc) = nlabel;
   loc = loc+1;
   
   if loc > param.chunkSize || i == nImg
       chunkData = chunkData(:,:,:,1:(loc-1));
       chunkSbtMap = chunkSbtMap(:,:,:,1:(loc-1));
       chunkLabel = chunkLabel(:,1:(loc-1));
       
       h5filename = fullfile(param.outputDir,sprintf('%04d.h5',chunkNum));
       h5create(h5filename, '/data', [param.imageSize 3 Inf], 'Datatype', ...
           'single', 'ChunkSize', [param.imageSize 3 chunkSize]); % width, height, channels, number 
       h5write(h5filename, '/data', single(chunkData), [1 1 1 1], size(chunkData));
       h5create(h5filename, '/sbtmap', [param.gtMapSize(1),param.gtMapSize(2),1,Inf], 'Datatype', ...
           'single', 'ChunkSize', [param.gtMapSize(1),param.gtMapSize(2),1,chunkSize]); % width, height, channels, number 
       h5write(h5filename, '/sbtmap', single(chunkSbtMap), [1 1 1 1], size(chunkSbtMap));
       h5create(h5filename, '/label', [1 Inf], 'Datatype', ...
           'single', 'ChunkSize', [1 chunkSize]); % width, height, channels, number 
       h5write(h5filename, '/label', single(chunkLabel), [1 1], size(chunkLabel));
       fprintf('%04d batch processed\n',chunkNum)
       fprintf(fID2,'%s\n', fullfile(pwd,h5filename));
       
       chunkData = zeros(param.imageSize(1), param.imageSize(2),3,param.chunkSize);
       chunkSbtMap = zeros(param.gtMapSize(1),param.gtMapSize(2),1,param.chunkSize);
       chunkLabel = -1*ones(1,param.chunkSize);
       loc = 1;
       chunkNum = chunkNum +1;
   end
end

fclose(fID2);