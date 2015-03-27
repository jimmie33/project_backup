function cropConf = genCropConf()

sz = [5,5];
dim = {[5,5],[5,4],[4,5],[4,4],[4,3],[3,4],[3,3],[3,2],[2,3],[2,2]};

cropConf = {};

for i = 1:numel(dim)
    d = dim{i};
    for r = 1:(sz(1)-d(1)+1)
        for c = 1:(sz(2)-d(2)+1)
            roi = [c,r,c+d(2)-1,r+d(1)-1];%xmin ymin xmax ymax
            msk = zeros(sz);
            msk(roi(2):roi(4),roi(1):roi(3)) = 1;
            cropConf{end+1}.roi = roi;
            cropConf{end}.msk = msk;
        end
    end
end