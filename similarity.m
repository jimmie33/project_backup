
% Tilke Judd
% Feb 2011
% similarity finds the similarity between two different saliency maps
% s=1 means the maps are identical
% s=0 means the maps are completely opposite

function s = similarity(map1orig, map2orig)

[w, h, c] = size(map1orig);

% resize map1 and map2 to smaller size
% longest edge is length 200px.
if w > h
    map1 = imresize(map1orig, [200, NaN]);
    map2 = imresize(map2orig, [200, NaN]);
else
    map1 = imresize(map1orig, [NaN, 200]);
    map2 = imresize(map2orig, [NaN, 200]);
end

map1 = im2double(map1);
map2 = im2double(map2);

% normalize the values to be between 0-1
if max(map1(:))==0 && min(map1(:))==0 % to avoid dividing by zero if zero image
    map1(100, 100)=1;
else
    map1= (map1-min(map1(:)))/(max(map1(:))-min(map1(:)));
end

if max(map2(:))==0 && min(map2(:))==0
    map2(100, 100)=1;
else
    map2= (map2-min(map2(:)))/(max(map2(:))-min(map2(:)));
end

% make sure map1 and map2 sum to 1
map1 = map1/sum(map1(:));
map2 = map2/sum(map2(:));

assert(min(map1(:))>=0)
assert(min(map2(:))>=0)
assert(abs(1-sum(map1(:)))<0.001)
assert(abs(1-sum(map2(:)))<0.001)

diff = min(map1, map2);
s = sum(diff(:));

% if you'd like to see visual output, change this if statement to 1
if 0
    subplot(131); imshow(map1, []);
    subplot(132); imshow(map2, []);
    subplot(133); imshow(diff, []);
    title(['Similar parts = ', num2str(s)]);
    pause;
end