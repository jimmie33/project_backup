function [gtInfo,stateInfo] = convertFormat(gt_tracks2d,sys_tracks2d,frameNums)
t1 = frameNums(1);
gtInfo.X = zeros(length(frameNums),size(gt_tracks2d,1));
gtInfo.Y = zeros(length(frameNums),size(gt_tracks2d,1));
gtInfo.W = zeros(length(frameNums),size(gt_tracks2d,1));
gtInfo.H = zeros(length(frameNums),size(gt_tracks2d,1));
gtInfo.frameNums = frameNums;

stateInfo.X = zeros(length(frameNums),size(sys_tracks2d,1));
stateInfo.Y = zeros(length(frameNums),size(sys_tracks2d,1));
stateInfo.Xi = zeros(length(frameNums),size(sys_tracks2d,1));
stateInfo.Yi = zeros(length(frameNums),size(sys_tracks2d,1));
stateInfo.W = zeros(length(frameNums),size(sys_tracks2d,1));
stateInfo.H = zeros(length(frameNums),size(sys_tracks2d,1));
stateInfo.frameNums = frameNums;
stateInfo.F = length(frameNums);

for n = 1:size(gt_tracks2d,1),
    ts = gt_tracks2d{n,1}(2);
    rec = gt_tracks2d{n,2};
    te = ts+size(rec,1)-1;
    gtInfo.X(ts-t1+1:te-t1+1,n) = (rec(:,2)+rec(:,4))/2;
    gtInfo.Y(ts-t1+1:te-t1+1,n) = rec(:,3);
    gtInfo.W(ts-t1+1:te-t1+1,n) = rec(:,4)-rec(:,2);
    gtInfo.H(ts-t1+1:te-t1+1,n) = rec(:,3)-rec(:,1);
end

for n = 1:size(sys_tracks2d,1),
    ts = sys_tracks2d{n,1}(2);
    rec = sys_tracks2d{n,2};
    te = ts+size(rec,1)-1;
    stateInfo.Xi(ts-t1+1:te-t1+1,n) = (rec(:,2)+rec(:,4))/2;
    stateInfo.Yi(ts-t1+1:te-t1+1,n) = rec(:,3);
    stateInfo.X(ts-t1+1:te-t1+1,n) = (rec(:,2)+rec(:,4))/2;
    stateInfo.Y(ts-t1+1:te-t1+1,n) = rec(:,3);
    stateInfo.W(ts-t1+1:te-t1+1,n) = rec(:,4)-rec(:,2);
    stateInfo.H(ts-t1+1:te-t1+1,n) = rec(:,3)-rec(:,1);
end