function arffwrite(fileName,dataName,data)
% ARFFWRITE  Writes the file as a arff formatted file.
%          
% USAGE:
%       arffWrite(fileName,dataName,attributeName,attributeType,data);
%
% INPUT:    
%       fileName:       file name for writing data      
%       dataName:       relation name for arff file
%       attributeName:  attribute name for each variable { 1 by nAttr}
%       attributeType:  data type for each attribute { 1 by nAttr}
%       data:      		data for writing arff formatted(nInstan by nAttr)
%       
% See also ARFFREAD            

% Copyright 2004-2004 by Durga Lal Shrestha.
% eMail: durgals@hotmail.com
% $Date: 2004/06/23 
% $Revision: 3.2.0 $ $Date: 2004/08/16 $ 

% ***********************************************************************
% Check for input data
% if nargin < 5,
% 	error('Too few input arguments!');
% end
% if nargin > 5,
% 	error('Too many input arguments!');
% end	
nAttribute = size(data,2);
nVar = size(data,2);
nVarType= size(data,2);
if nAttribute ~= nVar | nAttribute ~=nVarType
	error('dimensions (column) of data must agree with number of varible name or type!');
end
% first check for heading
format = [];
for i=1:nAttribute-1
   format = [format ' %6.4e'];
end
format = [format ' %d\n'];
%-------------------------------
fid = fopen(fileName,'w');          % open the file if exists otherwise create new
%-------------------------------

% Writing headings in the arff file format.
fprintf(fid,'%s %s\n','@relation',dataName);
for i=1:nAttribute-1
    fprintf(fid,'%s %s %s\n' ,'@attribute' ,num2str(i) ,'NUMERIC' );
end
label = data(:,end);
ma = max(label);
mb = min(label);
cstr = '{';
for kk = mb:ma
    cstr = [cstr, num2str(kk),','];
end
cstr(end)='}';
fprintf(fid,'%s %s %s\n' ,'@attribute' ,'class' ,cstr );
fprintf(fid,'%s\n','@data');
%-------------------------------

% Data are space delimeted matrix
fprintf(fid,format,data');
fclose(fid);
