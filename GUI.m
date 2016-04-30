function [] = GUI()

addpath(genpath('CMF'));
f = figure('units','pixels',...
              'position',[300 600 500 300],...
              'menubar','none',...
              'name','Segmentation GUI',...
              'numbertitle','off',...
              'resize','off');
          
D=guidata(f);  
D.firstFileName = '';
D.firstPathName = '';
D.endFileName = '';
D.endPathName = '';
D.noseedvolume = 0;
D.seedvolume = 0;
guidata(f, D);

buttons = [];

eh1 = uicontrol('Style','edit','Position',[150,260,318,25],'String',D.firstFileName);
eh2 = uicontrol('Style','edit','Position',[150,210,318,25],'String',D.endFileName);

buttons(end+1) = uicontrol('Style','Pushbutton','Position',[50,260,88,30],'Tag','get_f ile','String','Get start file',...
    'BackgroundColor',[0.8,0.8,0.8],'Callback',{@pb_call_getstartfile, f, eh1});
buttons(end+1) = uicontrol('Style','Pushbutton','Position',[50,210,88,30],'Tag','get_f ile','String','Get end file',...
    'BackgroundColor',[0.8,0.8,0.8],'Callback',{@pb_call_getendfile, f, eh2});


vh1 = uicontrol('Style','edit','Position',[48,100,100,25],'String',D.noseedvolume);
vh2 = uicontrol('Style','edit','Position',[348,100,100,25],'String',D.seedvolume);

buttons(end+1) = uicontrol('style','push',...
                 'unit','pix',...
                 'position',[20 20 160 60],...
                 'string','No Seeds Segmentation',...
                 'callback',{@pb_call_noseeds, f, vh1},...
                 'backgroundc',[0.94 .94 .94],...
                 'busyaction','cancel',...% So multiple pushes don't stack.
                 'interrupt','off');
             
buttons(end+1) = uicontrol('style','push',...
                 'unit','pix',...
                 'position',[320 20 160 60],...
                 'string','Seeds Segmentation',...
                 'callback',{@pb_call_seeds, f, vh2},...
                 'backgroundc',[0.94 .94 .94],...
                 'busyaction','cancel',...% So multiple pushes don't stack.
                 'interrupt','off');
             
function [] = pb_call_noseeds(varargin)
% Callback for pushbutton.
h = varargin{1}; % Get the caller's handle.
fh = varargin{3};
fvh = varargin{4};
D = guidata(fh);
col = get(h,'backg');  % Get the background color of the figure.
set(h,'str','Running...','backg',[1 .6 .6]) % Change color of button. 
volume = segmentation(D.firstFileName, D.endFileName, D.firstPathName, D.endPathName, 0);
set(fvh, 'string', num2str(volume));
set(h,'str','No Seeds Segmentation','backg',col)  % Now reset the button features.


function [] = pb_call_seeds(varargin)
% Callback for pushbutton.
h = varargin{1}; % Get the caller's handle.
fh = varargin{3};
fvh = varargin{4};
D = guidata(fh);

col = get(h,'backg');  % Get the background color of the figure.
set(h,'str','Running...','backg',[1 .6 .6]) % Change color of button. 
volume = segmentation(D.firstFileName, D.endFileName, D.firstPathName, D.endPathName, 1);
set(fvh, 'string', num2str(volume));
set(h,'str','Seeds Segmentation','backg',col)  % Now reset the button features.

function [] = pb_call_getstartfile(varargin)
% Callback for pushbutton.

fh = varargin{3}; % Get the caller's handle.
eh = varargin{4};
D=guidata(fh);
roiFolder = ['/home/lei/bin zheng/Breast-MRI/NA001/Date_20050101/'];
defaultname = [roiFolder, '*.dcm'];
[fileName,pathName,~] = uigetfile(defaultname);
D.firstPathName = pathName;
D.firstFileName = fileName;
set(eh , 'string' , fileName);
guidata(fh,D);

function [] = pb_call_getendfile(varargin)
% Callback for pushbutton.

fh = varargin{3}; % Get the caller's handle.
eh = varargin{4};
D=guidata(fh);
roiFolder = ['/home/lei/bin zheng/Breast-MRI/NA001/Date_20050101/'];
defaultname = [roiFolder, '*.dcm'];
[fileName,pathName,~] = uigetfile(defaultname);
D.endPathName = pathName;
D.endFileName = fileName;
set(eh , 'string' , fileName);
guidata(fh,D);