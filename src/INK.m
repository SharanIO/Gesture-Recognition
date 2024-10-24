function varargout = INK(varargin)

%% This is an Interface for capturing digital gesture written for MAE 502
%  Human-Robot Interaction course, Spring 2023 
%  Students are supposed to use this platform as a base for their class
%  project ad HWs. Further improvement of this interface should be done by
%  students.
%
%  ET Esfahani
%  Department of Mechanical and Aerospace Engineering, 
%  University at Buffalo, State University of New York
%%

% INK M-file for INK.fig
%      INK, by itself, creates a new INK or raises the existing
%      singleton*.
%
%      H = INK returns the handle to a new INK or the handle to
%      the existing singleton*.
%
%      INK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INK.M with the given input arguments.
%
%      INK('Property','Value',...) creates a new INK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before INK_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to INK_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help INK

% Last Modified by GUIDE v2.5 19-Mar-2023 17:14:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @INK_OpeningFcn, ...
    'gui_OutputFcn',  @INK_OutputFcn, ...
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


% --- Executes just before INK is made visible.
function INK_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to INK (see VARARGIN)

% Choose default command line output for INK
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes INK wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global ghandles;
global points;
global pID;
global drawing;
global sketchID;

ghandles = handles;
tic
axis([0 1 0 1])
hold on
set(gca,'XTick',[],'Ytick',[],'Box','on')
set(ghandles.pushbutton1,'Enable','off')
set(ghandles.pushbutton2,'Enable','off')
set(gcf,'WindowButtonDownFcn',@mouseDown,'WindowButtonMotionFcn',@mouseMoving,'WindowButtonUpFcn',@mouseUp)

points = zeros(1000,3);
pID = 0;
drawing = 0;
sketchID = 0;
% --- Outputs from this function are returned to the command line.
function varargout = INK_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global points;
global pID;
global sketchID;

cla
points = zeros(1000,3);
pID = 0;
b=0;

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global points;
global pID;
global sketchID;

if pID < 1000
    points(pID+1:end,:)=[];
end
save(['data_' num2str(sketchID)],'points')

function mouseDown(hObject, eventdata, handles)

global ghandles;
global points;
global pID;
global drawing;

cp = get(gca,'CurrentPoint');

if cp(1,1)<1 && cp(1,1)>0 && cp(1,2)<1 && cp(1,2)>0
    drawing = 1;
end


function mouseMoving(hObject, eventdata, handles)
global ghandles;
global points;
global pID;
global drawing;

if drawing
    t = toc;
    cp = get(gca,'CurrentPoint');
    pID = pID + 1;
    points(pID,1) = cp(1,1);
    points(pID,2) = cp(1,2);
    points(pID,3) = t;
    plot(cp(1,1),cp(1,2),'ko')

end


function mouseUp(hObject, eventdata, handles)


global ghandles;
global points;
global pID;
global drawing;
global sketchID;

if drawing
    drawing = 0;
    sketchID = sketchID+1;
end
set(ghandles.pushbutton1,'Enable','on')
set(ghandles.pushbutton2,'Enable','on')


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global points;
global pID;
global sketchID;

[weight,w0]= training();
if pID < 1000
    points(pID+1:end,:)=[];
end
tx = points(:,1);
ty = points(:,2);
ttime = points(:,3);

txmin = min(tx);
tymin = min(ty);
    
txmax = max(tx);
tymax = max(ty);

%feature1
tf1 = (tx(3) - tx(1))/sqrt(((tx(3) - tx(1))^2)+((ty(3) - ty(1))^2));
    
%feature2
tf2 = (ty(3) - ty(1))/sqrt(((tx(3) - tx(1))^2)+((ty(3) - ty(1))^2));
    
%feature3
tf3 = sqrt(((txmax - txmin)^2)+((tymax - tymin)^2));
    
%feature4
tf4 = atan((tymax - tymin)/(txmax - txmin));
    
%feature5
tf5 = sqrt(((tx(end) - tx(1))^2) + ((ty(end) - ty(1))^2));
    
%feature6
tf6 = (tx(end) - tx(1))/tf5;
    
%feature7
tf7 = (ty(end) - tx(1))/tf5;
    
%feature8
tcal8 = [];
for tj = 1:length(tx)-1
    temp = sqrt(((tx(tj+1) - tx(tj))^2) + ((ty(tj+1) - ty(tj))^2));
    tcal8(end+1) = temp;
end
tf8 = sum(tcal8);
    
%feature9
tcaltemp = [];
tcal9 = [];
for ta = 2:length(tx)-1
    tslope = ((ty(ta+1) - ty(ta))/(tx(ta+1) - tx(ta)));
    tcaltemp(end+1) = tslope;
end
for te = 1:length(tcaltemp)-1
    tcal9temp = atan(tcaltemp(te+1) - tcaltemp(te))/(1 + tcaltemp(te+1)*tcaltemp(te));
    tcal9(end+1) = tcal9temp;
end
tcal9(isnan(tcal9))=0;
tf9 = sum(tcal9);
    
%feature10
tf10 = sum(abs(tcal9));
    
%feature11
tcal11 = tcal9 .^2;
tf11 = sum(tcal11);
    
%feature12
tcal12 = [];
for tb = 1:length(tx)-1
    tenergy = ((((tx(tb+1) - tx(tb))^2) + ((ty(tb+1) - ty(tb))^2))/((ttime(tb+1) - ttime(tb))^2));
    tcal12(end+1) = tenergy;
end
tf12 = max(tcal12);
    
%feature13
tf13 = ttime(end) - ttime(1);
    
tfeatures= [tf1,tf2,tf3,tf4,tf5,tf6,tf7,tf8,tf9,tf10,tf11,tf12,tf13];

wf1 = transpose(weight)*transpose(tfeatures);
wf2 = transpose(weight)*transpose(tfeatures);
wf3 = transpose(weight)*transpose(tfeatures);
wf4 = transpose(weight)*transpose(tfeatures);
wf5 = transpose(weight)*transpose(tfeatures);
wf6 = transpose(weight)*transpose(tfeatures);
wf7 = transpose(weight)*transpose(tfeatures);

wf = wf1+wf2+wf3+wf4+wf5+wf6+wf7;

v = w0+wf;
g = ["Area", "Charge", "Clean", "Mop", "Pause", "Start", "Vaccum"];
b = find(v==max(v));
gesture = g(b)
