function salmap = MBDPostproc(salmap,centermap)

sz = [size(salmap,1) size(salmap,2)];

salmap = imresize(salmap,300*sz/max(sz));
salmap = im2double(salmap);
orig = salmap;

centermap = imresize(centermap,size(salmap));
salmap = salmap.*centermap;

r = max(floor(sqrt(mean(salmap(:)))*50),3);
salmap = postProcSOD(salmap,r);

%a = mean(salmap(orig>=0.5));
%b = mean(salmap(orig<0.5));
%salmap = 1./(1+exp(-10*(salmap-(a+b)/2)));


salmap = imresize(salmap,sz);
salmap = mat2gray(salmap);

end


function sMap           =   postProcSOD(mAttMap,radius)
% opening by reconstruction followed by closing by reconstruction
% see the following material for detailed explanations 
% http://www.mathworks.com/products/demos/image/watershed/ipexwatershed.html

img_size                =   size(mAttMap);
I                       =   mAttMap; %  width = 400
se                      =   strel('square',radius);
Ie                      =   imerode(I, se);
Iobr                    =   imreconstruct(Ie, I);
Iobrd                   =   imdilate(Iobr, se);
Iobrcbr                 =   imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
Iobrcbr                 =   imcomplement(Iobrcbr);
sMap                    =   imresize(mat2gray(Iobrcbr),img_size(1:2));

end