function score = llsvmtest(model,feat,label)

[~, acc, score] = predict(label(:), sparse(feat), model, '-q');
if model.Label(1) == 0;
    score = score*-1;
end