function model = kersvmtrain(kernel,label,C)

w0 = 2*sum(label == 1)/numel(label);
w1 = 2*sum(label == 0)/numel(label);
model = lsvmtrain(label', [(1:size(kernel,1))', kernel], ...
    sprintf(' -t 4 -c %f -w0 %f -w1 %f', C, w0, w1));