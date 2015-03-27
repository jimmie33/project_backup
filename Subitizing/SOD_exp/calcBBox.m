load imgList_SED1
salDir = 'salmap/SED1/output_SO';
load CNN_SalCNN_Sal_pca250_score
filelist = {D.name};
decscore = SED1score;

SED1RectList = cell(numel(filelist),1);
for i = 1:numel(filelist)
    I = imread(fullfile(salDir,filelist{i}));
    if decscore(i,2)>decscore(i,3) %& decscore(i,2)>0
        SED1RectList{i} = getBBox(I);
    else
        SED1RectList{i} = getBBox(I);
    end
end
%%
load imgList_SED2
salDir = 'salmap/SED2/output_SO';
filelist = {D.name};
decscore = SED2score;

SED2RectList = cell(numel(filelist),1);
for i = 1:numel(filelist)
    I = imread(fullfile(salDir,filelist{i}));
    if decscore(i,2)>decscore(i,3) %& decscore(i,2)>0
        SED2RectList{i} = getBBox(I);
    else
        SED2RectList{i} = getBBox(I);
    end
end
%%
save('results/rectList_auto','SED1RectList','SED2RectList');
