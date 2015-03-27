function evaluate_rehi
full = 0;
vis = 0;
w_scale = 1.0; % for rescaling the output windows (0.7 for pets,1.0 for TC)
h_scale = 1.0;

output_dir = './';
% Vid_path = 'C:/Users/jimmie/Downloads/video_data/S2_L2.tar/Crowd_PETS09/S2/L2/Time_14-55/View_001/';
seqs = {
        'tud_stadtmitte',...
        'tud_crossing',...
        'tud_campus',...
        'S2L1',...
        'S2L2',...
        'S2L3',...        
        'oxford'
        };
% full = 1;
% seqs = {'S2L1',...
%         'S2L2',...
%         'S2L3'};
% seqs = {'oxford-2'};
for s = 1:length(seqs),
    seq = seqs{s};
    if strcmp(seq,'tud_crossing'),
        t1 = 1;
        t2 = 201;
        load('TUD-crossing','gt_tracks2d');
        [frameNo,ids,xc,yc,w,h] = textread('tud_cross_output.txt');
    elseif strcmp(seq,'tud_stadtmitte'),
        t1 = 7022;
        t2 = 7200;
        load('TUD-Stadtmitte-cropped','gt_tracks2d');
        [frameNo,ids,xc,yc,w,h] = textread('tud_stad_output.txt');
    elseif strcmp(seq,'tud_campus'),
        t1 = 90;
        t2 = 160;
        load('TUD-campus','gt_tracks2d');
        [frameNo,ids,xc,yc,w,h] = textread('tud_campus_output.txt');
    elseif strcmp(seq,'S2L1'),
        t1 = 0;
        t2 = 794;
        if full,
            load('gt/PETS2009-S2L1','gt_tracks2d');
            [frameNo,ids,xc,yc,w,h] = textread('./rehi/S2L1_output_all.txt');
        else
            w_scale = 0.7;
            load('PETS2009-S2L1-cropped','gt_tracks2d');
            load('Andriyenko_1_S1','ROI');
            [frameNo,ids,xc,yc,w,h] = textread(fullfile(output_dir,'S2L1_output.txt'));
        end
    elseif strcmp(seq,'S2L2'),
        t1 = 0;
        t2 = 435;
        if full,
            load('gt/PETS2009-S2L2','gt_tracks2d');
            [frameNo,ids,xc,yc,w,h] = textread('./rehi/S2L2_output_all.txt');
        else
            w_scale = 0.7;
            load('PETS2009-S2L2-cropped','gt_tracks2d');
            load('Andriyenko_1_S1','ROI');            
            [frameNo,ids,xc,yc,w,h] = textread(fullfile(output_dir,'S2L2_output.txt'));
        end
    elseif strcmp(seq,'S2L3'),
        t1 = 0;
        t2 = 239;
        if full,
            load('gt/PETS2009-S2L3','gt_tracks2d');
            [frameNo,ids,xc,yc,w,h] = textread('./rehi/S2L3_output_all.txt');
        else
            w_scale = 0.7;
            load('PETS2009-S2L3-cropped','gt_tracks2d');
            load('Andriyenko_1_S1','ROI');            
            [frameNo,ids,xc,yc,w,h] = textread(fullfile(output_dir,'S2L3_output.txt'));
        end
    elseif strcmp(seq,'oxford'),
        % bug, visualization indicates shift is wrong
        w_scale = 1.0;
        t1 = 0;
        t2 = 4500;
        load('oxford-towncenter','gt_tracks2d');
        [frameNo,ids,xc,yc,w,h] = textread(fullfile(output_dir,'TownCentreXVID_output.txt'));
        idx = frameNo<4500; 
        frameNo = frameNo(idx);
        ids = ids(idx);
        xc = xc(idx);
        yc = yc(idx);
        w = w(idx);
        h = h(idx);
    elseif strcmp(seq,'oxford-2'),
        t1 = 0;
        t2 = 4500;
        load('gt/oxford-towncenter-full','gt_tracks2d');
        [ids, frameNo, hValid, bValid, hLeft, hTop, hRight, hBottom, bLeft, bTop, bRight, bBottom] = ...
            textread('../oxford/TownCentre-output-BenfoldReidCVPR2011.top','%08d,%d,%d,%d,%f,%f,%f,%f,%f,%f,%f,%f');
%         [frameNo,ids,xc,yc,w,h] = textread('../oxford/TownCentre-output-BenfoldReidCVPR2011.top');
        ind = find(frameNo>=0&frameNo<=4500);
        ids = ids(ind);
        frameNo = frameNo(ind)+1;
        bTop = bTop(ind);
        bRight = bRight(ind);
        bBottom = bBottom(ind);
        bLeft = bLeft(ind);
        h = (bBottom-bTop);
        w = (bRight-bLeft);
        xc = (bRight+bLeft)/2;
        yc = (bBottom+bTop)/2;
    end
    


    sys_tracks2d = {};
    while ~isempty(ids),
        id = ids(1);
        if strcmp(seq,'oxford-2'),
            start_t = frameNo(1);
        else
            start_t = frameNo(1)+t1;
        end
        ind = find(ids==id);
        gw = w(ind);
        gh = h(ind);
        sys_tracks2d{end+1,1} = [id,start_t];
        sys_tracks2d{end,2} = [yc(ind)-h_scale*gh/2,xc(ind)-w_scale*gw/2,yc(ind)+h_scale*gh/2,xc(ind)+w_scale*gw/2,frameNo(ind)];
        frameNo = frameNo(ids~=id);
        h = h(ids~=id);
        w = w(ids~=id);
        xc = xc(ids~=id);
        yc = yc(ids~=id);
        ids = ids(ids~=id);
    end
    % interpolatation
    sys_tracks2d = interpolate(sys_tracks2d);
    
%     if strcmp(seq,'oxford'),
%         sys_tracks2d = scaleCorrection(sys_tracks2d,0.8,3);
%     end
    if full==0&&(strcmp(seq,'S2L1')||strcmp(seq,'S2L2')||strcmp(seq,'S2L3')),
        sys_tracks2d = cutting(sys_tracks2d,ROI);
        sys_tracks2d = interpolate(sys_tracks2d);
    end
    if strcmp(seq,'tud_stadtmitte'),
        sys_tracks2d(6,:) = [];
    end
    
    
%     for n = 1:size(sys_tracks2d,1),
%         rec = sys_tracks2d{n,2};
%         yx1 = rec(:,1:2);
%         xsmooth1 = evalProb2(yx1');
%         yx2 = rec(:,3:4);
%         xsmooth2 = evalProb2(yx2');
%         sys_tracks2d{n,2} = [xsmooth1(:,1:2),xsmooth2(:,1:2)];
%     end
    fprintf('%s: rehi\n',seq); 
    % visualization
    if vis,
%         k = 1;
        numframes = t2;
        for i = 0:numframes-1,
            if strcmp(seq,'tud_crossing'),
                nm = sprintf('../tud_crossing/tud-crossing-sequence/DaSide0811-seq7-%03d.png',i+t1);
            elseif strcmp(seq,'tud_stadtmitte'),
                nm = sprintf('../tud_stadtmitte/tud_stadtmitte/DaMultiview-seq%04d.png',i+t1);         
            elseif strcmp(seq,'tud_campus'),
                nm = sprintf('../tud_campus/tud-campus-sequence/DaSide0811-seq6-%03d.png',i+t1); 
            elseif strcmp(seq,'oxford')||strcmp(seq,'oxford-2'),
                nm = sprintf('K:/Towncenter_temp/%04d.png',i+t1+1);
            elseif strcmp(seq,'S2L1'),
                nm = sprintf([Vid_path,'frame_%04d.jpg'],i+t1);
            elseif strcmp(seq,'S2L2'),
                nm = sprintf([Vid_path,'frame_%04d.jpg'],i+t1);
            elseif strcmp(seq,'S2L3'),
                nm = sprintf('../S2_L3/View_001/frame_%04d.jpg',i+t1);
            end
            I = imread(nm); 
%             I(ROI==0)=0.5*I(ROI==0);
            imshow(I); 
            hold on;
            for k = 1:size(sys_tracks2d,1);
                track = sys_tracks2d{k,2};
                track = track(track(:,end)==i,:);
                if size(track,1) == 1
                    x = [track(2),track(4),track(4),track(2),track(2)];
                    y = [track(1),track(1),track(3),track(3),track(1)];
                    plot(x,y,'r');
                    text(0.5*(track(2)+track(4)),track(1)-5,num2str(k),'Color','g');
                end
            end
            for k = 1:size(gt_tracks2d,1);
                track = gt_tracks2d{k,2};
                info = gt_tracks2d{k,1};
                track = track(info(2):info(2)+size(track,1)-1==i,:);
                if size(track,1) == 1
                    x = [track(2),track(4),track(4),track(2),track(2)];
                    y = [track(1),track(1),track(3),track(3),track(1)];
                    plot(x,y,'g');
                    text(0.5*(track(2)+track(4)),track(1)-5,num2str(info(1)),'Color','g');
                end
            end
            hold off;
            drawnow;
        end
    end
    
    
    
    
%     CLEAR_Metric3(sys_tracks2d,gt_tracks2d,0.5,t1,t2,0);
    [gtInfo,stateInfo] = convertFormat(gt_tracks2d,sys_tracks2d,t1:t2);
    [metrics metricsInfo]=CLEAR_MOT(gtInfo,stateInfo);
    printMetrics(metrics,metricsInfo,1);
end

function sys_tracks_2d = cutting(sys_tracks_2d,ROI)

new_tracks = {};
for n = 1:size(sys_tracks_2d,1),
    rec = sys_tracks_2d{n,2};
    info = sys_tracks_2d{n,1};
    cutoff = zeros(size(rec,1),1);
    for tt = 1:size(rec,1),
        yt = rec(tt,3);
        xt = 0.5*(rec(tt,2)+rec(tt,4));%bug
        yt = max(1,min(round(yt),size(ROI,1)));
        xt = max(1,min(round(xt),size(ROI,2)));
        if ROI(yt,xt)==1,
            cutoff(tt) = 1;
        end
    end
    % split the trajectory after exiting the scene
    cutoff = medfilt1(cutoff,7);
    t_pointer = 1;
    tracking = true;
    if cutoff(1) == 0
        tracking = false;
    end
    for tt = 1:size(cutoff,1)
        if (cutoff(tt) == 0 || tt == size(cutoff,1)) && tracking % complete one trajectory
            new_tracks{end+1,1} = [size(new_tracks,1)+1, info(2)+t_pointer-1];
            new_tracks{end,2} = rec(t_pointer:tt-(cutoff(tt)==0),:);
            tracking = false;
        elseif ~tracking && cutoff(tt) == 1
            if tt == size(cutoff,1)
                warning('split trajectory: possibly lose one window.')
            end
            t_pointer = tt;
            tracking = true;
        end
    end
end
sys_tracks_2d = new_tracks;

function sys_tracks_2d = interpolate(sys_tracks_2d)

for n = 1:size(sys_tracks_2d,1),
    rec = sys_tracks_2d{n,2};
    frames = rec(:,end);
    if frames(end)-frames(1)+1 ~= size(rec,1),
        y1 = rec(:,1);
        y2 = rec(:,3);
        x1 = rec(:,2);
        x2 = rec(:,4);
        t = rec(:,5);
        ts = (t(1):t(end))';
        tt = setdiff(ts,t);
        yy1 = [y1;interp1(t,y1,tt)];
        yy2 = [y2;interp1(t,y2,tt)];
        xx1 = [x1;interp1(t,x1,tt)];
        xx2 = [x2;interp1(t,x2,tt)];
        [~,ind] = sort([t;tt]);

        newrec = [yy1(ind),xx1(ind),yy2(ind),xx2(ind),ts];
        sys_tracks_2d{n,2} = newrec;
    end
end