function affmtx = getAffMtx(model,data)

affmtx = zeros(numel(model),numel(model));

for i=1:numel(model)
    for j=i+1:numel(model)
       for k = 1:numel(data)
           if i==1
               salfolder1 = 'salmapsExp';
           else
               salfolder1 = 'salmaps';
           end
           D = dir(fullfile(salfolder1,data{k}.name,['output_' model{i}.name],'*.png'));
           file_list_i = {D.name};
           if j==1
               salfolder2 = 'salmapsExp';
           else
               salfolder2 = 'salmaps';
           end
           D = dir(fullfile(salfolder2,data{k}.name,['output_' model{j}.name],'*.png'));
           file_list_j = {D.name};
           
           score = 0;
           for fidx = 1:numel(file_list_i)
               I1 = imread(fullfile(salfolder1,data{k}.name,['output_' model{i}.name],file_list_i{fidx}));
               I2 = imread(fullfile(salfolder2,data{k}.name,['output_' model{j}.name],file_list_i{fidx}));
               
               I1 = im2double(I1(:,:,1));
               I2 = im2double(I2(:,:,1));
               I2 = imresize(I2,[size(I1,1),size(I1,2)]);
           
               score = score + I1(:)'*I2(:)/(norm(I1(:))*norm(I2(:)));
           end
           score = score / numel(file_list_i);
           affmtx(i,j) = affmtx(i,j) + score;
       end
    end
end

for i = 2:numel(model)
    for j = 1:i-1
        affmtx(i,j) = affmtx(j,i);
    end
end