in_dir = './Salmaps/output_exp_robust2';
out_dir = './Salmaps/output_exp_robust2_post2';
mkdir(out_dir);
radius               =   7;
D                    =   dir(fullfile(in_dir,'*.png'));
file_list            =   {D.name};
for i                =   1:numel(file_list)
    I                =   imread(fullfile(in_dir,file_list{i}));
    I                =   postProcSOD(I,radius);
    imwrite(I,fullfile(out_dir,[file_list{i}(1:end-4),'.png']));
end