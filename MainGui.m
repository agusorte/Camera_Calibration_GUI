

function varargout = MainGui(varargin)
% MAINGUI M-file for MainGui.fig
%      MAINGUI, by itself, creates a new MAINGUI or raises the existing
%      singleton*.
%
%      H = MAINGUI returns the handle to a new MAINGUI or the handle to
%      the existing singleton*.
%
%      MAINGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINGUI.M with the given input arguments.
%
%      MAINGUI('Property','Value',...) creates a new MAINGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainGui_OpeningFcn gets called.  An
%      unrecognized property name or invtin0308alid value makes property application
%      stop.  All inputs are passed to MainGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainGui

% Last Modified by GUIDE v2.5 28-Apr-2011 12:12:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainGui_OpeningFcn, ...
                   'gui_OutputFcn',  @MainGui_OutputFcn, ...
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


% --- Executes just before MainGui is made visible.
function MainGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainGui (see VARARGIN)

% Choose default command line output for MainGui
handles.output = hObject;


set(handles.sld_th1_dist,'Value',0);
set(handles.sld_th2_dist,'Value',0);
set(handles.sld_th3_dist,'Value',15);
set(handles.sld_th4_dist,'Value',15);

set(handles.sld_th1_angle_xy,'Value',0);
set(handles.sld_th2_angle_xy,'Value',0);
set(handles.sld_th3_angle_xy,'Value',360);
set(handles.sld_th4_angle_xy,'Value',360);

% stringdist1=[num2str(0) ' <=dist<= ' num2str(0)];                                               
% stringdist2=[num2str(15) ' <=dist<= ' num2str(15)];                                               
% 
% set(handles.txt_interv_dist1,'String', stringdist1);
% set(handles.txt_interv_dist2,'String', stringdist2);

handles.Points3D=[];
handles.imagepoints=[];

% UIWAIT makes MainGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MainGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;

function plot_clouds(handles,angles)
cla(handles.axes_3Dpoints);
axes(handles.axes_3Dpoints)
plot3(handles.PTS_3D(:,1),handles.PTS_3D(:,2),handles.PTS_3D(:,3),'b.','MarkerSize',0.5);
hold on;
Xax=max(handles.PTS_3D(:,1));
Yax=max(handles.PTS_3D(:,2));
Zax=max(handles.PTS_3D(:,3));
plot3([0 Xax],[0 0],[0 0],'r-','linewidth',2),text(Xax,0,0,'X');
plot3([0 0],[0 Yax],[0 0],'g-','linewidth',2),text(0,Yax,0,'Y');
plot3([0 0],[0 0],[0 Zax],'m-','linewidth',2),text(0,0,Zax,'Z');

if(angles)
    for k=1:45:360,
        % indxa=find(k-5<theta & theta<k+5);
        a=Xax*sin(k*pi/180);
        b=Xax*cos(k*pi/180);
        
        plot3(a,b,0,'.','color',[0 1 0],'linewidth',20);
        
        text(a,b,0,int2str(k));
        
    end;
    
     for k=1:45:360,
        % indxa=find(k-5<theta & theta<k+5);
        a=Zax*sin(k*pi/180);
        b=Zax*cos(k*pi/180);
        
        plot3(a,0,b,'.','color',[0 1 1],'linewidth',20);
        
        text(a,0,b,int2str(k));
        
    end;
end;

axis equal;
hold off;

% --- Executes on button press in btn_open3Dpoints.
function btn_open3Dpoints_Callback(hObject, eventdata, handles)
% hObject    handle to btn_open3Dpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file_name, mach_path] = uigetfile( {'*.txt'}, ...
    'Select File');
% If "Cancel" is selected then return
if isequal([file_name,mach_path],[0,0])
    return


    % Otherwise construct the fullfilename and Check and load the file
else
    File = fullfile(mach_path,file_name);
end
handles.up_vector = [0 0 1]';

% Choose a right and forward vector appropriately
handles.right_vector = ...
    [handles.up_vector(3) handles.up_vector(2) -handles.up_vector(1)]';
handles.forward_vector = ...
    cross(handles.up_vector, handles.right_vector);


PTS_AUX=load(File);

[n_poinst,dim]=size(PTS_AUX)
if dim>3

    handles.PTS_3D=PTS_AUX(:,1:3);
else
    handles.PTS_3D=PTS_AUX;
end;
P = [handles.right_vector handles.forward_vector handles.up_vector];
handles.PTS_3D = handles.PTS_3D * P

handles.PTS_3D_seg = handles.PTS_3D;

cla(handles.axes_3Dpoints)

plot_clouds(handles,0);

guidata(hObject, handles);

% --- Executes on button press in btn_select_3d_Points.
function btn_select_3d_Points_Callback(hObject, eventdata, handles)
% hObject    handle to btn_select_3d_Points (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%rutine that select the 3D points

but = 1;
xyz = [];
n = 0;



axes(handles.axes_3Dpoints)

hold on;

while but == 1
    [xi,yi,but] = ginput(1);
    if(but==1)
        [P V VI] = select3d;
        if(~isempty(V))
            plot3(V(1),V(2), V(3),'ks')
            xyz=[xyz; [V(1),V(2), V(3)]];
        end;

        
    end;
end;
hold off;


handles.Points3D=xyz;


str=mat2str(handles.Points3D,5);
set(handles.listboxPts3D,'String',['points: ' str]);

guidata(hObject, handles);


% --- Executes on button press in btn_openImage.
function btn_openImage_Callback(hObject, eventdata, handles)
% hObject    handle to btn_openImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file_name, mach_path] = uigetfile( {'*.ppm';'*.png';'*.tif';'*.jpg';'*.bmp';'*.ppm'}, ...
    'Select File');
% If "Cancel" is selected then return
if isequal([file_name,mach_path],[0,0])
    return

    % Otherwise construct the fullfilename and Check and load the file
else
    File = fullfile(mach_path,file_name);

    % set(handles.pushbuttonOpenImagee,'Enable','on');
    %set(handles.pushbuttonCleanimage,'Enable','on');

end
im=imread(File);

%set(gca,'CurrentAxes',handles.axesImage)
axes(handles.axes_image);
imshow(im);

axis off;


%save image in global variable
handles.im=im;
guidata(hObject, handles);
% --- Executes on button press in btn_rangeImage.
function btn_rangeImage_Callback(hObject, eventdata, handles)
% hObject    handle to btn_rangeImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h=view_range_img(handles.PTS_3D_seg,0,15000,4000,15000);
delete(h);


% --- Executes on button press in btn_select_imagePts.
function btn_select_imagePts_Callback(hObject, eventdata, handles)
% hObject    handle to btn_select_imagePts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
but = 1;
xy = [];
n = 0;
axes(handles.axes_image);
imshow(handles.im);
hold on;
while but == 1
    [xi,yi,but] = ginput(1);
    if(but==1)
        plot(xi,yi,'r+','MarkerSize',8,'LineWidth',2)
        n = n+1;
        xy =[xy; [xi,yi]];
        str=mat2str( xy,5);

        set(handles.listboxPts2D,'String',['[x,y]:' str]);
    end;
end
hold off;

handles.imagepoints=xy;


str=mat2str(handles.imagepoints,5);
set(handles.listboxPts2D,'String',['points: ' str]);
guidata(hObject, handles);


% --- Executes on selection change in listboxPts2D.
function listboxPts2D_Callback(hObject, eventdata, handles)
% hObject    handle to listboxPts2D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxPts2D contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxPts2D


% --- Executes during object creation, after setting all properties.
function listboxPts2D_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxPts2D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listboxPts3D.
function listboxPts3D_Callback(hObject, eventdata, handles)
% hObject    handle to listboxPts3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxPts3D contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxPts3D


% --- Executes during object creation, after setting all properties.
function listboxPts3D_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxPts3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called







function edt_th1_dist_Callback(hObject, eventdata, handles)
% hObject    handle to edt_th1_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_th1_dist as text
%        str2double(get(hObject,'String')) returns contents of edt_th1_dist as a double


set(handles.sld_th1_dist,'Value',str2double(get(handles.edt_th1_dist,'String')));

seg_dist_sld(hObject,handles);



% --- Executes during object creation, after setting all properties.
function edt_th1_dist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_th1_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edt_th3_dist_Callback(hObject, eventdata, handles)
% hObject    handle to edt_th3_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_th3_dist as text
%        str2double(get(hObject,'String')) returns contents of edt_th3_dist as a double
set(handles.sld_th3_dist,'Value',str2double(get(handles.edt_th3_dist,'String')));

seg_dist_sld(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edt_th3_dist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_th3_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edt_th2_dist_Callback(hObject, eventdata, handles)
% hObject    handle to edt_th3_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_th3_dist as text
%        str2double(get(hObject,'String')) returns contents of edt_th3_dist as a double
set(handles.sld_th2_dist,'Value',str2double(get(handles.edt_th2_dist,'String')));

seg_dist_sld(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edt_th2_dist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_th3_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edt_th4_dist_Callback(hObject, eventdata, handles)
% hObject    handle to edt_th4_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_th4_dist as text
%        str2double(get(hObject,'String')) returns contents of edt_th4_dist as a double

set(handles.sld_th4_dist,'Value',str2double(get(handles.edt_th4_dist,'String')));

seg_dist_sld(hObject,handles);
% --- Executes during object creation, after setting all properties.
function edt_th4_dist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_th4_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_ok_dist.
function btn_ok_dist_Callback(hObject, eventdata, handles)
% hObject    handle to btn_ok_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles.th1_dist=str2double(get(handles.edt_th1_dist,'String'));
handles.th2_dist=str2double(get(handles.edt_th3_dist,'String'));
handles.th3_dist=str2double(get(handles.edt_th3_dist,'String'));
handles.th4_dist=str2double(get(handles.edt_th4_dist,'String'));

handles.PTS_3D_seg=segment_distance(handles.PTS_3D,handles.th1_dist,handles.th2_dist,...
                                                   handles.th3_dist,handles.th4_dist);
                                               
                                               
plot_scan(handles.PTS_3D,handles.PTS_3D_seg,handles,1);
guidata(hObject, handles);


% --- Executes on button press in btn_angle_xy.
function btn_angle_xy_Callback(hObject, eventdata, handles)
% hObject    handle to btn_angle_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edt_th1_angle_xy_Callback(hObject, eventdata, handles)
% hObject    handle to edt_th1_angle_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_th1_angle_xy as text
%        str2double(get(hObject,'String')) returns contents of edt_th1_angle_xy as a double
set(handles.sld_th1_angle_xy,'Value',str2double(get(handles.edt_th1_angle_xy,'String')));

seg_angle_xy_sld(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edt_th1_angle_xy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_th1_angle_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edt_th2_angle_xy_Callback(hObject, eventdata, handles)
% hObject    handle to edt_th2_angle_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_th2_angle_xy as text
%        str2double(get(hObject,'String')) returns contents of edt_th2_angle_xy as a double

set(handles.sld_th2_angle_xy,'Value',str2double(get(handles.edt_th2_angle_xy,'String')));

seg_angle_xy_sld(hObject,handles);
% --- Executes during object creation, after setting all properties.
function edt_th2_angle_xy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_th2_angle_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edt_th3_angle_xz_Callback(hObject, eventdata, handles)
% hObject    handle to edt_th3_angle_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_th3_angle_xz as text
%        str2double(get(hObject,'String')) returns contents of edt_th3_angle_xz as a double

set(handles.sld_th3_angle_xz,'Value',str2double(get(handles.edt_th3_angle_xz,'String')));

seg_angle_xz_sld(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edt_th3_angle_xz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_th3_angle_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_find_extrinsic.
function btn_find_extrinsic_Callback(hObject, eventdata, handles)
% hObject    handle to btn_find_extrinsic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

addpath Schweighofer/;
addpath Hager/;
%load('Calib_Results.mat');
warning off;




%load extrisic camera parameters

% Xthomog=[handles.Points3D(:,3) handles.Points3D(:,2) handles.Points3D(:,1) ones(size(handles.Points3D,1),1)]*1.0e3;
Xthomog=[handles.Points3D(:,3) handles.Points3D(:,2) -handles.Points3D(:,1) ones(size(handles.Points3D,1),1)];
Uhomog=[handles.imagepoints ones(size(handles.imagepoints,1),1)];

%Extrisic camera parameters
Kk=[handles.fc(1) handles.alpha_c*handles.fc(1) handles.cc(1);...
   0  handles.fc(2) handles.cc(2);...
   0  0  1];

%inicializacion con Hager
[Rest1,Test1,Xcest1]=Hager(Xthomog,Uhomog,Kk);



Xthomog2=[handles.Points3D(:,3) handles.Points3D(:,2) zeros(size(handles.Points3D,1),1) ones(size(handles.Points3D,1),1)];
%refinamiento con Schweihofer�
%[Rest,Test,Xcest]=Schweighofer(Xthomog2,Uhomog,Kk,Rest1);
 
%[Rest,Test,Xcest]=Schweighofer(Xthomog,Uhomog,Kk,Rest);

handles.R1=Rest1;
handles.T1=Test1;

% handles.R2=Rest;
% handles.T2=Test;

handles.omc1=rodrigues(Rest1);
% handles.omc2=rodrigues(Rest);

% handles.fc=fc;%focal length
% handles.alpha_c=alpha_c; %skew
% handles.cc=cc; %projection center
% handles.kc=kc; %radial distortion

handles.calib_laser=struct('R', handles.R1,...
                          'T', handles.T1,...
                          'fc',handles.fc,...
                           'cc',handles.cc,...
                           'alpha_c',handles.alpha_c,...
                           'kc',handles.kc);

guidata(hObject, handles);


handles.data=struct('P2D',Uhomog(:,1:2),'P3D',Xthomog(:,1:3));
global CALIB_ 
global DATA_

CALIB_=handles.calib_laser;
DATA_=handles.data;

% --- Executes on button press in btn_proj_3d_2d.
function btn_proj_3d_2d_Callback(hObject, eventdata, handles)
% hObject    handle to btn_proj_3d_2d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%1) Convert into camera reference frame (m) * 1.0e3 to get in mms

P=[0 0 -1;
   0 1 0;
   1 0 0];
% P=[1 0 0;
%    0 1 0;
%    0 0 1];
%                            %*********************************
auxpoints3D=handles.PTS_3D*P;%sin cambio a metros funciona bien
                             %*********************************

                            
handles.kc=[0 0 0 0 0];
%auxpoints3D=handles.PTS_3D*P* 1.0e3; %<--no va bien
auxpoints3D= handles.PTS_3D*P;
proj3d1=project_points2(auxpoints3D',handles.omc1,handles.T1,...
    handles.fc,handles.cc,...
    handles.kc,handles.alpha_c);

%selected 3D points
auxpoints2D= handles.Points3D(:,1:3)*P;
proj2d1=project_points2(auxpoints2D',handles.omc1,handles.T1,...
    handles.fc,handles.cc,...
    handles.kc,handles.alpha_c);

% %este no a bien
% proj3d2=project_points2(auxpoints3D',handles.omc2,handles.T2,...
%     handles.fc,handles.cc,...
%     handles.kc,handles.alpha_c);

%selected 3D points

% proj2d2=project_points2(auxpoints2D',handles.omc2,handles.T2,...
%     handles.fc,handles.cc,...
%     handles.kc,handles.alpha_c);



% proj=project_points2(handles.PTS_3D',handles.omc,handles.T,...
%     handles.fc,handles.cc,...
%     handles.kc,handles.alpha_c);
% 
% %selected 3D points
% 
% proj2=project_points2(handles.Points3D(:,1:3)',handles.omc,handles.T,...
%     handles.fc,handles.cc,...
%     handles.kc,handles.alpha_c);


%open figure
figure(111),clf;
imshow(handles.im);
hold on;
plot(proj3d1(1,:),proj3d1(2,:),'b.');
plot(proj2d1(1,:),proj2d1(2,:),'ks','MarkerSize',8,'LineWidth',2);
% plot(proj3d2(1,:),proj3d2(2,:),'.','Color',[0.2,0.6,1]);
% plot(proj2d2(1,:),proj2d2(2,:),'gs','MarkerSize',8,'LineWidth',2);

% 
plot(handles.imagepoints(:,1),handles.imagepoints(:,2),'r+','MarkerSize',8,'LineWidth',2);


% --- Executes on button press in btn_open_scan3D.
function btn_open_scan3D_Callback(hObject, eventdata, handles)
% hObject    handle to btn_open_scan3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file_name, mach_path] = uigetfile( {'*.txt'}, ...
    'Select File');
% If "Cancel" is selected then return
if isequal([file_name,mach_path],[0,0])
    return


    % Otherwise construct the fullfilename and Check and load the file
else
    File = fullfile(mach_path,file_name);
end


PTS_AUX=load(File);

[n_poinst,dim]=size(PTS_AUX)
if dim>3

    handles.scan=PTS_AUX(:,1:3);
else
    handles.scan=PTS_AUX;
end

% handles.scan=load(File);




guidata(hObject, handles);


% --- Executes on button press in btn_openImageColorized.
function btn_openImageColorized_Callback(hObject, eventdata, handles)
% hObject    handle to btn_openImageColorized (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file_name, mach_path] = uigetfile( {'*.ppm';'*.png';'*.tif';'*.jpg';'*.bmp';'*.ppm'}, ...
    'Select File');
% If "Cancel" is selected then return
if isequal([file_name,mach_path],[0,0])
    return

    % Otherwise construct the fullfilename and Check and load the file
else
    File = fullfile(mach_path,file_name);

    % set(handles.pushbuttonOpenImagee,'Enable','on');
    %set(handles.pushbuttonCleanimage,'Enable','on');

end
im=imread(File);


%save image in global variable
handles.im_scan=im;

guidata(hObject, handles);

% --- Executes on button press in btn_proj_image_scan.
function btn_proj_image_scan_Callback(hObject, eventdata, handles)
% hObject    handle to btn_proj_image_scan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

P=[0 0 -1;
   0 1 0;
   1 0 0];
%                            %*********************************
auxpoints3D=handles.scan*P;%sin cambio a metros funciona bien
                             %*********************************

%auxpoints3D=handles.PTS_3D*P* 1.0e3; <--no va bien
%auxpoints3D= handles.PTS_3D*1.0e3;
proj3d1=project_points2(auxpoints3D',handles.omc1,handles.T1,...
    handles.fc,handles.cc,...
    handles.kc,handles.alpha_c);

figure(222),clf;
imshow(handles.im_scan);
hold on;
plot(proj3d1(1,:),proj3d1(2,:),'b.');


% --- Executes on button press in btn_create_vrlm.
function btn_create_vrlm_Callback(hObject, eventdata, handles)
% hObject    handle to btn_create_vrlm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tic


P=[0 0 -1;
   0 1 0;
   1 0 0];
%                            %*********************************
auxpoints3D=handles.scan*P;%sin cambio a metros funciona bien
                             %*********************************

%auxpoints3D=handles.PTS_3D*P* 1.0e3; <--no va bien
%auxpoints3D= handles.PTS_3D*1.0e3;

handles.kc=[0 0 0 0 0]; %comment if you want radial distortion

scan2d=project_points2(auxpoints3D',handles.omc1,handles.T1,...
    handles.fc,handles.cc,...
    handles.kc,handles.alpha_c);

n_points=size(handles.scan,1);


scan2d=fliplr(round(scan2d'));


image=handles.im_scan;


% Initialize empty matrix representing default point color=black
scanRGB=zeros(n_points,3);


imrows=size(image,1);
imcols=size(image,2);

inliers=find(scan2d(:,1)>0 & scan2d(:,1)<imrows & scan2d(:,2)>0 ...
    & scan2d(:,2)<imcols);

inliers_lindex=sub2ind([imrows imcols],scan2d(inliers,1),scan2d(inliers,2));

image=reshape(image,imrows*imcols,3);

scanRGB(inliers,:)=image(inliers_lindex,:);

fprintf(1,'Writing VRML file rgbScan.wrl\n');
fprintf(1,'This may take a minute, so please wait... ');
fil1=['rgbScan_created.wrl'];
% fil2=['rgbScan_created_2.wrl'];

points3D2vrml2(fil1,handles.scan,scanRGB);

fprintf(1,'Done!\n');
% 
% cmd=['vrml1tovrml2 ' fil1 ' ' fil2]; 
% %rgbScan.wrl vrml2.wrl';
% 
% system(cmd);
% 
% toc
% 




function edt_th4_angle_xz_Callback(hObject, eventdata, handles)
% hObject    handle to edt_th4_angle_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_th4_angle_xz as text
%        str2double(get(hObject,'String')) returns contents of edt_th4_angle_xz as a double
set(handles.sld_th4_angle_xz,'Value',str2double(get(handles.edt_th4_angle_xz,'String')));

seg_angle_xz_sld(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edt_th4_angle_xz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_th4_angle_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_reset.
function btn_reset_Callback(hObject, eventdata, handles)
% hObject    handle to btn_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(get(handles.chkbox_view_angles,'Value'))
    plot_clouds(handles,1);
    %view_angle_points(handles)
else
    plot_clouds(handles,0);
end;

% --- Executes on button press in btn_apply_changes.
function btn_apply_changes_Callback(hObject, eventdata, handles)
% hObject    handle to btn_apply_changes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.PTS_3D=handles.PTS_3D_seg;
guidata(hObject, handles);

if(get(handles.chkbox_view_angles,'Value'))
    plot_clouds(handles,1);
    %view_angle_points(handles)
else
    plot_clouds(handles,0);
end;



function edt_th1_angle_zx_Callback(hObject, eventdata, handles)
% hObject    handle to edt_th1_angle_zx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_th1_angle_zx as text
%        str2double(get(hObject,'String')) returns contents of edt_th1_angle_zx as a double


% --- Executes during object creation, after setting all properties.
function edt_th1_angle_zx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_th1_angle_zx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edt_th2_angle_zx_Callback(hObject, eventdata, handles)
% hObject    handle to edt_th2_angle_zx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_th2_angle_zx as text
%        str2double(get(hObject,'String')) returns contents of edt_th2_angle_zx as a double


% --- Executes during object creation, after setting all properties.
function edt_th2_angle_zx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_th2_angle_zx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edt_th3_angle_zx_Callback(hObject, eventdata, handles)
% hObject    handle to edt_th3_angle_zx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_th3_angle_zx as text
%        str2double(get(hObject,'String')) returns contents of edt_th3_angle_zx as a double


% --- Executes during object creation, after setting all properties.
function edt_th3_angle_zx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_th3_angle_zx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edt_th4_angle_zx_Callback(hObject, eventdata, handles)
% hObject    handle to edt_th4_angle_zx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_th4_angle_zx as text
%        str2double(get(hObject,'String')) returns contents of edt_th4_angle_zx as a double


% --- Executes during object creation, after setting all properties.
function edt_th4_angle_zx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_th4_angle_zx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_ok_angle_zx.
function btn_ok_angle_zx_Callback(hObject, eventdata, handles)
% hObject    handle to btn_ok_angle_zx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on edt_th1_dist and none of its controls.
function edt_th1_dist_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edt_th1_dist (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

val=str2double(get(handles.edt_th1_dist,'String'))


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over edt_th1_dist.
function edt_th1_dist_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to edt_th1_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val=str2double(get(handles.edt_th1_dist,'String'))


% --- Executes during object creation, after setting all properties.
function uipanel11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in btn_load_camcalib.
function btn_load_camcalib_Callback(hObject, eventdata, handles)
% hObject    handle to btn_load_camcalib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file_name, mach_path] = uigetfile( {'*.mat'}, ...
    'Select File');
% If "Cancel" is selected then return
if isequal([file_name,mach_path],[0,0])
    return


    % Otherwise construct the fullfilename and Check and load the file
else
    File = fullfile(mach_path,file_name);
end

calib=load(File);

handles.fc=calib.fc;%focal length
handles.alpha_c=calib.alpha_c; %skew
handles.cc=calib.cc; %projection center
handles.kc=calib.kc; %radial distortion


guidata(hObject, handles);

function seg_dist_sld(hObject,handles)
handles.th1_dist=get(handles.sld_th1_dist,'Value');
handles.th2_dist=get(handles.sld_th2_dist,'Value');
handles.th3_dist=get(handles.sld_th3_dist,'Value');
handles.th4_dist=get(handles.sld_th4_dist,'Value');

handles.PTS_3D_seg=segment_distance(handles.PTS_3D,handles.th1_dist,handles.th2_dist,...
                                                   handles.th3_dist,handles.th4_dist);
                                               
                                            

set(handles.edt_th1_dist,'String', num2str(handles.th1_dist));
set(handles.edt_th2_dist,'String', num2str(handles.th2_dist));
set(handles.edt_th3_dist,'String', num2str(handles.th3_dist));
set(handles.edt_th4_dist,'String', num2str(handles.th4_dist));

plot_scan(handles.PTS_3D,handles.PTS_3D_seg,handles,1);

guidata(hObject, handles);


global CALIB;


CALIB=calib;
% --- Executes on slider movement.
function sld_th1_dist_Callback(hObject, eventdata, handles)
% hObject    handle to sld_th1_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
seg_dist_sld(hObject,handles)

% --- Executes during object creation, after setting all properties.
function sld_th1_dist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sld_th1_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sld_th2_dist_Callback(hObject, eventdata, handles)
% hObject    handle to sld_th2_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
seg_dist_sld(hObject,handles);

% --- Executes during object creation, after setting all properties.
function sld_th2_dist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sld_th2_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sld_th3_dist_Callback(hObject, eventdata, handles)
% hObject    handle to sld_th3_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
seg_dist_sld(hObject,handles);

% --- Executes during object creation, after setting all properties.
function sld_th3_dist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sld_th3_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sld_th4_dist_Callback(hObject, eventdata, handles)
% hObject    handle to sld_th4_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
seg_dist_sld(hObject,handles);

% --- Executes during object creation, after setting all properties.
function sld_th4_dist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sld_th4_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edt_th3_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_th3_dist as text
%        str2double(get(hObject,'String')) returns contents of edt_th3_dist as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_th3_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function seg_angle_xy_sld(hObject,handles)
handles.th1_anglexy=get(handles.sld_th1_angle_xy,'Value');
handles.th2_anglexy=get(handles.sld_th2_angle_xy,'Value');
handles.th3_anglexy=get(handles.sld_th3_angle_xy,'Value');
handles.th4_anglexy=get(handles.sld_th4_angle_xy,'Value');

handles.PTS_3D_seg=segment_angle_xy(handles.PTS_3D,handles.th1_anglexy,handles.th2_anglexy,...
                                                   handles.th3_anglexy,handles.th4_anglexy);
                                               
                                            

set(handles.edt_th1_angle_xy,'String', num2str(handles.th1_anglexy));
set(handles.edt_th2_angle_xy,'String', num2str(handles.th2_anglexy));
set(handles.edt_th3_angle_xy,'String', num2str(handles.th3_anglexy));
set(handles.edt_th4_angle_xy,'String', num2str(handles.th4_anglexy));

plot_scan(handles.PTS_3D,handles.PTS_3D_seg,handles,1);

guidata(hObject, handles);

% --- Executes on slider movement.
function sld_th1_angle_xy_Callback(hObject, eventdata, handles)
% hObject    handle to sld_th1_angle_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

seg_angle_xy_sld(hObject,handles);

% --- Executes during object creation, after setting all properties.
function sld_th1_angle_xy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sld_th1_angle_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sld_th2_angle_xy_Callback(hObject, eventdata, handles)
% hObject    handle to sld_th2_angle_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
seg_angle_xy_sld(hObject,handles);

% --- Executes during object creation, after setting all properties.
function sld_th2_angle_xy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sld_th2_angle_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sld_th3_angle_xy_Callback(hObject, eventdata, handles)
% hObject    handle to sld_th3_angle_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

seg_angle_xy_sld(hObject,handles);

% --- Executes during object creation, after setting all properties.
function sld_th3_angle_xy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sld_th3_angle_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sld_th4_angle_xy_Callback(hObject, eventdata, handles)
% hObject    handle to sld_th4_angle_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

seg_angle_xy_sld(hObject,handles);

% --- Executes during object creation, after setting all properties.
function sld_th4_angle_xy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sld_th4_angle_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edt_th1_angle_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_th1_angle_xy as text
%        str2double(get(hObject,'String')) returns contents of edt_th1_angle_xy as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_th1_angle_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edt_th2_angle_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_th2_angle_xy as text
%        str2double(get(hObject,'String')) returns contents of edt_th2_angle_xy as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_th2_angle_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edt_th3_angle_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_th3_angle_xz as text
%        str2double(get(hObject,'String')) returns contents of edt_th3_angle_xz as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_th3_angle_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edt_th4_angle_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_th4_angle_xz as text
%        str2double(get(hObject,'String')) returns contents of edt_th4_angle_xz as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_th4_angle_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function seg_angle_xz_sld(hObject,handles)
handles.th1_anglexz=get(handles.sld_th1_angle_xz,'Value');
handles.th2_anglexz=get(handles.sld_th2_angle_xz,'Value');
handles.th3_anglexz=get(handles.sld_th3_angle_xz,'Value');
handles.th4_anglexz=get(handles.sld_th4_angle_xz,'Value');

handles.PTS_3D_seg=segment_angle_zx(handles.PTS_3D,handles.th1_anglexz,handles.th2_anglexz,...
                                                   handles.th3_anglexz,handles.th4_anglexz);
                                               
                                            

set(handles.edt_th1_angle_xz,'String', num2str(handles.th1_anglexz));
set(handles.edt_th2_angle_xz,'String', num2str(handles.th2_anglexz));
set(handles.edt_th3_angle_xz,'String', num2str(handles.th3_anglexz));
set(handles.edt_th4_angle_xz,'String', num2str(handles.th4_anglexz));

plot_scan(handles.PTS_3D,handles.PTS_3D_seg,handles,1);

guidata(hObject, handles);

% --- Executes on slider movement.
function sld_th1_angle_xz_Callback(hObject, eventdata, handles)
% hObject    handle to sld_th1_angle_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
seg_angle_xz_sld(hObject,handles);

% --- Executes during object creation, after setting all properties.
function sld_th1_angle_xz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sld_th1_angle_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sld_th2_angle_xz_Callback(hObject, eventdata, handles)
% hObject    handle to sld_th2_angle_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
seg_angle_xz_sld(hObject,handles);

% --- Executes during object creation, after setting all properties.
function sld_th2_angle_xz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sld_th2_angle_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sld_th3_angle_xz_Callback(hObject, eventdata, handles)
% hObject    handle to sld_th3_angle_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

seg_angle_xz_sld(hObject,handles);
% --- Executes during object creation, after setting all properties.
function sld_th3_angle_xz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sld_th3_angle_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sld_th4_angle_xz_Callback(hObject, eventdata, handles)
% hObject    handle to sld_th4_angle_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

seg_angle_xz_sld(hObject,handles);

% --- Executes during object creation, after setting all properties.
function sld_th4_angle_xz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sld_th4_angle_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edt_th1_angle_xz_Callback(hObject, eventdata, handles)
% hObject    handle to edt_th1_angle_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_th1_angle_xz as text
%        str2double(get(hObject,'String')) returns contents of edt_th1_angle_xz as a double
set(handles.sld_th1_angle_xz,'Value',str2double(get(handles.edt_th1_angle_xz,'String')));

seg_angle_xz_sld(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edt_th1_angle_xz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_th1_angle_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edt_th2_angle_xz_Callback(hObject, eventdata, handles)
% hObject    handle to edt_th2_angle_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_th2_angle_xz as text
%        str2double(get(hObject,'String')) returns contents of edt_th2_angle_xz as a double
set(handles.sld_th2_angle_xz,'Value',str2double(get(handles.edt_th2_angle_xz,'String')));

seg_angle_xz_sld(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edt_th2_angle_xz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_th2_angle_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edt_th3_angle_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_th3_angle_xz as text
%        str2double(get(hObject,'String')) returns contents of edt_th3_angle_xz as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_th3_angle_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edt_th4_angle_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_th4_angle_xz as text
%        str2double(get(hObject,'String')) returns contents of edt_th4_angle_xz as a double


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_th4_angle_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in chkbox_view_angles.
function chkbox_view_angles_Callback(hObject, eventdata, handles)
% hObject    handle to chkbox_view_angles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkbox_view_angles

if(get(handles.chkbox_view_angles,'Value'))
    plot_clouds(handles,1);
    %view_angle_points(handles)
else
    plot_clouds(handles,0);
end;



function edt_th3_angle_xy_Callback(hObject, eventdata, handles)
% hObject    handle to edt_th3_angle_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_th3_angle_xy as text
%        str2double(get(hObject,'String')) returns contents of edt_th3_angle_xy as a double
set(handles.sld_th3_angle_xy,'Value',str2double(get(handles.edt_th3_angle_xy,'String')));

seg_angle_xy_sld(hObject,handles);



function edt_th4_angle_xy_Callback(hObject, eventdata, handles)
% hObject    handle to edt_th4_angle_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_th4_angle_xy as text
%        str2double(get(hObject,'String')) returns contents of edt_th4_angle_xy as a double
set(handles.sld_th4_angle_xy,'Value',str2double(get(handles.edt_th4_angle_xy,'String')));

seg_angle_xy_sld(hObject,handles);


% --- Executes on button press in btn_save_seg_cloud.
function btn_save_seg_cloud_Callback(hObject, eventdata, handles)
% hObject    handle to btn_save_seg_cloud (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[file,path] = uiputfile('*.txt','Save Workspace As');


A_s=handles.PTS_3D_seg;
filesaved=[path file];
 save( filesaved,'A_s','-ascii', '-double','-tabs');
% dlmwrite(filesaved, A_s,'-append', ...
 %  'roffset', 1, 'delimiter', ' ');
    
  guidata(hObject, handles);  


% --- Executes on button press in btn_saveExtrinsic.
function btn_saveExtrinsic_Callback(hObject, eventdata, handles)
% hObject    handle to btn_saveExtrinsic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file,path] = uiputfile('*.mat','Save Workspace As');


A_s=handles.PTS_3D_seg;
filesaved=[path file];

R1=handles.R1;
T1=handles.T1;
fc=handles.fc;
cc=handles.cc;
kc=handles.kc;
omc1=handles.omc1;
alpha_c=handles.alpha_c;
save(filesaved,'R1', 'T1',...
              'fc','cc',...
              'kc','alpha_c','omc1','-MAT');

  guidata(hObject, handles);  

% --- Executes on button press in load_lasercalib_btn.
function load_lasercalib_btn_Callback(hObject, eventdata, handles)
% hObject    handle to load_lasercalib_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file_name, mach_path] = uigetfile( {'*.mat'}, ...
    'Select File');
% If "Cancel" is selected then return
if isequal([file_name,mach_path],[0,0])
    return


    % Otherwise construct the fullfilename and Check and load the file
else
    File = fullfile(mach_path,file_name);
end

calib=load(File);

% handles.fc=calib.fc;%focal length
% handles.alpha_c=calib.alpha_c; %skew
% handles.cc=calib.cc; %projection center
% handles.kc=calib.kc; %radial distortion


handles.R1=calib.R1;
handles.T1=calib.T1;
handles.fc=calib.fc;
handles.cc=calib.cc;
handles.kc=calib.kc;
handles.omc1=calib.omc1;
handles.alpha_c=calib.alpha_c;


guidata(hObject, handles);


% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



omc=rodrigues(handles.calib_laser.R);
T=handles.calib_laser.T;

%optimization parameters omc and T;
X0=[omc' T'];


opt = optimset('Display','Iter','MaxIter',10000,'MaxFunEvals',10000);
%1 fminseach
%2 Lamberg Marquardt  
%3 fminc
%4 fmincond


[X_est,fval,exitflag,output]=calibration_laser(X0,opt,1);

if exitflag ~= 1
    display('Non-convergent optimization.........  :(, ;(')
else
    display('Convergent optimization..........  :P, :) :)')
end;
handles.omc1=X_est(1:3);
handles.T1=X_est(4:6);
% X0
% X_est

% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btn_proj_opt.
function btn_proj_opt_Callback(hObject, eventdata, handles)
% hObject    handle to btn_proj_opt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
P=[0 0 -1;
   0 1 0;
   1 0 0];
%                            %*********************************
auxpoints3D=handles.PTS_3D*P;%sin cambio a metros funciona bien
                             %*********************************

                            
handles.kc=[0 0 0 0 0];
%auxpoints3D=handles.PTS_3D*P* 1.0e3; %<--no va bien
%auxpoints3D= handles.PTS_3D*1.0e3;


proj3d1=project_points2(auxpoints3D',handles.omc1,handles.T1,...
    handles.fc,handles.cc,...
    handles.kc,handles.alpha_c);

%selected 3D points
auxpoints2D= handles.Points3D(:,1:3)*P;
proj2d1=project_points2(auxpoints2D',handles.omc1,handles.T1,...
    handles.fc,handles.cc,...
    handles.kc,handles.alpha_c);

% %este no a bien
% proj3d2=project_points2(auxpoints3D',handles.omc2,handles.T2,...
%     handles.fc,handles.cc,...
%     handles.kc,handles.alpha_c);
% 
% %selected 3D points
% 
% proj2d2=project_points2(auxpoints2D',handles.omc2,handles.T2,...
%     handles.fc,handles.cc,...
%     handles.kc,handles.alpha_c);



% proj=project_points2(handles.PTS_3D',handles.omc,handles.T,...
%     handles.fc,handles.cc,...
%     handles.kc,handles.alpha_c);
% 
% %selected 3D points
% 
% proj2=project_points2(handles.Points3D(:,1:3)',handles.omc,handles.T,...
%     handles.fc,handles.cc,...
%     handles.kc,handles.alpha_c);


%open figure
figure(111),clf;
imshow(handles.im);
hold on;    
plot(proj3d1(1,:),proj3d1(2,:),'b.');
plot(proj2d1(1,:),proj2d1(2,:),'ks','MarkerSize',8,'LineWidth',2);
% plot(proj3d2(1,:),proj3d2(2,:),'.','Color',[0.2,0.6,1]);
% plot(proj2d2(1,:),proj2d2(2,:),'gs','MarkerSize',8,'LineWidth',2);

% 
plot(handles.imagepoints(:,1),handles.imagepoints(:,2),'r+','MarkerSize',8,'LineWidth',2);


% --- Executes on button press in color_vrl_btn.
function color_vrl_btn_Callback(hObject, eventdata, handles)
% hObject    handle to color_vrl_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


n_points=size(handles.scan,1);



handles.scan=segment2Degrees(handles.scan);

n_points=size(handles.scan,1);


scanRGB=zeros(n_points,3) ;

[inliers,indx]=ismember(handles.PTS_3D,handles.scan,'rows');




scanRGB(indx,:)=255;

%scanRGB(indx,:)=255;

fprintf(1,'Writing VRML file rgbScan.wrl\n');
fprintf(1,'This may take a minute, so please wait... ');
fil1=['rgbScan_created_color.wrl'];
% fil2=['rgbScan_created_2.wrl'];

points3D2vrml2(fil1,handles.scan,scanRGB);

fprintf(1,'Done!\n');


% --- Executes on button press in clor_2_btn.
function clor_2_btn_Callback(hObject, eventdata, handles)
% hObject    handle to clor_2_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tic


P=[0 0 -1;
   0 1 0;
   1 0 0];
%                            %*********************************
auxpoints3D=handles.scan*P;%sin cambio a metros funciona bien
                             %*********************************

%auxpoints3D=handles.PTS_3D*P* 1.0e3; <--no va bien
%auxpoints3D= handles.PTS_3D*1.0e3;

handles.kc=[0 0 0 0 0]; %comment if you want radial distortion

scan2d=project_points2(auxpoints3D',handles.omc1,handles.T1,...
    handles.fc,handles.cc,...
    handles.kc,handles.alpha_c);

n_points=size(handles.scan,1);


scan2d=fliplr(round(scan2d'));


image=handles.im_scan;


% Initialize empty matrix representing default point color=black
scanRGB=zeros(n_points,3);


imrows=size(image,1);
imcols=size(image,2);

inliers=find(scan2d(:,1)>0 & scan2d(:,1)<imrows & scan2d(:,2)>0 ...
    & scan2d(:,2)<imcols);

inliers_lindex=sub2ind([imrows imcols],scan2d(inliers,1),scan2d(inliers,2));

image=reshape(image,imrows*imcols,3);

scanRGB(inliers,:)=image(inliers_lindex,:);


[inliers,indx]=ismember(handles.PTS_3D,handles.scan,'rows');




scanRGB(indx,:)=0;

%scanRGB(indx,:)=255;

fprintf(1,'Writing VRML file rgbScan.wrl\n');
fprintf(1,'This may take a minute, so please wait... ');
fil1=['rgbScan_created_color.wrl'];
% fil2=['rgbScan_created_2.wrl']; 

points3D2vrml2(fil1,handles.scan,scanRGB);

fprintf(1,'Done!\n');
