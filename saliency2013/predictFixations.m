% Tilke Judd
% Oct 2009

% This measures how well the saliencyMap of an image predicts the ground
% truth human fixations on the image. 
% fixations is a map of zeros with 1s in the locations of fixations

function [areaUnderROC, falseAlarms, precision] = predictFixations(saliencyMap, fixations, jitter)

if nargin<3
    jitter =1;
end

% If there are no fixations to predict, return NaN
if ~any(fixations)
    areaUnderROC=NaN;
    falseAlarms=NaN;
    precision=NaN;
    disp('no fixations');
    return
end 

% make the saliencyMap the size of the image of fixations
% to make sure images are the same size (as when working with reduced imgs)
if size(saliencyMap, 1)~=size(fixations, 1) || size(saliencyMap, 2)~=size(fixations, 2)
    saliencyMap = imresize(saliencyMap, size(fixations));
end

% jitter saliency maps that come from saliency models that have a lot of
% zero values.  If the saliency map is made with a Gaussian then it does 
% not need to be jittered as the values are varied and there is not a large 
% patch of the same value. In fact jittering breaks the ordering 
% in the small values!
if jitter
    % jitter the saliency map slightly to distrupt ties of the same numbers
    saliencyMap = saliencyMap+rand(size(saliencyMap))/10000000;
    saliencyMap = (saliencyMap-min(saliencyMap(:)))/(max(saliencyMap(:))-min(saliencyMap(:)));
end

S = saliencyMap(:);
F = fixations(:);


Sth = S(F>0);
Sth = sort(Sth, 'descend');
Nfixations = length(Sth);
Npixels = length(S);
precision = zeros(Nfixations+1,1);
falseAlarms = zeros(Nfixations+1, 1);
precision(1)=0;
falseAlarms(1)=0;
for i = 1:Nfixations
    aboveth = sum(S>=Sth(i));
    precision(i+1) = i / Nfixations;
    falseAlarms(i+1) = (aboveth-i) / (Npixels - Nfixations);
end
precision(end+1) = 1;
falseAlarms(end+1) = 1;

areaUnderROC = trapz(falseAlarms, precision);


showdetails = 0;
if nargout==0 || showdetails == 1
    subplot(121); imshow(saliencyMap, []); title('SaliencyMap with fixations to be predicted');
    hold on;
    [y, x] = find(fixations);
    plot(x, y, '.r');
    subplot(122); plot(falseAlarms, precision, '.b-');   title(['Area under ROC curve: ', num2str(areaUnderROC)])
    pause;
end
