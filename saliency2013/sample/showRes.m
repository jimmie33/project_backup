configModel
configData
ndisplay = 30;

for i = 1:numel(data)
%     figure
    load(data{i}.name);
    saveDir_pos = fullfile('pos/',data{i}.name);
    saveDir_neg = fullfile('neg/',data{i}.name);
    saveDir_hard = fullfile('hard/',data{i}.name);
    mkdir(saveDir_pos);
    mkdir(saveDir_neg);
    mkdir(saveDir_hard);
    
    %% pos
    diff = score(:,end)-max(score(:,1:end-1),[],2);
    [~, idx] = sort(diff,'descend');
    load(fullfile('../GT/',[data{i}.name '_GT']))
    count = 1;
    
    for j = 1:ndisplay
        filename = fixMaps{idx(j)}.srcName;
        [~,nn,~]=fileparts(filename);
%         subplot(ndisplay,numel(model)+1,count)
        I = imread(fullfile('../data',data{i}.name,'src',filename));
        I = imresize(I,[nan 400]);
        sz = size(I);
        sz = sz(1:2);
        imwrite(I,fullfile(saveDir_pos,filename));
        
        gt = double(full(fixMaps{idx(j)}.fixMap)>0);
        gt = imfilter(gt,fspecial('gaussian',600,20),'replicate');
        gt = imresize(gt,sz);
        gt = gt/max(gt(:));
        imwrite(gt*255,jet(256),fullfile(saveDir_pos,[nn 'GT.png']));
%         imshow(I);
        count = count+1;
        for k = 1:numel(model)
            if k~=numel(model)
                I = imread(fullfile('../salmaps/',data{i}.name,...
                    ['output_' model{k}.name],[nn '.png']));
                saveName = [nn '_' model{k}.name '_' ...
                    sprintf('%f',score(idx(j),k)) '.png'];
                I = double(imresize(I,sz));
                I = I/max(I(:));
                imwrite(I*255,jet(256),fullfile(saveDir_pos,saveName));
            else
                I = imread(fullfile('../salmapsExp/',data{i}.name,...
                    ['output_' model{k}.name],[nn '.png']));
                saveName = [nn '_' model{k}.name '_' ...
                    sprintf('%f',score(idx(j),k)) '_' sprintf('%f',diff(idx(j))) '.png'];
                I = double(imresize(I,sz));
                I = I/max(I(:));
                imwrite(I*255,jet(256),fullfile(saveDir_pos,saveName));
            end
            
%             subplot(ndisplay,numel(model)+1,count)
%             imshow(I)
            count = count+1;
        end
    end
    
    
    %% neg
    diff = score(:,end)-mean(score(:,1:end-1),2);
    [~, idx] = sort(diff,'ascend');
    count = 1;
    
    for j = 1:ndisplay
        filename = fixMaps{idx(j)}.srcName;
        [~,nn,~]=fileparts(filename);
%         subplot(ndisplay,numel(model)+1,count)
        I = imread(fullfile('../data',data{i}.name,'src',filename));
        I = imresize(I,[nan 400]);
        sz = size(I);
        sz = sz(1:2);
        imwrite(I,fullfile(saveDir_neg,filename));
        
        gt = double(full(fixMaps{idx(j)}.fixMap)>0);
        gt = imfilter(gt,fspecial('gaussian',600,20),'replicate');
        gt = imresize(gt,sz);
        gt = gt/max(gt(:));
        imwrite(gt*255,jet(256),fullfile(saveDir_neg,[nn 'GT.png']));
%         imshow(I);
        count = count+1;
        for k = 1:numel(model)
            if k~=numel(model)
                I = imread(fullfile('../salmaps/',data{i}.name,...
                    ['output_' model{k}.name],[nn '.png']));
                saveName = [nn '_' model{k}.name '_' ...
                    sprintf('%f',score(idx(j),k)) '.png'];
                I = double(imresize(I,sz));
                I = I/max(I(:));
                imwrite(I*255,jet(256),fullfile(saveDir_neg,saveName));
            else
                I = imread(fullfile('../salmapsExp/',data{i}.name,...
                    ['output_' model{k}.name],[nn '.png']));
                saveName = [nn '_' model{k}.name '_' ...
                    sprintf('%f',score(idx(j),k)) '_' sprintf('%f',diff(idx(j))) '.png'];
                I = double(imresize(I,sz));
                I = I/max(I(:));
                imwrite(I*255,jet(256),fullfile(saveDir_neg,saveName));
            end
            
%             subplot(ndisplay,numel(model)+1,count)
%             imshow(I)
            count = count+1;
        end
    end
    
    %% hard
    diff = score(:,end)-max(score(:,1:end-1),[],2);
    [~, idx] = sort(max(score,[],2),'ascend');
    count = 1;
    
    for j = 1:ndisplay
        filename = fixMaps{idx(j)}.srcName;
        [~,nn,~]=fileparts(filename);
%         subplot(ndisplay,numel(model)+1,count)
        I = imread(fullfile('../data',data{i}.name,'src',filename));
        I = imresize(I,[nan 400]);
        sz = size(I);
        sz = sz(1:2);
        imwrite(I,fullfile(saveDir_hard,filename));
        
        gt = double(full(fixMaps{idx(j)}.fixMap)>0);
        gt = imfilter(gt,fspecial('gaussian',600,20),'replicate');
        gt = imresize(gt,sz);
        gt = gt/max(gt(:));
        imwrite(gt*255,jet(256),fullfile(saveDir_hard,[nn 'GT.png']));
%         imshow(I);
        count = count+1;
        for k = 1:numel(model)
            if k~=numel(model)
                I = imread(fullfile('../salmaps/',data{i}.name,...
                    ['output_' model{k}.name],[nn '.png']));
                saveName = [nn '_' model{k}.name '_' ...
                    sprintf('%f',score(idx(j),k)) '.png'];
                I = double(imresize(I,sz));
                I = I/max(I(:));
                imwrite(I,fullfile(saveDir_hard,saveName));
            else
                I = imread(fullfile('../salmapsExp/',data{i}.name,...
                    ['output_' model{k}.name],[nn '.png']));
                saveName = [nn '_' model{k}.name '_' ...
                    sprintf('%f',score(idx(j),k)) '_' sprintf('%f',diff(idx(j))) '.png'];
                I = double(imresize(I,sz));
                I = I/max(I(:));
                imwrite(I,fullfile(saveDir_hard,saveName));
            end
            
%             subplot(ndisplay,numel(model)+1,count)
%             imshow(I)
            count = count+1;
        end
    end
end