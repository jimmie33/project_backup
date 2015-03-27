function sMap            =   postProcSOD(mAttMap,radius)
% opening by reconstruction followed by closing by reconstruction
% see the following material for detailed explanations 
% http://www.mathworks.com/products/demos/image/watershed/ipexwatershed.html

img_size                 =   size(mAttMap);
I                        =   imresize(mAttMap,[NaN 400]); %  width = 400
se                       =   strel('disk',radius);
Ie                       =   imerode(I, se);
Iobr                     =   imreconstruct(Ie, I);
Iobrd                    =   imdilate(Iobr, se);
Iobrcbr                  =   imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
Iobrcbr                  =   imcomplement(Iobrcbr);
sMap                     =   imresize(mat2gray(Iobrcbr),img_size(1:2));

end