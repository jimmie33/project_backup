function rects = getBBoxOtsu(salmap,n)

salmap = im2double(salmap);
salmap = salmap/max(salmap(:));
thresh = graythresh(salmap);
if nargin < 2
    n = [];
end

res = [];
count = 1;
for i = 1:numel(thresh)
    bw = salmap>thresh(i);
    
    %% original
    S = regionprops(bw,'BoundingBox','Area');
    res(count).bbox = reshape([S.BoundingBox],4,[])';
    aa = (res(count).bbox(:,3).*res(count).bbox(:,4));
    [aa,iid] = sort(aa,'descend');
%     ma = max(aa);
    res(count).bbox = res(count).bbox(iid(aa>10),:);
    res(count).score = getScore(res(count).bbox,salmap,n);
    count = count+1;
    
%     rr=round(sqrt(ma)/4);
%     str = (strel('square',rr));
%     
%     %% opending
%     bw_open = imerode(bw,str);
%     bw_open = imdilate(bw_open,str);
%     S = regionprops(bw_open,'BoundingBox','Area');
%     res(count).bbox = reshape([S.BoundingBox],4,[])';
%     aa = (res(count).bbox(:,3).*res(count).bbox(:,4));
%     ma = max(aa);
%     res(count).bbox = res(count).bbox(aa>ma/16,:);
%     res(count).score = getScore(res(count).bbox,salmap,n);
%     count = count+1;
%     
%     %% closing
%     bw_close = imdilate(bw,str);
%     bw_close = imerode(bw_close,str);
%     S = regionprops(bw_close,'BoundingBox','Area');
%     res(count).bbox = reshape([S.BoundingBox],4,[])';
%     aa = (res(count).bbox(:,3).*res(count).bbox(:,4));
%     ma = max(aa);
%     res(count).bbox = res(count).bbox(aa>ma/16,:);
%     res(count).score = getScore(res(count).bbox,salmap,n);
%     count = count+1;
    
end

[~,idx] = max([res.score]);
rects = res(idx).bbox;



function score = getScore(bbox,salmap,n)

nScore = 1;
% if size(bbox,1)>2
%     nScore = 0;
% end

if ~isempty(n) && n==1 && size(bbox,1) > 1
    nScore = 1- abs(n-size(bbox,1));
end

% if ~isempty(n) && n==4 && max((4-size(bbox,1)),0)>1
%     nScore = 1-max((4-size(bbox,1)),0);
% elseif ~isempty(n) && n~=size(bbox,1) && abs(n-size(bbox,1)) > 1
%     nScore = 1-abs(n-size(bbox,1));
% end

cover = zeros(size(salmap));
compactScore = 0;
for i = 1:size(bbox,1)
    bb = round(bbox(i,:));
    cover(bb(2):(bb(4)+bb(2)-1),bb(1):(bb(3)+bb(1)-1))=1;
    cc = salmap(bb(2):(bb(4)+bb(2)-1),bb(1):(bb(3)+bb(1)-1));
    compactScore = compactScore + sum(cc(:))/(bb(3)*bb(4));
end

coverScore = sum(salmap(cover(:)>0))/max(sum(salmap(:)),eps);

compactScore = compactScore/size(bbox,1);

score = nScore*0.5+coverScore+0.5*compactScore;%0.5 1 0.5
