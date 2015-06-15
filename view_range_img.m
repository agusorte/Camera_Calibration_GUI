function varargout = view_range_img(varargin)
% VIEW_RANGE_IMG M-file for view_range_img.fig
%      VIEW_RANGE_IMG, by itself, creates a new VIEW_RANGE_IMG or raises the existing
%      singleton*.
%
%      H = VIEW_RANGE_IMG returns the handle to a new VIEW_RANGE_IMG or the handle to
%      the existing singleton*.
%
%      VIEW_RANGE_IMG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEW_RANGE_IMG.M with the given input arguments.
%
%      VIEW_RANGE_IMG('Property','Value',...) creates a new VIEW_RANGE_IMG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before view_range_img_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to view_range_img_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help view_range_img

% Last Modified by GUIDE v2.5 23-Sep-2010 12:26:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @view_range_img_OpeningFcn, ...
                   'gui_OutputFcn',  @view_range_img_OutputFcn, ...
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


% --- Executes just before view_range_img is made visible.
function view_range_img_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to view_range_img (see VARARGIN)

% Choose default command line output for view_range_img
handles.output = hObject;


% Set UP direction vector here (e.g if z-axis points up away from the
% ground, use [0 0 1]'
handles.up_vector = [0 0 1]';

% Choose a right and forward vector appropriately
handles.right_vector = ...
    [handles.up_vector(3) handles.up_vector(2) -handles.up_vector(1)]';

handles.forward_vector = ...
    cross(handles.up_vector, handles.right_vector);



% UIWAIT makes view_range_img wait for user response (see UIRESUME)
% uiwait(handles.range_image_figure);

if(length(varargin)>=1),
     handles.PTS_3D=varargin{1};
     handles.nearVal=varargin{2};
     handles.farVal=varargin{4};
     
     set(handles.txt_near,'String',['Near: ' int2str(varargin{2})] );
     set(handles.txt_far,'String',['Far: ' int2str(varargin{4})] );
     
     set(handles.sld_near,'Min',varargin{2});
     set(handles.sld_near,'Max',varargin{3});
     set(handles.sld_near,'Value',varargin{2});
     
     set(handles.sld_far,'Min',varargin{4});
     set(handles.sld_far,'Max',varargin{5});
     set(handles.sld_far,'Value',varargin{4});
    
end;


% Update handles structure
guidata(hObject, handles);

 draw_range_fig(hObject, eventdata, handles);
 
 
% UIWAIT makes view_range_image wait for user response (see UIRESUME)
uiwait(handles.segmentation_figure);



% --- Outputs from this function are returned to the command line.
function varargout = view_range_img_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function sld_near_Callback(hObject, eventdata, handles)
% hObject    handle to sld_near (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.nearVal=get(handles.sld_near,'Value');
 set(handles.txt_near,'String',['Near: ' int2str(handles.nearVal)] );
% Update handles structure
guidata(hObject, handles);

 draw_range_fig(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function sld_near_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sld_near (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% handles.farVal=get(handles.sld_far,'Value');
% % Update handles structure
% guidata(hObject, handles);
% 
%  draw_range_fig(hObject, eventdata, handles);

% --- Executes on slider movement.
function sld_far_Callback(hObject, eventdata, handles)
% hObject    handle to sld_far (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.farVal=get(handles.sld_far,'Value');
 set(handles.txt_far,'String',['Near: ' int2str(handles.farVal)] );
% Update handles structure
guidata(hObject, handles);

 draw_range_fig(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function sld_far_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sld_far (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in btn_select.
function btn_select_Callback(hObject, eventdata, handles)
% hObject    handle to btn_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btn_close.
function btn_close_Callback(hObject, eventdata, handles)
% hObject    handle to btn_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiresume;


% --- Executes when user attempts to close range_image_figure.
function range_image_figure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to range_image_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
