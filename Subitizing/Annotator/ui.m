function varargout = ui(varargin)
% UI MATLAB code for ui.fig
%      UI, by itself, creates a new UI or raises the existing
%      singleton*.
%
%      H = UI returns the handle to a new UI or the handle to
%      the existing singleton*.
%
%      UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UI.M with the given input arguments.
%
%      UI('Property','Value',...) creates a new UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ui

% Last Modified by GUIDE v2.5 29-Sep-2014 23:55:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ui_OpeningFcn, ...
                   'gui_OutputFcn',  @ui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ui is made visible.
function ui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ui (see VARARGIN)

% Choose default command line output for ui
handles.output = hObject;

% Initialize user data
if ~exist(fullfile('tmp','runData.mat'),'file')
    handles.initSuccess = false;
else
    load(fullfile('tmp','runData.mat'));
    handles.initSuccess = true;
    handles.userName = name;
    handles.idxTask = idxTask;
    handles.nTask = nTask;
    handles.imgList = taskImgs;
    handles.imgIdx = 1;
    handles.nImgs = numel(taskImgs);
    handles.param = param;
    handles.anno = nan(handles.nImgs,1);
    handles.prevSel = get(handles.uipanel1,'SelectedObject');
    handles.bgc = get(handles.uipanel1,'BackgroundColor');
    
    set(handles.text1,'String',sprintf('Task %d\n%d/%d',idxTask,handles.nImgs,handles.nImgs));
    [img cmap] = imread(handles.imgList{handles.imgIdx});
    sz = size(img); sz = sz(1:2);
    img = imresize(img,600*sz/max(sz));
    handles.currentImg = img;
    handles.cmap = cmap;
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
if ~handles.initSuccess
    closereq
    errordlg('Initialization failed');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.imgIdx == numel(handles.imgList)
    set(hObject,'String','Complete and Save');
else
    set(hObject,'String','Next');
end

% record the previous result
if handles.imgIdx-1 > 0
    hSel = get(handles.uipanel1,'SelectedObject');
    selStr = get(hSel,'tag');
    selection = nan;
    switch selStr
        case 'sel0'
            selection = 0;    
        case 'sel1'
            selection = 1;
        case 'sel2'
            selection = 2;
        case 'sel3'
            selection = 3;
        case 'sel4'
            selection = 4;
%         case 'sel5'
%             selection = -1;
    end
    handles.anno(handles.imgIdx-1) = selection;
end

if handles.imgIdx > numel(handles.imgList)
    % save result
    anno = handles.anno;
    timestamp = datestr(clock);
    save(fullfile('data',handles.userName,num2str(handles.idxTask)),'anno','timestamp');
    closereq
    msgbox(sprintf('Task %d/%d completed.\nThank you!',handles.idxTask,handles.nTask));
else
    set(hObject,'visible','off');
    set(handles.uipanel1,'visible','off');
    set(handles.text1,'visible','off');
    pause(0.5)
    hdata = imshow(handles.currentImg,handles.cmap);
    pause(handles.param.exposeDuration) %pause
    delete(hdata);
    drawnow
    set(hObject,'visible','on');
    set(handles.uipanel1,'visible','on');
    set(handles.text1,'visible','on');
    
    handles.imgIdx = handles.imgIdx+1;
    set(handles.text1,'String',sprintf('Task %d\n%d/%d',handles.idxTask,...
        handles.nImgs-handles.imgIdx+1,handles.nImgs));
    % Update handles structure
    if handles.imgIdx <= handles.nImgs
        [img cmap] = imread(handles.imgList{handles.imgIdx});
        sz = size(img); sz = sz(1:2);
        img = imresize(img,600*sz/max(sz));
        handles.currentImg = img;
        handles.cmap = cmap;
    end
%     set(handles.pushbutton1,'enable','off');
    guidata(hObject, handles);
end


% --- Executes when selected object is changed in uipanel1.
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel1 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
hsel = get(handles.uipanel1,'SelectedObject');
set(hsel,'backgroundColor',[1 0 0]);
if handles.prevSel ~= hsel
    set(handles.prevSel,'backgroundColor',handles.bgc);
    handles.prevSel = hsel;
end
% set(handles.pushbutton1,'enable','on');
guidata(hObject, handles);
