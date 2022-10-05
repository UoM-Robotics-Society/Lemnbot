function varargout = imagen_proc(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imagen_proc_OpeningFcn, ...
                   'gui_OutputFcn',  @imagen_proc_OutputFcn, ...
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


% --- Executes just before imagen_proc is made visible.
function imagen_proc_OpeningFcn(hObject, eventdata, handles, varargin)
global  timer1 J;
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imagen_proc (see VARARGIN)

load J;
J=J;


timer1 = timer('ExecutionMode','fixedRate','Period', 0.04,'TimerFcn', {@Update,handles}); % Configuration of timer at 0.05 Seconds
% Presetting the axes
set(handles.slider4,'value',14.0) % axe X
set(handles.slider5,'value',12)   % axe Y
set(handles.slider6,'value',14)   % axe Z

handles.output = hObject;
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = imagen_proc_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structur
handles.output = hObject;
varargout{1} = handles.output;


function Update(obj,event,handles)
global J;

% Get position of the sliders
 slider_value1 = get(handles.slider4,'value'); % get position of the sliders
 slider_value2 = get(handles.slider5,'value');
 slider_value3 = get(handles.slider6,'value');
 poignet = get(handles.poignet,'value');
% Restrictions in the space exploration.
 if slider_value3 < 6
     if slider_value1>0 
         if (slider_value1<=6)
             slider_value1=6;
             set(handles.slider4,'value',6)
             set(handles.slider4,'Max',36)
             set(handles.slider4,'Min',6)
         end
     end
     if slider_value1<0 
         if (slider_value1 >= -6)
             slider_value1=-6;
             set(handles.slider4,'value',-6) 
             set(handles.slider4,'Max',-6)
             set(handles.slider4,'Min',-36)             
         end         
     end
 else
             set(handles.slider4,'Max',36)
             set(handles.slider4,'Min',-36)
 end
 set (handles.operacion_alto, 'string',num2str(slider_value1)) ; % axe X
 set (handles.edit27, 'string',num2str(slider_value2)) ;         % axe Y
 set (handles.edit28, 'string',num2str(slider_value3)) ;         % axe Z

 % obtaining angles for motors r_m2 and r_m3
 ecu=[slider_value2 slider_value3 slider_value2*slider_value3 slider_value2^2 slider_value3^2];
 ang12=[1 ecu]*J; 
 % obtaining angles through inverse kinematics
 [l_shoulder_y,l_shoulder_x,l_elbow_y] = robot3_inv(slider_value1,slider_value2,slider_value3);
 motor_l_shoulder_y=Cadena_4char(l_shoulder_y);
    set(handles.angleq0, 'String',motor_l_shoulder_y);
 motor_l_shoulder_x=Cadena_4char(-1*l_shoulder_x);
    set(handles.angleq1, 'String',motor_l_shoulder_x);
 motor_l_elbow_y=Cadena_4char(l_elbow_y);
    set(handles.angleq2, 'String',motor_l_elbow_y);
% open/close gripper
 if get(handles.checkbox3,'value')==0
          motor_r_m5=round(str2double(get(handles.min_pos_gripper,'String')));         
 end
 if get(handles.checkbox3,'value')==1
          motor_r_m5=round(str2double(get(handles.max_pos_gripper,'String')));% you need to set this angle 5 degrees less than the angle necessary to wrap the object          
 end	
	


if strcmp(get(handles.connectButton,'String'),'Disconnect') % start only if the timer is initialized

    header = http_createHeader('Content-Type','application/json');  % header settings 
    
    %-------------------- initialize addresses for each motor -------------
    elbow_y='http://127.0.0.1:3030/motor/r_elbow_y/register/goal_position/value.json';
    shoulder_x='http://127.0.0.1:3030/motor/r_shoulder_x/register/goal_position/value.json';
    shoulder_y='http://127.0.0.1:3030/motor/r_shoulder_y/register/goal_position/value.json';
    arm_z ='http://127.0.0.1:3030/motor/r_arm_z/register/goal_position/value.json';        
    r_m2 ='http://127.0.0.1:3030/motor/r_m2/register/goal_position/value.json'; 
    r_m3 ='http://127.0.0.1:3030/motor/r_m3/register/goal_position/value.json'; 
    r_m4 ='http://127.0.0.1:3030/motor/r_m4/register/goal_position/value.json'; 
    r_m5 ='http://127.0.0.1:3030/motor/r_m5/register/goal_position/value.json'; 
    %--------------- send angle information for each motor ---(------------
    urlread2(elbow_y,'post',num2str(l_elbow_y),header);
    urlread2(shoulder_x,'post',num2str(-1*l_shoulder_x),header);
    urlread2(shoulder_y,'post',num2str(l_shoulder_y),header);
    urlread2(arm_z,'post',num2str(-90),header);    
    urlread2(r_m2,'post',num2str(ang12(1)),header);
    urlread2(r_m3,'post',num2str(ang12(2)),header);
    urlread2(r_m4,'post',num2str(round(poignet)),header);
    urlread2(r_m5,'post',num2str(motor_r_m5),header);                   
    %----------------- ( Read angle information ) ------------------------
    angle_Wrist=urlread('http://127.0.0.1:3030/motor/r_m4/register/present_position');
    
        for i=1:size(angle_Wrist,2)
            if (angle_Wrist(1,i)=='}')   
             for j=1:size(angle_Wrist,2)
                 if (angle_Wrist(1,j)==':')
                     set (handles.angWrist, 'string',angle_Wrist(1,(j+1):(i-1))) ; 
                 end
             end
            end
        end    
    %---------------------------------------------------------------------
            
end    

% --- Executes on button press in connectButton.
function connectButton_Callback(hObject, eventdata, handles)
global timer1 ;
% hObject    handle to connectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(hObject,'String'),'Connect') % currently disconnected
        try  
           start(timer1)  % start the timer
           set(hObject, 'String','Disconnect')
        catch e
            errordlg(e.message);
        end
else   
    set(hObject, 'String','Connect')
    stop(timer1)          % stop the timer if it is already initialized
end
guidata(hObject, handles);


function operacion_alto_Callback(hObject, eventdata, handles)
% hObject    handle to operacion_alto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of operacion_alto as text
%        str2double(get(hObject,'String')) returns contents of operacion_alto as a double


% --- Executes during object creation, after setting all properties.
function operacion_alto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to operacion_alto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function operacion_alto_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to operacion_alto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function connectButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to connectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit27_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double


% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit28_Callback(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit28 as text
%        str2double(get(hObject,'String')) returns contents of edit28 as a double


% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% retroceder hasta aqui



function angleq0_Callback(hObject, eventdata, handles)
% hObject    handle to angleq0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of angleq0 as text
%        str2double(get(hObject,'String')) returns contents of angleq0 as a double


% --- Executes during object creation, after setting all properties.
function angleq0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angleq0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function angleq1_Callback(hObject, eventdata, handles)
% hObject    handle to angleq1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of angleq1 as text
%        str2double(get(hObject,'String')) returns contents of angleq1 as a double


% --- Executes during object creation, after setting all properties.
function angleq1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angleq1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function angleq2_Callback(hObject, eventdata, handles)
% hObject    handle to angleq2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of angleq2 as text
%        str2double(get(hObject,'String')) returns contents of angleq2 as a double


% --- Executes during object creation, after setting all properties.
function angleq2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angleq2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on slider movement.
function poignet_Callback(hObject, eventdata, handles)
% hObject    handle to poignet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function poignet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to poignet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function angWrist_Callback(hObject, eventdata, handles)
% hObject    handle to angWrist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of angWrist as text
%        str2double(get(hObject,'String')) returns contents of angWrist as a double


% --- Executes during object creation, after setting all properties.
function angWrist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angWrist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function max_pos_gripper_Callback(hObject, eventdata, handles)
% hObject    handle to max_pos_gripper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_pos_gripper as text
%        str2double(get(hObject,'String')) returns contents of max_pos_gripper as a double


% --- Executes during object creation, after setting all properties.
function max_pos_gripper_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_pos_gripper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function min_pos_gripper_Callback(hObject, eventdata, handles)
% hObject    handle to min_pos_gripper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min_pos_gripper as text
%        str2double(get(hObject,'String')) returns contents of min_pos_gripper as a double


% --- Executes during object creation, after setting all properties.
function min_pos_gripper_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min_pos_gripper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
