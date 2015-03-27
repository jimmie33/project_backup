function [ score ] = calcAUCscore( salMap, eyeMap, shufMap, numRandom )
  %CALCAUCSCORE Calculate AUC score of a salmap
  %   Usage: [score] = calcAUCscore ( salmap, eyemap, shufflemap, numrandom )
  %
  %   score     : an array of score of each eye fixation
  %   salmap    : saliency map. will be resized nearest neighbour to eyemap
  %   eyemap    : should be a binary map of eye fixation
  %   shufflemap: other image's eye fixation, if undefined will give all
  %               white (all white/ones will be random auc instead)
  %   numrandom : number of random points sampled from shufflemap
  %               default: 100
  %
  % This is a slightly modified version of the AUC calculation script by A. 
  % Borji and L. Itti (for their SaliencyEvaluation) and B. Schauerte and R. 
  % Stiefelhagen.
  %
  % Changes:
  % - treats shuffle map as a real-valued map, instead of boolean one. Note
  % that in some datasets, the shuffle maps can be very dense, and the
  % boolean approximation cannot accurately reflect the true distribution.
  % - avoids the for loop in shuffling.
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
  % @author B. Schauerte
  % @author A. Borji, L. Itti (original implementation, Juli 2011) 
  %        (see https://sites.google.com/site/saliencyevaluation/)
  % @date   2014

  if nargin < 3
      shufMap = true(size(eyeMap));
  end

  if nargin < 4
      numRandom = 100;
  end

  if isempty(shufMap) || max(max(shufMap)) == 0 % its empty or no fixation at all
      shufMap = true(size(eyeMap));
  end

  %%% Resize and normalize saliency map
  salMap = double(imresize(salMap,size(eyeMap),'nearest')); % original implementation
  %salMap = double(imresize(salMap,size(eyeMap),'bicubic'));
  salMap = salMap - min(min(salMap));
  %salMap = salMap / max(max(salMap));
  % this is necessary to be able to to work with empty saliency maps (e.g.,
  % dummy maps or face saliency maps when no face has been found in the
  % image)
  maxSalMap = max(salMap(:));
  if maxSalMap > 0
    salMap = salMap / maxSalMap;
  end
  
  %%% Pick saliency value at each eye fixation along with [numrandom] random points
  localHum = salMap(eyeMap(:) > 0);
  shufMapInd = find(shufMap(:)>0);
  shufTemp = shufMap(shufMapInd);
  
  idx = randp(shufTemp,length(localHum),numRandom);
  idx = shufMapInd(idx(:));
  localRan = salMap(idx);
  localRan = reshape(localRan,length(localHum),[]);

  %%% Calculate AUC score for each eyefix and randpoints
  ac = nan(1,size(localRan,2));
  R  = cell(1,size(localRan,2));
  for ii = 1:size(localRan,2)
      [ac(ii), R{ii}] = auc(localHum, localRan(:, ii));
  end

  score = mean(ac);
end
