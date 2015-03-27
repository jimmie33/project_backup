model1 = 'BMS_exp_split_labWT';
model2 = 'AWS';

for i = 1:numel(data)
    dir1 = fullfile(data{i}.name,['output_' model1]);
    dir2 = fullfile('../salmaps/',data{i}.name,['output_' model2]);
    targetDir = fullfile(data{i}.name,['output_' model1 '_' model2 '_L2']);
    mkdir(targetDir);
    D = dir(fullfile(dir1,'*.png'));
    file_list = {D.name};
    for idx = 1:numel(file_list)
        I1 = im2double(imread(fullfile(dir1,file_list{idx})));
        I2 = im2double(imread(fullfile(dir2,file_list{idx})));
        I1 = I1(:,:,1);
        I2 = I2(:,:,1);
        I2 = imresize(I2,[size(I1,1) size(I1,2)]);
        I1 = I1/norm(I1(:));
        I2 = I2/norm(I2(:));
        I = I1+I2;
        imwrite(I/max(I(:)),fullfile(targetDir,file_list{idx}))
    end
end