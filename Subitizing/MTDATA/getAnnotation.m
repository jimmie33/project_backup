function anno = getAnnotation(imgIdx, filename)

nCol = 5; % 5 images per task
prefix = 'https://www.einsteinsrazor.com/results/stan/round1/';

fid = fopen(filename);
C = textscan(fid,'%s%s%s%s%s%d%d%d%d%d','Delimiter',',');

nPrefix = numel(prefix);
imgName = {imgIdx.imgName};

anno = nan(numel(C{1})*nCol,1);
for i = 1:nCol
    for j =1:numel(C{i})
        name = C{i}{j}((nPrefix+1):end);
        idx = (strcmp(imgName,name));
        anno(idx) = C{i+nCol}(j);
    end
end

fclose(fid);

