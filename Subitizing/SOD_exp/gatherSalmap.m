
salmapDir = fullfile('../SBTDATA/feature/salmap/SO');
for i = 1
    outDir = fullfile('salmap',num2str(i));
    mkdir(outDir);
    D = dir(fullfile('img',num2str(i),'*.jpg'));
    filelist = {D.name};
    for kk = 1:numel(filelist)
        [~,name,~] = fileparts(filelist{kk});
        copyfile(fullfile(salmapDir,[name '_wCtr_Optimized.png']), fullfile(outDir,[name '.png']));
    end
end