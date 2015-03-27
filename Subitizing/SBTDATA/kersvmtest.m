function [score acc] = kersvmtest(model,kernel,label)

[~, acc, score] = lsvmpredict(label', [(1:size(kernel,1))', kernel], model);