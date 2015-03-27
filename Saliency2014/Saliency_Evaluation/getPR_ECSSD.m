function [recall,precision,FP,TP,weightedFb]=getPR_ECSSD(input_dir,ext,blobMap)

if nargin < 3
    blobMap = [];
end

if isempty(blobMap) && isempty(input_dir)
    return
end

gt_dir='GT\ECSSD\';
D=dir(fullfile(gt_dir,'*.png'));
file_list={D.name};
nls=numel(file_list);


thresh=[255:-20:0 0];

precision=zeros(nls,size(thresh,2));
recall=zeros(nls,size(thresh,2));
FP=zeros(nls,size(thresh,2));
TP=zeros(nls,size(thresh,2));
weightedFb = zeros(nls,1);

for i=1:nls
   disp(i)
   gt=double(imread(strcat(gt_dir,file_list{i})));
   gt=gt(:,:,1)>0;
   
   if ~isempty(input_dir)
      sm=double(imread(fullfile(input_dir,strcat(file_list{i}(1:end-4),ext))));
   else
      sm=blobMap;
   end

   sm=imresize(sm,size(gt));
   sm=sm(:,:,1);
   sm=sm-min(min(sm));
   sm=sm/(max(max(sm)));
   if ~isempty(input_dir) && ~isempty(blobMap)
       sm = sm .* imresize(blobMap,size(sm));
       sm=sm-min(min(sm));
       sm=sm/(max(max(sm)));
   end
   
   sm=255*sm;
   sum_gt=sum(gt(:));
   for j=1:size(thresh,2)
       bm=sm>=thresh(j);
       tp=bm.*gt; 
       tp=sum(tp(:));% true positive
       recall(i,j)=tp/max(sum_gt,1);
       bm_sum=sum(bm(:));
       %%
       if bm_sum==0
           precision(i,j)=1;
       else
           precision(i,j)=tp/bm_sum;%avoid divding by 0
       end
       %%
       TP(i,j)=tp/max(sum_gt,0.1);
       FP(i,j)=(bm_sum-tp)/max(length(gt(:))-sum_gt,0.1);
   end
   weightedFb(i) = WFb(sm./255,gt);
end
% precision=precision./nls;
% recall=recall./nls;
end