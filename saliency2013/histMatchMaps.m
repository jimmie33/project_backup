% Tilke Judd
% March 2011

function res = histMatchMaps(fixMap, map1)

% find the histogram of the fixation Map
[COUNTS,X] = imhist(fixMap);

% match the map1 hist to the fixation Map hist
res = histoMatch(map1, COUNTS, X);

% display maps and histograms if no output arguments
if nargout == 0
    subplot(231); imshow(fixMap); title(['Fixation map'])
    subplot(232); imshow(map1); title(['Original map'])
    subplot(233); imshow(res); title (['Matched map'])
    subplot(234); imhist(fixMap);
    subplot(235); imhist(map1);
    subplot(236); imhist(res);
    pause;
end