load ../result/EFP/paramAnalysis/record_step_dim
A = zeros(3,3);

for i=1:length(A(:))
    A(i) = mean(record{i}.maxauc);
end

A = A(end:-1:1);% x: dim y: step
x_name = {'8' '16' '24'};
y_name = {'400' '300' '200'};

subplot(2,2,1)
plotMatrix_score(reshape(A,3,3),x_name,y_name,3,1:3,1:3);
xlabel('Threshold Sample Step')
ylabel('max(W,H)')
caxis([0.68 max(A(:))])

title('Avg. sAUC')

subplot(2,2,2)
B=[11 20 27; 18 33 44; 42 74 98];
plotMatrix_score_int(B,x_name,y_name,3,1:3,1:3);
caxis([-80 100])
xlabel('Threshold Sample Step')
ylabel('max(W,H)')
title('Speed (FPS)')
