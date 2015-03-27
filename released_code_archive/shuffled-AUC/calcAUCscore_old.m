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
  % Borji and L. Itti (for their SaliencyEvaluation).
  %
  % Changes:
  % - protection against division by zero
  %
  % If you use any of this work in scientific research or as part of a larger 
  % software system, you are kindly requested to cite the use in any related 
  % publications or technical documentation. The work is based upon:
  %
  %   B. Schauerte, and R. Stiefelhagen, "Quaternion-based Spectral Saliency
  %   Detection for Eye Fixation Prediction," in 12th European Conference on 
  %   Computer Vision (ECCV), 2012.
  %
  %   B. Schauerte, and R. Stiefelhagen, "Predicting Human Gaze using 
  %   Quaternion DCT Image Signature Saliency and Face Detection," in IEEE 
  %   Workshop on the Applications of Computer Vision (WACV), 2012.
  %
  % @author B. Schauerte
  % @author A. Borji, L. Itti (original implementation, Juli 2011) 
  %        (see https://sites.google.com/site/saliencyevaluation/)
  % @date   2011

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
  if max(max(salMap)) > 0
    salMap = salMap / max(max(salMap));
  end
  
  %%% Pick saliency value at each eye fixation along with [numrandom] random points
  [X Y] = find(eyeMap > 0);
  [XRest YRest] = find(shufMap > 0);
  localHum = nan(length(X),1);
  localRan = nan(length(X),numRandom);
  for k=1:length(X)
      localHum(k,1) = salMap(X(k),Y(k));
      for kk=1:numRandom
          r = randi([1 length(XRest)],1);
          localRan(k,kk) = salMap(XRest(r),YRest(r));
      end
  end

  %%% Calculate AUC score for each eyefix and randpoints
  ac = nan(1,size(localRan,2));
  R  = cell(1,size(localRan,2));
  for ii = 1:size(localRan,2)
      [ac(ii), R{ii}] = auc(localHum, localRan(:, ii));
  end
  score = ac;
end
