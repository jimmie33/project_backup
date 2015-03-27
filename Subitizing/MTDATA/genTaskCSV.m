function genTaskCSV(imgList,nBatch,nCol,imgnamePrefix,header,example,outputDir)


for i = 1:nBatch
    ridx = randperm(numel(imgList));
    fid = fopen(fullfile(outputDir,[num2str(i) '.csv']),'w');
    for j = 1:numel(header)
        fprintf(fid,'%s,',header{j});
    end
    fprintf(fid,'example\n');
    for j = 1:numel(ridx)
        fprintf(fid,'%s%s,',imgnamePrefix,imgList(ridx(j)).imgName);
        if mod(j,nCol)==0
            fprintf(fid,'%s\n',example);
        end
    end
    fclose(fid);
end

