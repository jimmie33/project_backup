function model = llsvmtrain(feat,label,C)

w0 = 2*sum(label == 1)/numel(label);
w1 = 2*sum(label == 0)/numel(label);
    
model = train(label(:), sparse(feat), sprintf('-c %f -B 1 -w0 %f -w1 %f -q', C,w0,w1));