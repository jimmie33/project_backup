function [x_idx y_idx] = plotMatrix_score_int(M , x_name, y_name, first_num, x_idx, y_idx)

[d , dd] = size(M);
if (~isempty(x_name) && numel(x_name) ~= dd) || numel(y_name) ~= d
    error('name number and dimension do not match.')
end

first_num = min(numel(y_name),first_num);

% sort the x and y dimension
if ~exist('x_idx','var') || isempty(x_idx)
    [val x_idx] = sort(mean(M(1,:),1),'descend');
end
if ~exist('y_idx','var') || isempty(y_idx)
    [val y_idx] = sort(mean(M,2),'descend');
end

M_sort = M(y_idx(1:first_num),x_idx);
if ~isempty(x_name)
    x_name_sort = x_name(x_idx);
end
y_name_sort = y_name(y_idx(1:first_num));


% std_sort = std(M_sort);
% [val x_idx] = sort(std_sort,'descend');
% x_idx = x_idx(1:30);
% [val idx_tmp] = sort(x_name(x_idx));
% x_idx = x_idx(idx_tmp);
M_sort = M_sort(:,x_idx);


h             =  imagesc(M_sort);
axis ij
colormap((gray))


set(gca,'yTick',1:d , 'xTick' , 1:length(x_idx));

cc=get(gca,'YTick');

if ~isempty(x_name)
    set(gca,'XTickLabel',x_name_sort(x_idx));
    aa=get(gca,'XTickLabel');
    bb=get(gca,'XTick');
%     th=text(bb,d*ones(1,length(bb))+0.2,aa,'HorizontalAlignment','left','rotation',50);
%     set(th , 'fontsize' , 10);
end
% set(gca,'XTickLabel',{});
% th=text(bb,zeros(1,length(bb))+0.5,aa,'HorizontalAlignment','left','rotation',50);
set(gca,'yTickLabel',y_name_sort(1:first_num));
set(gca , 'fontsize' , 9);


%h = text(ip1-0.325 , jp1 , num2str(probaR(ind1) , '%3.2f'));

[jj ii] = meshgrid(1:size(M_sort,2),1:size(M_sort,1));
h = text(jj(:) , ii(:) , num2str(M_sort(:) , '%d'),'HorizontalAlignment','center');

set(h , 'fontsize' , 10 , 'color' , [0 0 0])

% %h = text(ip2-0.325 , jp2 , num2str(probaR(ind2) , '%3.2f'));
% h = text(jp2-0.325 , ip2 , num2str(probaR(ind2) , '%3.2f'));
% 
% set(h , 'fontsize' , 8 , 'color' , [ 1 1 1])