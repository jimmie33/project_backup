%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Implemetation of the saliency detction method described in paper
%	"Saliency Detection: A Boolean Map Approach", Jianming Zhang, 
%	Stan Sclaroff, ICCV, 2013
%	
%	Copyright (C) 2013 Jianming Zhang
%
%	This program is free software: you can redistribute it and/or modify
%	it under the terms of the GNU General Public License as published by
%	the Free Software Foundation, either version 3 of the License, or
%	(at your option) any later version.
%
%	This program is distributed in the hope that it will be useful,
%	but WITHOUT ANY WARRANTY; without even the implied warranty of
%	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%	GNU General Public License for more details.
%
%	You should have received a copy of the GNU General Public License
%	along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%	If you have problems about this software, please contact: jmzhang@bu.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function postprocess(inputdir, ext, outputdir, sigma_scale)
% This function is used to postprocess BMS saliency maps for the evaluation
% using any metric that does not compensate the center bias. e.g. AUC. Do
% not use this code if shuffled-AUC is used.
% 
% 
% Example:
% postprocess('./BMS/salmaps/dir/', '.jpeg');
%
% Note that @ext is the extention of the input saliency maps. @ outputdir and
% @sigma_scale are optional.
%
% by Jianming Zhang, 05.2014


if nargin < 4
    sigma_scale = 0.07; % default blurring paramter learned base on the MIT dataset
end

if nargin < 3
    outputdir = inputdir;
end

if ~exist(outputdir,'dir')
    mkdir(outputdir);
end

x = repmat(abs([1:600]-300)',[1,600]);
y = repmat(abs([1:600]-300),[600,1]);
distMap = (x.^2+y.^2).^0.5;
distMap = distMap./(max(distMap(:)));
distMap = 1-distMap;


D = dir(fullfile(inputdir,['*' ext]));
filelist = {D.name};

parfor i = 1:numel(filelist)
    a = imread(fullfile(inputdir,filelist{i}));
    
    % blurring
    sigma=round(max(size(a,1),size(a,2))*sigma_scale);
    if sigma~=0
        h=fspecial('gaussian',[2*sigma,2*sigma],sigma);
        a=imfilter(a,h);%
    end
    
    % center distance weighting
    if ~isempty(distMap)
        cm = imresize(distMap,size(a));
        a = double(a).*cm;
    end
    a = a-min(a(:));
    a = a/max(a(:));
    
    imwrite(a,fullfile(outputdir,filelist{i}));
end