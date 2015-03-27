function [ac,R,steps] = auc(a,b,plt,n,use_mex)
  %AUC returns the area under the curve by sweeping a threshold through the min
  %  and max values of the entire dataset.  where a is the model to test and b
  %  is the random model to discriminate from.  A score of .5 is a model that
  %  cannot discriminate from the random distribution.
  %
  % This is a slightly modified version of the AUC calculation script by A. 
  % Borji and L. Itti (for their SaliencyEvaluation).
  %
  % Changes:
  % - use of auc_steps_helper.cpp/mex to improve the runtime
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
  % @date 2011

  %steps = .1; % original implementation
  steps = .01; % applied for a more precise evaluation in the WACV'12 paper
  %steps = .001;

  if (nargin < 3)
      plt = 0;
  end
  if (nargin < 4)
      n = 'b';
  end
  if (nargin < 5)
      use_mex = true; % enable/disable the .cpp/mex implementation?
  end

  mx = max([a;b]);
  asteps=0:steps:mx;
  if use_mex
    R=auc_steps_helper(double(a),double(b),double(asteps));
  %  R1=R;
  else
    R = zeros(numel(asteps)+1,2);
    c=1;
    for ii = asteps
        %tp = find((a >= ii) & (b < ii));   
        %fp = find((a >= ii) & (b >= ii));    
        %fp = find( (b >= ii) & ~((b >= ii) & (a >= ii)) );

        tp = find((a >= ii));
        fp = find((b >= ii));
        %R = [R;[length(fp)./length(a) length(tp)./length(a)]];
        R(c,:) = [length(fp)./length(a) length(tp)./length(a)];
        c=c+1;
    end
    %R = [R;[0 0]];
  %  R2=R;
  end
  %RDIFF=R1-R2
  ac = trapz(flipdim(R(:,1),1),flipdim(R(:,2),1));
  steps = 0:steps:mx;

  if (plt)
      plotauc(R,n);
  end
