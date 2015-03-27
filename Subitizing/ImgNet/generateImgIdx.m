addpath(genpath('ILSVRC2014_devkit'));
xml_anno_dir = 'ILSVRC2012_xml_anno/val';
img_dir = 'ILSVRC2012_img/val';
img_idx_dir = 'ILSVRC2012_imgIdx/val';

if ~exist(img_idx_dir,'dir')
 mkdir(img_idx_dir)
end

D = dir(fullfile(xml_anno_dir, 'n*'));
class_list = {D.name};

for i = 1:numel(class_list)
   fprintf('Processing %s (%d/%d)...', class_list{i}, i, numel(class_list));
   if exist(fullfile(img_idx_dir,[class_list{i} '.mat']),'file')
      fprintf('skip\n');
      continue;
   end
   D = dir(fullfile(xml_anno_dir,class_list{i},'*.xml'));
   file_list = {D.name};
   imgIdx = [];
   for j = 1:numel(file_list)
      rec = VOCreadxml(fullfile(xml_anno_dir,class_list{i},file_list{j}));
      rec = rec.annotation;
      
      imgIdx(j).name = [rec.filename '.JPEG'];
      imgIdx(j).path = fullfile(pwd,img_dir,class_list{i},[rec.filename '.JPEG']);
      imgIdx(j).nObj = numel(rec.object);
      tmp = zeros(numel(rec.object),4);
      for k = 1:numel(rec.object)
         bbox = rec.object(k).bndbox;
         tmp(k,1) = str2num(bbox.xmin);
         tmp(k,2) = str2num(bbox.ymin);
         tmp(k,3) = str2num(bbox.xmax);
         tmp(k,4) = str2num(bbox.ymax);
      end
      imgIdx(j).anno = tmp;
      imgIdx(j).width = rec.size.width;
      imgIdx(j).height = rec.size.height;
      imgIdx(j).channel = rec.size.depth;
   end 
   save(fullfile(img_idx_dir,class_list{i}),'imgIdx');
   fprintf('done\n')
end