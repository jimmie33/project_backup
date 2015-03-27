function [recall,precision,FP,TP,Fb,auc,weightedFb,AE,adtPrecision,adtRecall,adtFb,aAE]...
    =getScores(input_dir,ext,gt_dir,gtext)

D=dir(fullfile(gt_dir,['*' gtext]));
file_list={D.name};
nls=numel(file_list);


thresh=[1.0:-0.05:0 0];

precision=zeros(nls,size(thresh,2));
recall=zeros(nls,size(thresh,2));
FP=zeros(nls,size(thresh,2));
TP=zeros(nls,size(thresh,2));
Fb = zeros(nls,size(thresh,2));
weightedFb = zeros(nls,1);
AE = zeros(nls,1);
aAE = zeros(nls,size(thresh,2));
adtPrecision = zeros(nls,1);
adtRecall = zeros(nls,1);
adtFb = zeros(nls,1);

for i=1:nls
%    disp(i)
   [gt map]=imread(fullfile(gt_dir,file_list{i}));
   if ~isempty(map)
       gt = (ind2gray(gt,map)); % the color map could be different
   end
   gt = double(gt);
   gt=gt./max(max(gt(:)),eps);
   gt=double(gt(:,:,1)>0.5);

   [sm map]=imread(fullfile(input_dir,strcat(file_list{i}(1:end-4),ext)));
   if ~isempty(map)
       sm = (ind2gray(sm,map));
   end
   sm = double(sm);
   
   sm=imresize(sm,size(gt));
   sm=sm(:,:,1);
   sm=sm-min(min(sm));
   if max(sm(:)) > 0
       sm=sm/(max(max(sm)));
   end

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
       aAE(i,j) = mean(abs(bm(:)-gt(:)));
   end
   Fb(i,:)=(1+0.3).*precision(i,:).*recall(i,:)./(0.3*precision(i,:)+recall(i,:)+eps);
   weightedFb(i) = WFb(sm,gt>0);
   AE(i) = mean(abs(sm(:)-double(gt(:))));
   
   adtThresh = 2*mean(sm(:));
   bm=sm>=adtThresh;
   tp=bm.*gt; 
   tp=sum(tp(:));% true positive
   adtRecall(i)=tp/max(sum_gt,1);
   bm_sum=sum(bm(:));
   %%
   if bm_sum==0
       adtPrecision(i)=1;
   else
       adtPrecision(i)=tp/bm_sum;%avoid divding by 0
   end
   if (adtPrecision(i) > 0 || adtRecall(i) > 0)
       adtFb(i) = (1+0.3)*adtPrecision(i)*adtRecall(i)/(0.3*adtPrecision(i) + adtRecall(i));
   else
       adtFb(i) = 0;
   end
end

auc = trapz([0,mean(FP,1)],[0,mean(TP,1)]);