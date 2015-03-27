function [areaUnderROC]=computeMeanAUC(fixMaps,overallFixMap,salmapDir,ext,sigma_scale)
% @areaUnderROC: the vector recording the AUC score for each saliency map
% @fixMaps: cell array that contains the ground truth for each test image
% @overallFixMap: the shuffle map
% @salmapDir: directory that contains the saliency maps for evaluation
% @ext: the extention of the saliency maps, e.g. '.png'
% @sigma_scale: guassian blur kenerl width (std), relative to the largest dimention of 
% the test image, usually a value between 0-0.12 
%
% If you use any of this work in scientific research or as part of a larger 
% software system, you are kindly requested to cite the use in any related 
% publications or technical documentation. The work is based upon:
%
%   Jianming Zhang, and Stan Sclaroff, "Saliency Detection: A Boolean Map 
%   Approach," in the Proc. of the IEEE International Conference on Computer 
%   Vision (ICCV), 2013.
%
% @author J. Zhang
% @date   2014

nls=numel(fixMaps);
areaUnderROC=zeros(1,nls);

parfor i=1:nls
    fixMap = full(double(fixMaps{i}.fixMap));
    fixMap = imresize(fixMap,size(overallFixMap),'nearest');
    [~, name, ~] = fileparts(fixMaps{i}.srcName);
    name = [name, ext];
    a=imread(fullfile(salmapDir,name));
    a=a(:,:,1);
    a=imresize(a,size(fixMap));
    
    sigma=round(max(size(a,1),size(a,2))*sigma_scale);
    if sigma~=0
        h=fspecial('gaussian',[2*sigma,2*sigma],sigma);
        a=imfilter(a,h,'replicate');%
    end
    
    a=im2double(a);
    
    AUC=calcAUCscore(a,fixMap>0,overallFixMap.*(1-(fixMap>0)),100);
    areaUnderROC(:,i)=mean(AUC);
end
