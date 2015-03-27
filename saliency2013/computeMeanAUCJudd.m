function [areaUnderROC]=computeMeanAUCJudd(fixMaps,salmapDir,ext,sigma_scale,centerMap)

if nargin < 5
    centerMap = [];
end

nls=numel(fixMaps);
areaUnderROC=zeros(1,nls);

% iErase = '';

parfor i=1:nls
%     fprintf('%d\n',i);
%     clc,fprintf('%s: %d\n',salmapDir, i);
%     iStr = num2str(i);
%     fprintf([iErase,iStr]);
%     iErase = repmat(sprintf('\b'),1,length(iStr));
    
    fixMap = full(double(fixMaps{i}.fixMap));
    [~, name, ~] = fileparts(fixMaps{i}.srcName);
    name = [name, ext];
    a=imread(fullfile(salmapDir,name));
    a=a(:,:,1);
    a=imresize(a,size(fixMap));
    
    sigma=round(max(size(a,1),size(a,2))*sigma_scale);
    if sigma~=0
        h=fspecial('gaussian',[2*sigma,2*sigma],sigma);
        a=imfilter(a,h);%
    end
    
    a=im2double(a);
    if ~isempty(centerMap)
        cm = imresize(centerMap,size(fixMap));
        a = a.*cm;
    end
    
    
%     AUC=calcAUCscore(a,fixMap>0,overallFixMap.*(1-(fixMap>0)),100);
    areaUnderROC(:,i)=predictFixations(a, fixMap>0);
end

