
function varargout = MeasurementViewer2(varargin)
% MEASUREMENTVIEWER2 MATLAB code for MeasurementViewer2.fig
%      MEASUREMENTVIEWER2, by itself, creates a new MEASUREMENTVIEWER2 or raises the existing
%      singleton*.
%
%      H = MEASUREMENTVIEWER2 returns the handle to a new MEASUREMENTVIEWER2 or the handle to
%      the existing singleton*.
%
%      MEASUREMENTVIEWER2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MEASUREMENTVIEWER2.M with the given input arguments.
%
%      MEASUREMENTVIEWER2('Property','Value',...) creates a new MEASUREMENTVIEWER2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MeasurementViewer2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MeasurementViewer2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MeasurementViewer2

% Last Modified by GUIDE v2.5 02-Apr-2016 12:13:13

% changeslog: lines 477-479, datetick on x-axis, ES, 2.4.2011 
%                            added busy button, GP, 15.6.2011

%                            Zoom, Sortierfunktion der Datenpunktliste,
%                            Excel-Export, Auswahl der Datenbank, 
%                            TS, 19.03.2012

%                            +1 Tag Button hinzugefÃ¼gt, TS, 27.04.12
%                            ToDo: ÃœberprÃ¼fung ob Enddatum existiert
%                            einfÃ¼gen

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MeasurementViewer2_OpeningFcn, ...
                   'gui_OutputFcn',  @MeasurementViewer2_OutputFcn, ...
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


% --- Executes just before MeasurementViewer2 is made visible.
function MeasurementViewer2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MeasurementViewer2 (see VARARGIN)
% Image input
axes(handles.axes2);
imshow('logos\logoHAW.png');
axes(handles.axes3);
imshow('logos\OBSERVE.png');
axes(handles.axes1);
setAllowAxesZoom(zoom,[handles.axes2,handles.axes3],false); 
% Choose default command line output for MeasurementViewer2
% write initial items in listboxes
handles.output = hObject;
set(handles.listbox1,'String','database','Value',1)
set(handles.listbox2,'Max',2)
set(handles.listbox3,'String','Variables','Value',1)
set(handles.listbox3,'String','Year','Value',1)
set(handles.listbox4,'String','Month','Value',1)
set(handles.listbox5,'String','Day','Value',1)
set(handles.listbox6,'String','Time','Value',1)
set(handles.listbox7,'String','Year','Value',1)
set(handles.listbox8,'String','Month','Value',1)
set(handles.listbox9,'String','Day','Value',1)
set(handles.listbox10,'String','Time','Value',1)
% Start change, TS, 19.03.2012
% End change, TS, 19.03.2012
%change Müller 22.07.15
% x=dir(fullfile('*.xlsx'));
cd(fileparts(mfilename('fullpath')));
%16.09.2015 Usercheck
if exist('user','dir')==7
    oldFolder = cd('user');
    users=dir(fullfile('*.mat'));
    users=strrep(cellstr(char(users.name)),'.mat','');
end
if exist('user','dir')==0
    mkdir('user');
    oldFolder = cd('user');
    users=dir(fullfile('*.mat'));
    users=strrep(cellstr(char(users.name)),'.mat','');
end
cd(oldFolder);
if isempty(users)==1
    set(handles.popupmenu6,'String','keine Benutzer')
else
    set(handles.popupmenu6,'String',users)
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MeasurementViewer2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MeasurementViewer2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Benutzerdaten
if get(handles.checkbox5,'Value')==1
    benutzername=get(handles.edit3,'String');
    passwort=get(handles.edit4,'String');
    Savefiles.saveUserdata(benutzername, passwort);
else
    benutzerN=get(handles.popupmenu6,'String');
    benutzerP=get(handles.popupmenu6,'Value');
    benutzer=char(benutzerN(benutzerP,:));
    [benutzername, passwort]=Savefiles.getUserdata(benutzer);
end
dbhost=handles.dbhost;
pos=get(handles.listbox1,'Value');
tbname=get(handles.listbox1,'String');
object=char(tbname(pos,:));
% Start change, gp, 15.6.11 - Set TextEdit to Busy
set(handles.edit1,'BackgroundColor','red')
set(handles.edit1,'String','Busy')
pause(0.0001) % won't work without this - End of change
if get(handles.popupmenu2,'Value')<=2
    varnames=gettbvarlist(tbname{pos},dbhost);
end
if get(handles.popupmenu2,'Value')==3
    varnames={'test1','test2'};
end
if get(handles.popupmenu2,'Value')==4
    % alt, neu-> varnames aus BData
%     x=dir(fullfile('*.xlsx'));
%     filematname=Dataimport.excelimport(x);
%     load(filematname,'list');
%     a=strfind(list(1:end, 3),char(tbname(pos,:)));
%     b=find(~cellfun(@isempty, a));
%     varnames=list(b(1):b(end),2);
    BData=Dataimport.getBData(object, benutzername, passwort);
    varnames=BData(2:end,11);
    cNrs=BData(2:end,10);
    vars=strcat(cNrs,':_',varnames);
end
% Start change, TS, 19.03.2012 - Sortierung und Anzeige der Listboxen in Cxxx und alphabetischer Sortierung
%[~, erg_sort]=sort(upper(varnames(:,1))); % alphabetische Sortierung
%[~, erg_sort_c]=sort(varnames(:,2)); % cXXX Sortierung

 %varnames_sort=varnames(erg_sort,1); % Sortierung der Strings
 %varnames_sort_c4a=varnames(erg_sort,2); % Sortierung der cXXX in der Reihenfolge der Strings
 %varnames_sort_a4c=varnames(erg_sort_c,1); % Sortierung der Strings in der Reihenfolge der cXXX
 %varnames_sort_c=varnames(erg_sort_c,2); % Sortierung der cXXX

% Reihenfolge der Sortierung Speichern fÃ¼r den Exel-export
%handles.Reihenfolge_c=erg_sort_c;

%for i=1:length(varnames) %vorübergehend inaktiviert
%     varnames_sort{i}=[varnames_sort{i},' ',varnames_sort_c4a{i}]; % Strings mit Namen + cXXX bauen
%     varnames_sort_c{i}=[varnames_sort_c{i},' ',varnames_sort_a4c{i}]; % Strings mit cXXXX + Namen bauen
%end

set(handles.listbox2,'String',vars,'Value',1) % String Listbox
set(handles.listbox2,'Enable','on');


%handles.Data=varnames(erg_sort,2); % Vertauschungen anpassen
%handles.Data_c=varnames(erg_sort_c,2); % Vertauschungen anpassen

% End change, TS, 19.03.2012
guidata(hObject, handles);
if get(handles.popupmenu2,'Value')<=2
    years=gettbyearlist(tbname{pos},dbhost);
end
if get(handles.popupmenu2,'Value')==3
    years={'test','testb'};
end
if get(handles.popupmenu2,'Value')==4
    years='Years';
end
    
% Start change, gp, 15.6.11 - Set TextEdit to Idle
set(handles.edit1,'BackgroundColor',[0 0.498 0])
set(handles.edit1,'String','Idle')
pause(0.0001) % won't work without this - End of change
set(handles.listbox3,'String',years,'Value',1)
set(handles.listbox4,'String','Month','Value',1)
set(handles.listbox5,'String','Day','Value',1)
set(handles.listbox6,'String','Time','Value',1)
set(handles.listbox7,'String','Year','Value',1)
set(handles.listbox8,'String','Month','Value',1)
set(handles.listbox9,'String','Day','Value',1)
set(handles.listbox10,'String','Time','Value',1)
%Aktivierung der Sortierung
set(handles.pushbutton11,'Enable','on')
set(handles.pushbutton12,'Enable','on')
cla(handles.axes1)
% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2
set(handles.edit1,'BackgroundColor','red')
set(handles.edit1,'String','Busy')
pause(0.0001) % won't work without this - End of change
postable=get(handles.listbox1,'Value');
tbname=get(handles.listbox1,'String');
vaname=get(handles.listbox2,'String');
vapos=get(handles.listbox2,'Value');
N_parameter=length(vapos);
vaVector=isscalar(vapos); %1=ein Element ausgewählt, 0=mehrere Elemente ausgewählt
object=tbname(postable,:);
datenpunkte=vaname(vapos,:);
%Zeitgrenzen alt (durch Excelliste)
% x=dir(fullfile('*.xlsx'));
% filematname=Dataimport.excelimport(x);
% load(filematname,'list');
% a=strfind(list(1:end, 3),char(tbname(postable,:)));
% b=find(~cellfun(@isempty, a));
% tf=list(b(vapos),4);
% tt=list(b(vapos),5);
% tf=strjoin(tf);
% tt=strjoin(tt);
% tf=strsplit(tf,' ');
% tt=strsplit(tt,' ');
% tf=strcat(tf(1),'T',tf(2),'Z');
% tt=strcat(tt(1),'T',tt(2),'Z');
tf = datetime(double.empty(0,3));
tt = datetime(double.empty(0,3));
for a=1:N_parameter
    [~,~,tfx,ttx]=Dataimport.getMP_Info(char(object), char(datenpunkte(a)));
    if strcmp(tfx,'Error')==0
        tf(a)=datetime(tfx,'InputFormat','yyyy-MM-dd''T''HH:mm:ssXXXX','TimeZone','UTC');
        tt(a)=datetime(ttx,'InputFormat','yyyy-MM-dd''T''HH:mm:ssXXXX','TimeZone','UTC');
    end
end
tf=tf';
tt=tt';
%neu->aus Datenbank
% if vaVector==1
%     [~,~,tf,tt]=Dataimport.getMP_Info(char(tbname(postable,:)), vaname(vapos,:));
% else
%     
%     [~,~,tf,tt]=Dataimport.getMP_Info2(char(tbname(postable,:)), vaname(vapos,:));
% end

%Eintragen in Download-Auswahlbox
y1=year(tf);
y2=year(tt);
years=y1:y2;
set(handles.listbox13,'String',years,'Value',1)

%Schnittmenge der Zeiten zur Auswahl
tf=min(tf);
tt=max(tt);
save('time.mat','tf','tt','vaVector');


%Eintragen in Plot-Auswahlbox
    y1=year(tf);
    y2=year(tt);
    years=y1:y2;
% if tf<tt
    set(handles.listbox3,'String',years)
    %Listboxen zur Zeitauswahl aktivieren
    set(handles.listbox3,'Enable','on')
    set(handles.listbox4,'Enable','on')
    set(handles.listbox5,'Enable','on')
    set(handles.listbox6,'Enable','on')
    set(handles.listbox7,'Enable','on')
    set(handles.listbox8,'Enable','on')
    set(handles.listbox9,'Enable','on')
    set(handles.listbox10,'Enable','on')
% else
%     set(handles.listbox3,'Enable','off')
%     set(handles.listbox4,'Enable','off')
%     set(handles.listbox5,'Enable','off')
%     set(handles.listbox6,'Enable','off')
%     set(handles.listbox7,'Enable','off')
%     set(handles.listbox8,'Enable','off')
%     set(handles.listbox9,'Enable','off')
%     set(handles.listbox10,'Enable','off')
%     set(handles.listbox4,'String','')
%     set(handles.listbox5,'String','')
%     set(handles.listbox6,'String','')
%     set(handles.listbox7,'String','')
%     set(handles.listbox8,'String','')
%     set(handles.listbox9,'String','')
%     set(handles.listbox10,'String','')
%     set(handles.listbox3,'String','')
% end


set(handles.pushbutton10,'Enable','on')

set(handles.edit1,'BackgroundColor',[0 0.498 0])
set(handles.edit1,'String','Idle')

pause(0.0001) % won't work without this - End of change
cla(handles.axes1)
% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dbhost=handles.dbhost;
pos=get(handles.listbox3,'Value');
yearname=get(handles.listbox3,'String');
postable=get(handles.listbox1,'Value');
tbname=get(handles.listbox1,'String');
load('time.mat','tf','tt');
% Start change, gp, 15.6.11 - Set TextEdit to Busy
set(handles.edit1,'BackgroundColor','red')
set(handles.edit1,'String','Busy')
pause(0.0001) % won't work without this - End of change
if get(handles.popupmenu2,'Value')<=2
    m=gettbmonthlist(tbname{postable,:},yearname(pos,:),dbhost);
end
if get(handles.popupmenu2,'Value')==3
    m={'test','testb'};
end
if get(handles.popupmenu2,'Value')==4 % edit OBSERVE
    if str2double(yearname(pos,:))>year(tf)
        m1=1;
    end
    if str2double(yearname(pos,:))==year(tf)
        m1=month(tf);
    end
    if str2double(yearname(pos,:))<year(tt)
        m2=12;
    end
    if str2double(yearname(pos,:))==year(tt)
        m2=month(tt);
    end
    m=m1:m2;
end
% Start change, gp, 15.6.11 - Set TextEdit to Idle
set(handles.edit1,'BackgroundColor',[0 0.498 0])
set(handles.edit1,'String','Idle')
pause(0.0001) % won't work without this - End of change
set(handles.listbox4,'String',m,'Value',1)
set(handles.listbox5,'String','Day','Value',1)
set(handles.listbox6,'String','Time','Value',1)
set(handles.listbox7,'String','Year','Value',1)
set(handles.listbox8,'String','Month','Value',1)
set(handles.listbox9,'String','Day','Value',1)
set(handles.listbox10,'String','Time','Value',1)
%Listboxen zur Zeitauswahl aktivieren
set(handles.listbox4,'Enable','on')
cla(handles.axes1)
% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox4.
function listbox4_Callback(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dbhost=handles.dbhost;
pos=get(handles.listbox3,'Value');
yearname=get(handles.listbox3,'String');
postable=get(handles.listbox1,'Value');
tbname=get(handles.listbox1,'String');
posmonth=get(handles.listbox4,'Value');
monthname=get(handles.listbox4,'String');
load('time.mat','tf','tt');
% Start change, gp, 15.6.11 - Set TextEdit to Busy
set(handles.edit1,'BackgroundColor','red')
set(handles.edit1,'String','Busy')
pause(0.0001) % won't work without this - End of change
if get(handles.popupmenu2,'Value')<=2 % edit OBSERVE
    d=gettbdaylist(tbname{postable,:},yearname(pos,:),monthname(posmonth,:),dbhost);
end
if get(handles.popupmenu2,'Value')==3
    d={'test','testb'};
end
if get(handles.popupmenu2,'Value')==4 % edit OBSERVE
    %[~,txt]=xlsread('2014-04-20_zp_liste',1,'C:D');
    %buildings=txt(2:end, 1);
    %for k=1:length(buildings)
    %    if strcmp(buildings(k),tbname)==1
    %        maxw=k;
    %    end
    %end
    %for k=1:length(buildings)
    %    if strcmp(buildings(k),tbname)==1
    %        minw=k;
    %        break
    %    end
    %end
    %datesfrom=txt(2:end, 2);
    %datesfrom=datesfrom(minw:maxw);
    %datesfrom=strjoin(datesfrom);
    %datesfrom=strsplit(datesfrom,{' ','-'});
    %day=datesfrom(3:4:end);
    %day=unique(day);
    if str2double(yearname(pos,:))>year(tf)
        d1=1;
    end
    if str2double(yearname(pos,:))==year(tf)
        if str2double(monthname(posmonth,:))>month(tf)
            d1=1;
        end
        if str2double(monthname(posmonth,:))==month(tf)
            d1=day(tf);
        end
    end
    if str2double(yearname(pos,:))<year(tt)
        d2=31;
    end
    if str2double(yearname(pos,:))==year(tt)
        if str2double(monthname(posmonth,:))<month(tt)
            d2=31;
        end
        if str2double(monthname(posmonth,:))==month(tt)
            d2=day(tt);
        end
    end
    d=d1:d2;
end
% Start change, gp, 15.6.11 - Set TextEdit to Idle
set(handles.edit1,'BackgroundColor',[0 0.498 0])
set(handles.edit1,'String','Idle')
pause(0.0001) % won't work without this - End of change
set(handles.listbox5,'String',d,'Value',1)
set(handles.listbox6,'String','Time','Value',1)
set(handles.listbox7,'String','Year','Value',1)
set(handles.listbox8,'String','Month','Value',1)
set(handles.listbox9,'String','Day','Value',1)
set(handles.listbox10,'String','Time','Value',1)
%Listboxen zur Zeitauswahl aktivieren
set(handles.listbox5,'Enable','on')
cla(handles.axes1)
% Start change, ts, 21.03.12
handles.BeginDateIsReady=0;
guidata(hObject, handles);
% End change, ts
% Hints: contents = cellstr(get(hObject,'String')) returns listbox4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox4


% --- Executes during object creation, after setting all properties.
function listbox4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox5.
function listbox5_Callback(hObject, eventdata, handles)
% hObject    handle to listbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dbhost=handles.dbhost;
pos=get(handles.listbox3,'Value');
yearname=get(handles.listbox3,'String');
postable=get(handles.listbox1,'Value');
tbname=get(handles.listbox1,'String');
posmonth=get(handles.listbox4,'Value');
monthname=get(handles.listbox4,'String');
posday=get(handles.listbox5,'Value');
dayname=get(handles.listbox5,'String');
load('time.mat','tf','tt');
% Start change, gp, 15.6.11 - Set TextEdit to Busy
set(handles.edit1,'BackgroundColor','red')
set(handles.edit1,'String','Busy')
pause(0.0001) % won't work without this - End of change
if get(handles.popupmenu2,'Value')<=2 % edit OBSERVE
    time=gettbtimelist(tbname{postable,:},yearname(pos,:),monthname(posmonth,:),dayname(posday,:),dbhost);
end
if get(handles.popupmenu2,'Value')==3
    time={'test','testb'};
end
if get(handles.popupmenu2,'Value')==4 % edit OBSERVE
    %[~,txt]=xlsread('2014-04-20_zp_liste',1,'C:D');
    %buildings=txt(2:end, 1);
    %for k=1:length(buildings)
    %    if strcmp(buildings(k),tbname)==1
    %        maxw=k;
    %    end
    %end
    %for k=1:length(buildings)
    %    if strcmp(buildings(k),tbname)==1
    %        minw=k;
    %        break
    %    end
    %end
    %datesfrom=txt(2:end, 2);
    %datesfrom=datesfrom(minw:maxw);
    %datesfrom=strjoin(datesfrom);
    %datesfrom=strsplit(datesfrom,{' ','-'});
    %time=datesfrom(4:4:end);
    %time=unique(time);
    if str2double(yearname(pos,:))==year(tf) && str2double(monthname(posmonth,:))==month(tf) && ...
       str2double(dayname(posday,:))==day(tf)
        [h1, m1, ~]=hms(tf);
    else
        h1=0;
        m1=0;
    end
    if str2double(yearname(pos,:))==year(tt) && str2double(monthname(posmonth,:))==month(tt) && ...
       str2double(dayname(posday,:))==day(tt)
        [h2, m2, ~]=hms(tt);
    else
        h2=23;
        m2=59;
    end
    time=h1:h2; %Minuten können noch ergänzt werden..
end
% Start change, gp, 15.6.11 - Set TextEdit to Idle
set(handles.edit1,'BackgroundColor',[0 0.498 0])
set(handles.edit1,'String','Idle')
pause(0.0001) % won't work without this - End of change
set(handles.listbox6,'String',time,'Value',1)
set(handles.listbox7,'String','Year','Value',1)
set(handles.listbox8,'String','Month','Value',1)
set(handles.listbox9,'String','Day','Value',1)
set(handles.listbox10,'String','Time','Value',1)
%Listboxen zur Zeitauswahl aktivieren
set(handles.listbox6,'Enable','on')
cla(handles.axes1)
% Start change, ts, 21.03.12
handles.BeginDateIsReady=0;
guidata(hObject, handles);
% End change, ts
% Hints: contents = cellstr(get(hObject,'String')) returns listbox5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox5


% --- Executes during object creation, after setting all properties.
function listbox5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox6.
function listbox6_Callback(hObject, eventdata, handles)
% hObject    handle to listbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
years=get(handles.listbox3,'String');
set(handles.listbox7,'String',years,'Value',1)
set(handles.listbox8,'String','Month','Value',1)
set(handles.listbox9,'String','Day','Value',1)
set(handles.listbox10,'String','Time','Value',1)
%Listboxen zur Zeitauswahl aktivieren
set(handles.listbox7,'Enable','on')
cla(handles.axes1)
% Start change, ts, 21.03.12
handles.BeginDateIsReady=1;
guidata(hObject, handles);
% End change, ts, 21.03.12
% Hints: contents = cellstr(get(hObject,'String')) returns listbox6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox6


% --- Executes during object creation, after setting all properties.
function listbox6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox7.
function listbox7_Callback(hObject, eventdata, handles)
% hObject    handle to listbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dbhost=handles.dbhost;
years1=get(handles.listbox3,'String');
years=get(handles.listbox7,'String');
pos1=get(handles.listbox3,'Value');
pos=get(handles.listbox7,'Value');
load('time.mat','tf','tt');
if str2double(years1(pos1,:))>str2double(years(pos,:))
    warndlg('Enddate prior to Startdate')
else
    postable=get(handles.listbox1,'Value');
    if str2double(years1(pos1,:))==str2double(years(pos,:))
        m=get(handles.listbox4,'String');
    else
        tbname=get(handles.listbox1,'String');
        % Start change, gp, 15.6.11 - Set TextEdit to Busy
        set(handles.edit1,'BackgroundColor','red')
        set(handles.edit1,'String','Busy')
        pause(0.0001) % won't work without this - End of change
        if get(handles.popupmenu2,'Value')<=2 % edit OBSERVE
            m=gettbmonthlist(tbname{postable,:},years(pos,:),dbhost);
        end
        if get(handles.popupmenu2,'Value')==3
            m={'test','testb'};
        end
        if get(handles.popupmenu2,'Value')==4 % edit OBSERVE
            %[~,txt]=xlsread('2014-04-20_zp_liste',1,'C:D');
            %buildings=txt(2:end, 1);
            %for k=1:length(buildings)
            %    if strcmp(buildings(k),tbname)==1
            %        maxw=k;
            %    end
            %end
            %for k=1:length(buildings)
            %    if strcmp(buildings(k),tbname)==1
            %        minw=k;
            %        break
            %    end
            %end
            %datesfrom=txt(2:end, 2);
            %datesfrom=datesfrom(minw:maxw);
            %datesfrom=strjoin(datesfrom);
            %datesfrom=strsplit(datesfrom,{' ','-'});
            %month=datesfrom(2:4:end);
            %month=unique(month);
            if str2double(years(pos,:))>year(tf)
                m1=1;
            end
            if str2double(years(pos,:))==year(tf)
                m1=month(tf);
            end
            if str2double(years(pos,:))<year(tt)
                m2=12;
            end
            if str2double(years(pos,:))==year(tt)
                m2=month(tt);
            end
            m=m1:m2;
        end
        % Start change, gp, 15.6.11 - Set TextEdit to Idle
        set(handles.edit1,'BackgroundColor',[0 0.498 0])
        set(handles.edit1,'String','Idle')
        pause(0.0001) % won't work without this - End of change
    end
    set(handles.listbox8,'String',m,'Value',1)
    set(handles.listbox9,'String','Day','Value',1)
    set(handles.listbox10,'String','Time','Value',1)
    %Listboxen zur Zeitauswahl aktivieren
set(handles.listbox8,'Enable','on')
    cla(handles.axes1)
end
% Hints: contents = cellstr(get(hObject,'String')) returns listbox7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox7


% --- Executes during object creation, after setting all properties.
function listbox7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox8.
function listbox8_Callback(hObject, eventdata, handles)
% hObject    handle to listbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dbhost=handles.dbhost;
years1=get(handles.listbox3,'String');
years=get(handles.listbox7,'String');
pos1=get(handles.listbox3,'Value');
pos=get(handles.listbox7,'Value');

month1=get(handles.listbox4,'String');
month2=get(handles.listbox8,'String');
posm1=get(handles.listbox4,'Value');
posm=get(handles.listbox8,'Value');
load('time.mat','tf','tt');
if str2double(years1(pos1,:))==str2double(years(pos,:)) && ...
        str2double(month1(posm1,:))>str2double(month2(posm,:))
    warndlg('Enddate prior to Startdate')
else
    postable=get(handles.listbox1,'Value');
    tbname=get(handles.listbox1,'String');
    if str2double(years1(pos1,:))==str2double(years(pos,:)) && ...
            str2double(month1(posm1,:))==str2double(month2(posm,:))
        d=get(handles.listbox5,'String');
    else
        % Start change, gp, 15.6.11 - Set TextEdit to Busy
        set(handles.edit1,'BackgroundColor','red')
        set(handles.edit1,'String','Busy')
        pause(0.0001) % won't work without this - End of change
        if get(handles.popupmenu2,'Value')<=2 % edit OBSERVE
            d=gettbdaylist(tbname{postable,:},years(pos,:),month2(posm,:),dbhost);
        end
        if get(handles.popupmenu2,'Value')==3
            d={'test','testb'};
        end
        if get(handles.popupmenu2,'Value')==4 % edit OBSERVE
            %[~,txt]=xlsread('2014-04-20_zp_liste',1,'C:D');
            %buildings=txt(2:end, 1);
            %for k=1:length(buildings)
            %    if strcmp(buildings(k),tbname)==1
            %        maxw=k;
            %    end
            %end
            %for k=1:length(buildings)
            %    if strcmp(buildings(k),tbname)==1
            %        minw=k;
            %        break
            %    end
            %end
            %datesfrom=txt(2:end, 2);
            %datesfrom=datesfrom(minw:maxw);
            %datesfrom=strjoin(datesfrom);
            %datesfrom=strsplit(datesfrom,{' ','-'});
            %days=datesfrom(3:4:end);
            %days=unique(month);
            if str2double(years(pos,:))>year(tf)
                d1=1;
            end
            if str2double(years(pos,:))==year(tf)
                if str2double(month2(posm,:))>month(tf)
                    d1=1;
                end
                if str2double(month2(posm,:))==month(tf)
                d1=day(tf);
                end
            end
            if str2double(years(pos,:))<year(tt)
                d2=31;
            end
            if str2double(years(pos,:))==year(tt)
                if str2double(month2(posm,:))<month(tt)
                    d2=31;
                end
                if str2double(month2(posm,:))==month(tt)
                    d2=day(tt);
                end
            end
            d=d1:d2;
        end
        % Start change, gp, 15.6.11 - Set TextEdit to Idle
        set(handles.edit1,'BackgroundColor',[0 0.498 0])
        set(handles.edit1,'String','Idle')
        pause(0.0001) % won't work without this - End of change
    end
    set(handles.listbox9,'String',d,'Value',1)
    set(handles.listbox10,'String','Time','Value',1)
    %Listboxen zur Zeitauswahl aktivieren
set(handles.listbox9,'Enable','on')
    cla(handles.axes1)
end
% Hints: contents = cellstr(get(hObject,'String')) returns listbox8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox8


% --- Executes during object creation, after setting all properties.
function listbox8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox9.
function listbox9_Callback(hObject, eventdata, handles)
% hObject    handle to listbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dbhost=handles.dbhost;
years1=get(handles.listbox3,'String');
years=get(handles.listbox7,'String');
pos1=get(handles.listbox3,'Value');
pos=get(handles.listbox7,'Value');

month1=get(handles.listbox4,'String');
month2=get(handles.listbox8,'String');
posm1=get(handles.listbox4,'Value');
posm=get(handles.listbox8,'Value');

day1=get(handles.listbox5,'String');
day2=get(handles.listbox9,'String');
posd1=get(handles.listbox5,'Value');
posd=get(handles.listbox9,'Value');
load('time.mat','tf','tt');

if str2double(years1(pos1,:))==str2double(years(pos,:)) && ...
        str2double(month1(posm1,:))==str2double(month2(posm,:)) && ...
        str2double(day1(posd1,:))>str2double(day2(posd,:))
    warndlg('Enddate prior to Startdate')
else
    postable=get(handles.listbox1,'Value');
    tbname=get(handles.listbox1,'String');
    if str2double(years1(pos1,:))==str2double(years(pos,:)) && ...
            str2double(month1(posm1,:))==str2double(month2(posm,:)) && ...
            str2double(day1(posd1,:))==str2double(day2(posd,:))
        time=get(handles.listbox6,'String');
    else
        % Start change, gp, 15.6.11 - Set TextEdit to Busy
        set(handles.edit1,'BackgroundColor','red')
        set(handles.edit1,'String','Busy')
        pause(0.0001) % won't work without this - End of change
        if get(handles.popupmenu2,'Value')<=2 % edit OBSERVE
            time=gettbtimelist(tbname{postable,:},years(pos,:),month2(posm,:),day2(posd,:),dbhost);
        end
        if get(handles.popupmenu2,'Value')==3
            time={'test','testb'};
        end
        if get(handles.popupmenu2,'Value')==4 % edit OBSERVE
            %[~,txt]=xlsread('2014-04-20_zp_liste',1,'C:D');
            %buildings=txt(2:end, 1);
            %for k=1:length(buildings)
            %    if strcmp(buildings(k),tbname)==1
            %        maxw=k;
            %    end
            %end
            %for k=1:length(buildings)
            %    if strcmp(buildings(k),tbname)==1
            %        minw=k;
            %        break
            %    end
            %end
            %datesfrom=txt(2:end, 2);
            %datesfrom=datesfrom(minw:maxw);
            %datesfrom=strjoin(datesfrom);
            %datesfrom=strsplit(datesfrom,{' ','-'});
            %time=datesfrom(4:4:end);
            %time=unique(time);
            if str2double(years(pos,:))==year(tf) && str2double(month2(posm,:))==month(tf) && ...
               str2double(day2(posd,:))==day(tf)
                [h1, ~, ~]=hms(tf);
            else
                h1=0;
            end
            if str2double(years(pos,:))==year(tt) && str2double(month2(posm,:))==month(tt) && ...
                str2double(day2(posd,:))==day(tt)
                [h2, ~, ~]=hms(tt);
            else
                h2=23;
            end
        time=h1:h2; %Minuten können noch ergänzt werden..
        end
        % Start change, gp, 15.6.11 - Set TextEdit to Idle
        set(handles.edit1,'BackgroundColor',[0 0.498 0])
        set(handles.edit1,'String','Idle')
        pause(0.0001) % won't work without this - End of change
    end
    set(handles.listbox10,'String',time,'Value',1)
    %legend()
    %Listboxen zur Zeitauswahl aktivieren
    set(handles.listbox10,'Enable','on')
    cla(handles.axes1)
end
% Hints: contents = cellstr(get(hObject,'String')) returns listbox9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox9


% --- Executes during object creation, after setting all properties.
function listbox9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox10.
function listbox10_Callback(hObject, eventdata, handles)
% hObject    handle to listbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dbhost=handles.dbhost;
years1=get(handles.listbox3,'String');
years=get(handles.listbox7,'String');
pos1=get(handles.listbox3,'Value');
pos=get(handles.listbox7,'Value');

month1=get(handles.listbox4,'String');
month=get(handles.listbox8,'String');
posm1=get(handles.listbox4,'Value');
posm=get(handles.listbox8,'Value');

day1=get(handles.listbox5,'String');
day=get(handles.listbox9,'String');
posd1=get(handles.listbox5,'Value');
posd=get(handles.listbox9,'Value');

post1=get(handles.listbox6,'Value');
post=get(handles.listbox10,'Value');

benutzername=get(handles.edit3,'String');
passwort=get(handles.edit4,'String');

if str2double(years1(pos1,:))==str2double(years(pos,:)) && ...
        str2double(month1(posm1,:))==str2double(month(posm,:)) && ...
        str2double(day1(posd1,:))==str2double(day(posd,:)) && ...
        post1>post
    warndlg('Enddate prior to Startdate')
else
    postable=get(handles.listbox1,'Value');
    tbname=get(handles.listbox1,'String');
    stpos=get(handles.listbox6,'Value');
    stname=get(handles.listbox6,'String');
    st=stname(stpos,:);
    etpos=get(handles.listbox10,'Value');
    etname=get(handles.listbox10,'String');
    et=etname(etpos,:);
    % Start change, TS, 19.03.2012 - Werte werden aus der aktuell 
    % sichtbaren Listbox fÃ¼r Datenbankanfrage genommen

    %if (get(handles.popupmenu1,'value')==2)
        vapos=get(handles.listbox2,'Value');
        vaname=get(handles.listbox2,'String');
        %va=handles.Data(vapos); e.Observe
    %else
    %    vapos=get(handles.listbox11,'Value');
    %    vaname=get(handles.listbox11,'String');
        %va=handles.Data_c(vapos); e.Observe
    %end
    % End change, TS, 19.03.2012
    % Start change, gp, 15.6.11 - Set TextEdit to Busy
    set(handles.edit1,'BackgroundColor','red')
    set(handles.edit1,'String','Busy')
    pause(0.0001) % won't work without this - End of change
    if get(handles.popupmenu2,'Value')<=2 % edit OBSERVE
        [values,time]=gettbvarvalues(tbname{postable},va,st,et,dbhost);
    end
    
%     if get(handles.popupmenu2,'Value')==4 % edit OBSERVE
%         filematname=Dataimport.excelimport(get(handles.edit5,'String'));
%         load(filematname,'list');
%         a=strfind(list(1:end, 3),char(tbname(postable,:)));
%         b=find(~cellfun(@isempty, a));
%         id=list(b(vapos),1);
%         id=char(id);
%         starttime=datetime(str2double(years1(pos1,:)),str2double(month1(posm1,:)),str2double(day1(posd1,:)),str2double(st),0,0);
%         endtime=datetime(str2double(years(pos,:)),str2double(month(posm,:)),str2double(day(posd,:)),str2double(et),0,0);
%         [time, values]=Dataimport.getTV(benutzername,passwort,id,starttime,endtime);
%         set(handles.checkbox3,'visible','on')
%     end
    
    if get(handles.popupmenu2,'Value')==3 % edit OBSERVE
        [time,values]=Dataimport.urlimport('https://observe.interwatt.net/api/ObserveSchnittstelle/ZwValues?username=F.M%C3%BCller&password=tempoR!?2&id=A0DC5AD8-EBD0-476F-AAF6-0D60FFCF9142&FromUtc=2014-11-01T00:00:00Z&ToUtc=2014-11-02T00:00:00Z&Type=raw&Resolution=5min');
    end
    
    %save Variables to save_Folder
%     oldFolder = cd('save');
%     va=vaname(vapos,:);
%     ob=tbname(postable,:);
%     filename=char(strcat(ob,'__',va)); %Objektname von Vaname durch zwei Unterstriche getrennt
%     if exist(char(strcat(filename,'.mat')),'file')==2
%         %x=input (strcat('Die Datei ',filename,' existiert bereits. Soll die Datei überschrieben werden? (j/n)'));
%         cd (oldFolder);
%     else
%         save(filename,'time','values','id');
%         cd (oldFolder);
%     end
    
    % Start change, gp, 15.6.11 - Set TextEdit to Idle
    set(handles.edit1,'BackgroundColor',[0 0.498 0])
    set(handles.edit1,'String','Idle')
    set(handles.pushbutton9,'Enable','on')
    pause(0.0001) % won't work without this - End of change
    guidata(hObject, handles);
    % End change, TS, 19.03.2012
end
% Hints: contents = cellstr(get(hObject,'String')) returns listbox10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox10


% --- Executes during object creation, after setting all properties.
function listbox10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% Start change, TS, 19.03.2012 - Zoom
function uitoggletool1_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%zoomAdaptiveDateTicks('on')


% --------------------------------------------------------------------
% Start change, TS, 19.03.2012 - Excel Export 
function uipushtool2_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dbhost=handles.dbhost;

set(handles.edit1,'BackgroundColor','red')
set(handles.edit1,'String','Busy')
pause(0.0001) % won't work without this
% save date and time as string

time=datestr(handles.PlotDataTime);
% checking the size of the plot data for the struct
[m,n]=size(handles.PlotDataVal);
% creating the output Cell
outputCell = cell(length(time),n+2);
% put the date in the first column, the time in the second
% [outputCell(:,1),outputCell(:,2)]=strtok(cellstr(time)); % Version die
% Nach dem Leerzeichen sucht und dort aufteilt (langsam)
[outputCell(:,1:2)]=([cellstr(time(:,1:10)),cellstr(time(:,12:19))]); % Version die einfach nur nach 11 Zeichen trennt (schnell)
% put the plot data in the output cell
outputCell(:,3:n+2)=num2cell(handles.PlotDataVal);
headerOutputCell=cell(4,n); % Bereich fÃ¼r die Header-Daten erzeugen

pos=get(handles.listbox1,'Value');
tbname=get(handles.listbox1,'String');


% Einheiten etc. aus der Datenbank holen
sql=['SELECT unit, source, longname FROM ',tbname{pos},'_info order by col'];
list=dbaccess(sql,dbhost);
del=strncmp('null', list(:,2),4); % null EintrÃ¤ge entfernen
list=[list(~del,1:3)];
unitList=list(:,1);
sourceList=list(:,2);
longNameList2=list(:,3);


%%%%% Long Names finden und einfÃ¼gen
if (get(handles.popupmenu1,'value')==2)
    longNameList=get(handles.listbox2,'String');
    longName=longNameList(get(handles.listbox2,'Value'));
    unitList=unitList(handles.Reihenfolge);
    unit=unitList(get(handles.listbox2,'Value'));
    sourceList=sourceList(handles.Reihenfolge);
    source=sourceList(get(handles.listbox2,'Value'));
    longNameList2=longNameList2(handles.Reihenfolge);
    longName2=longNameList2(get(handles.listbox2,'Value'));
    % Sortierung der Einheiten
else
    longNameList=get(handles.listbox11,'String');
    longName=longNameList(get(handles.listbox11,'Value'));
    unitList=unitList(handles.Reihenfolge_c);
    unit=unitList(get(handles.listbox11,'Value'));
    sourceList=sourceList(handles.Reihenfolge_c);
    source=sourceList(get(handles.listbox11,'Value'));
    longNameList2=longNameList2(handles.Reihenfolge_c);
    longName2=longNameList2(get(handles.listbox11,'Value'));
    
end



for i=1:n
    headerOutputCell(1,i)=longName(i);
    headerOutputCell(2,i)=longName2(i);
    headerOutputCell(3,i)=source(i);
    headerOutputCell(4,i)=unit(i);
end

%%%%
set(handles.edit1,'BackgroundColor',[0 0.498 0])
set(handles.edit1,'String','Idle')
pause(0.0001) % won't work without this

% save dialog
[FileName,FilePath] = uiputfile({'*.xls';'*.xlsx'});
set(handles.edit1,'BackgroundColor','red')
set(handles.edit1,'String','Busy')
pause(0.0001) % won't work without this
% only save if okay was chosen
if ischar(FileName) && ischar(FilePath)
    short_xlswrite(FileName, FilePath, headerOutputCell,'C1')
    short_xlswrite(FileName, FilePath, outputCell,'A5')
end
set(handles.edit1,'BackgroundColor',[0 0.498 0])
set(handles.edit1,'String','Idle')
pause(0.0001) % won't work without this


%  Auswahlbox fÃ¼r die Art der Sortierung, TS, 19.03.2012 
% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Je nach Auswahl wird die Sortierung nach cXXX oder nach dem Alphabet angezeigt

if get(handles.popupmenu1,'Value') == 1
   set(handles.listbox11,'visible','on')
   set(handles.listbox2,'visible','off')
else
   set(handles.listbox11,'visible','off')
   set(handles.listbox2,'visible','on')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox12.
function listbox11_Callback(hObject, eventdata, handles)
% hObject    handle to listbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox12 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox12





% --- Executes during object creation, after setting all properties.
function listbox11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Button, um Verbindung zum ausgewÃ¤hlten Server zu starten, TS, 13.03.2012
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Benutzerdaten
if get(handles.checkbox5,'Value')==1
    benutzername=get(handles.edit3,'String');
    passwort=get(handles.edit4,'String');
    Savefiles.saveUserdata(benutzername, passwort);
else
    benutzerN=get(handles.popupmenu6,'String');
    benutzerP=get(handles.popupmenu6,'Value');
    benutzer=char(benutzerN(benutzerP,:));
    [benutzername, passwort]=Savefiles.getUserdata(benutzer);
end
handles.dbhost=(get(handles.popupmenu2,'Value'));
guidata(hObject, handles);
set(handles.edit1,'BackgroundColor','red')
set(handles.edit1,'String','Busy')
pause(0.0001) % won't work without this
%alt, neu->tblist=Dataimport.getBuildingNames(benutzermame, passwort)
%     x=dir(fullfile('*.xlsx'));
%     filematname=Dataimport.excelimport(x);
%     load(filematname,'list');
%     tblist=unique(list(2:end, 3));
[tblist,~]=Dataimport.getBuildingNames(benutzername,passwort);
set(handles.edit1,'BackgroundColor',[0 0.498 0])
set(handles.edit1,'String','Idle')
pause(0.0001) % won't work without this 
set(handles.listbox1,'String',tblist,'Value',1)
set(handles.listbox2,'Max',2)
set(handles.listbox1,'Enable','on')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Dropdown Menue zur Datenbankauswahl, TS, 19.03.2012
% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Butten um Endzeitpunkt = Anfangszeitpunkt + 1 Tag zu setzen
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Anfangsdatum einlesen

% Adresse der Datenbank
dbhost=handles.dbhost; 

% Von: Jahresliste
years1=get(handles.listbox3,'String');
% Von: Jahr : Position
pos1=get(handles.listbox3,'Value');

% Von: Monatsliste
month1=get(handles.listbox4,'String');
% Von: Monat: Position
posm1=get(handles.listbox4,'Value');

% Von: Tagesliste
day1=get(handles.listbox5,'String');
% Von: Tag: Position
posd1=get(handles.listbox5,'Value');

% Von: Stunde/Minute/Sekunde: Position
post1=get(handles.listbox6,'Value');
% Von: Stunde/Minute/Sekunde: Position
stpos=get(handles.listbox6,'Value');
% Von: Stunde/Minute/Sekunde: Liste
stname=get(handles.listbox6,'String');
% Von: Stunde/Minute/Sekunde
st=stname{stpos};

% Datenbank: Liste
tbname=get(handles.listbox1,'String');
% Datenbank: Position
postable=get(handles.listbox1,'Value');

%% ToDo: Checken ob Enddatum existiert

if ((str2num(day1(posd1,:))+1)>str2num(day1(end,:))) % Monatsumbruch?
    if ((str2num(month1(posm1,:))+1)>str2num(month1(end,:))) % Jahresumbruch?
        %% Jahresumbruch
        
        disp('Jahresumbruch')
        % Bis: Jahre
        years=years1;
        pos=pos1+1;
        % Bis: Monate
        try
            month=num2str(gettbmonthlist(tbname{postable,:},years(pos,:),dbhost));
        catch ME1
            disp('ERROR')
        end
        posm=1;

        %Buisy
        set(handles.edit1,'BackgroundColor','red')
        set(handles.edit1,'String','Busy')
        pause(0.0001) % won't work without this - End of change
    
        % Bis: Tag 
        day=num2str(gettbdaylist(tbname{postable,:},years(pos,:),month(posm,:),dbhost)); 
        posd=1; % Erster Tag
        time=gettbtimelist(tbname{postable,:},years(pos,:),month(posm,:),day(posd,:),dbhost);
        et=time{stpos};

    else
        
        disp('Monatsumbruch')
        % Bis: Jahre
        years=years1;
        pos=pos1;
        % Bis: Monate
        month=month1;
        posm=posm1+1;
    
        %Buisy
        set(handles.edit1,'BackgroundColor','red')
        set(handles.edit1,'String','Busy')
        pause(0.0001) % won't work without this - End of change
    
        % Bis: Tag 
        day=num2str(gettbdaylist(tbname{postable,:},years(pos,:),month(posm,:),dbhost)); 
        posd=1; % Erste Tag
        time=gettbtimelist(tbname{postable,:},years(pos,:),month(posm,:),day(posd,:),dbhost);
        et=time{stpos};
    end
else   

    % Bis: Jahre
    years=years1;
    pos=pos1;
    % Bis: Monate
    month=month1;
    posm=posm1;
    
    %% +1 Tag bestimmen, 
    
    % Buisy
    set(handles.edit1,'BackgroundColor','red')
    set(handles.edit1,'String','Busy')
    pause(0.0001) % won't work without this - End of change
    
    %Bis: Tag
    day=day1;
    posd=posd1+1;
    time=gettbtimelist(tbname{postable,:},years(pos,:),month(posm,:),day(posd,:),dbhost);
    et=time{stpos};
end

    % Werte werden aus der aktuell 
    % sichtbaren Listbox fÃ¼r Datenbankanfrage genommen werden
    % (Sortiertung nach A-Z oder nach Cxxx))
    if (get(handles.popupmenu1,'value')==2)
        % Datenpunkte
        vapos=get(handles.listbox2,'Value');
        vaname=get(handles.listbox2,'String');
        va=handles.Data(vapos);
    else
        % Datenpunkte
        vapos=get(handles.listbox11,'Value');
        vaname=get(handles.listbox11,'String');
        va=handles.Data_c(vapos);
    end


% AusfÃ¼hren

    [values,time]=gettbvarvalues(tbname{postable},va,st,et,dbhost);
    % Set TextEdit to Idle
    set(handles.edit1,'BackgroundColor',[0 0.498 0])
    set(handles.edit1,'String','Idle')
    pause(0.0001) % won't work without this - End of change
    plot(time,values)
    xlim([min(time) max(time)])
    datetick('x','keeplimits')
    % x-axis with timestamp
    % end of change 
    grid on
    legend(vaname(vapos),'location','best')
    % Save plotdata
    handles.PlotDataVal=values;
    handles.PlotDataTime=time;

    guidata(hObject, handles);

% Ende 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Button, der das Enddatum auf Anfangszeitpunkt +1 Monat setzt.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
%%%%%%%%%%%%%%
% Only Debug %
%%%%%%%%%%%%%%
function pushbutton8_Callback(hObject, eventdata, handles)
keyboard
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%benutzername
function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%Passwort
function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton9.
%Plot
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%NEW!!!!
%aktive Achse setzen
axes(handles.axes1);
zoom(handles.axes1,'on');
cla; %letzte Plots löschen
%Button buisy
set(handles.edit1,'BackgroundColor','red')
set(handles.edit1,'String','Busy')
pause(0.0001) % won't work without this - End of change
%string: benutzername und passwort
if get(handles.checkbox5,'Value')==1
    benutzername=get(handles.edit3,'String');
    passwort=get(handles.edit4,'String');
    Savefiles.saveUserdata(benutzername, passwort);
else
    benutzerN=get(handles.popupmenu6,'String');
    benutzerP=get(handles.popupmenu6,'Value');
    benutzer=char(benutzerN(benutzerP,:));
    [benutzername, passwort]=Savefiles.getUserdata(benutzer);
end
%string: object/Gebädue
tbname=get(handles.listbox1,'String');
postable=get(handles.listbox1,'Value');
object=char(tbname(postable,:));
%cell-array: datenpunkte
vapos=get(handles.listbox2,'Value');
vaname=get(handles.listbox2,'String');
datenpunkte=vaname(vapos,:);
N_parameter=length(vapos);
%strings: Import der Zeiten
years1=get(handles.listbox3,'String');
years=get(handles.listbox7,'String');
pos1=get(handles.listbox3,'Value');
pos=get(handles.listbox7,'Value');

month1=get(handles.listbox4,'String');
month=get(handles.listbox8,'String');
posm1=get(handles.listbox4,'Value');
posm=get(handles.listbox8,'Value');

day1=get(handles.listbox5,'String');
day=get(handles.listbox9,'String');
posd1=get(handles.listbox5,'Value');
posd=get(handles.listbox9,'Value');

post1=get(handles.listbox6,'Value');
post=get(handles.listbox10,'Value');
stpos=get(handles.listbox6,'Value');
stname=get(handles.listbox6,'String');
st=stname(stpos,:);
etpos=get(handles.listbox10,'Value');
etname=get(handles.listbox10,'String');
et=etname(etpos,:);
%vector: dataYears: Jahresspanne ermitteln
year1=years1(pos1,:);
year2=years(pos,:);
dataYears=str2double(year1):str2double(year2);
if isnan(str2double(dataYears))==0
	howManyYears=length(str2double(dataYears));
else
    howManyYears=length(dataYears);
end
%strings: type and resolution
typeN=get(handles.popupmenu4,'String');
typeP=get(handles.popupmenu4,'Value');
type=char(typeN(typeP,:));
resolutionN=get(handles.popupmenu5,'String');
resolutionP=get(handles.popupmenu5,'Value');
resolution=char(resolutionN(resolutionP,:));
%cell-arrays: datenpunkt_id,masseinheit,messgroesseB, cNr
masseinheit=cell(N_parameter,1);
cNr=cell(N_parameter,1);
messgroesseB=cell(N_parameter,1);
datenpunkt_id=cell(N_parameter,1);
legendstr=cell(N_parameter,1);
for a=1:N_parameter
	[~,datenpunkt_id(a),~,~,masseinheit(a),messgroesseB(a),~,~,cNr(a)]=Dataimport.getMP_Info(object,datenpunkte(a));
    legendstr(a)=strcat(cNr(a),'--',messgroesseB(a),'--',masseinheit(a));
end
%cell-array: filenameMat (Zeilen=Datenpunkte, Spalten=Jahre)
    filenameMat=cell(N_parameter,howManyYears);
    x=vaname(vapos,:);
    for a=1:N_parameter
        x2=char(x(a));
        va4filename=x2(8:end);
        if strcmp(strcat(type),'raw')==1
            [~,filenameMat(a,:)]=Savefiles.getFname(object,va4filename,dataYears,type,masseinheit(a),cNr(a));
        else
            [~,filenameMat(a,:)]=Savefiles.getFname(object,va4filename,dataYears,strcat(type,'_',resolution),masseinheit(a),cNr(a));
        end
    end
starttime=datetime(str2double(years1(pos1,:)),str2double(month1(posm1,:)),str2double(day1(posd1,:)),str2double(st),0,0,'TimeZone','UTC');
endtime=datetime(str2double(years(pos,:)),str2double(month(posm,:)),str2double(day(posd,:)),str2double(et),0,0,'TimeZone','UTC');
%draw Type
if get(handles.radiobutton6,'Value')==1
    drawType='*';
end
if get(handles.radiobutton7,'Value')==1
    drawType='.';
end
if get(handles.radiobutton8,'Value')==1
    drawType='-';
end



%PLOTFUNCTION
%Strings: benutzername, passwort, object,type,resolution
%Datetimes: starttime, endtime
%cell-Arrays: datenpunkte,filenameMat,datenpunkt_id
%scalars: N_parameter
for a=1:N_parameter
    datasaved=Savefiles.getDS(filenameMat(a,:));
    if datasaved==1 %(wenn alle Eintäge von datasaved=1 sind, wurden alle Jahre schon geladen.)
        thisFilenameMat=filenameMat(a,:);
%         old=cd('save');
%         load(char(thisFilenameMat),'time');
%         cd(old);
        if exist('save','dir')==7
        	oldFolder = cd('save');
        end
        if exist('save','dir')==0
        	mkdir('save');
        	oldFolder = cd('save');
        end
        if length(thisFilenameMat)==1 %%EIN Jahr des Datenpunkts von der Festlatte zu plotten
            load(char(filenameMat(a,:)),'time','values','cNr');
            if time(1)<starttime||time(end)>endtime
                aa=starttime<time;
                b=endtime>time;
                c=aa==b;
                d=find(c);
                ptime=time(d(1):d(end));
                pvalues=values(d(1):d(end));
             else
                 ptime=time;
                 pvalues=values;
%                display ('Es fehlen möglicherweise Daten.');
            end
            plot(ptime,pvalues, drawType)
            if a<N_parameter
                hold on
            end
        else  %%MEHRERE Jahre des Datenpunkts von der Festplatte zu plotten
            l=1;
                for k=1:length(thisFilenameMat)
                    load(char(thisFilenameMat(k)),'time','values','cNr');
                    l2=l+length(time)-1;
                    t(l:l2)=time;
                    v(l:l2)=values;
                    l=l2+1;
                end
                time=t;
                values=v;
                if time(1)<starttime||time(end)>endtime
                    aa=starttime<time;
                    b=endtime>time;
                    c=aa==b;
                    d=find(c);
                    ptime=time(d(1):d(end));
                    pvalues=values(d(1):d(end));
                else
                    ptime=time;
                    pvalues=values;
%                   display ('Es fehlen möglicherweise Daten.');
                end
                    plot(ptime, pvalues, drawType)
                    if a<N_parameter
                        hold on
                    end
%                   display ('Die Daten sind aktuell');
        end
        cd(oldFolder)
    else %Plot aus der Datenbank
        [time, values, error]=Dataimport.getTV(benutzername, passwort, datenpunkt_id(a),starttime,endtime, type, resolution);
        %3: Bei einem Error abbrechen
        if error~=0
            break
        end
        plot(time,values,drawType)
        if a<N_parameter
            hold on
        end
    end
end
legend(legendstr)
grid on
xlabel('time')

guidata(hObject, handles);
set(handles.edit1,'BackgroundColor',[0 0.498 0])
set(handles.edit1,'String','Idle')
pause(0.0001) % won't work without this - End of change
%###########################################################



%Plotscript.plotfunction(benutzername, passwort, object, datenpunkte, filenameMat, starttime, endtime, type, resolution, N_parameter)
% 
% 

% 
% 
% 
% load('time.mat','tf','tt','vaVector')
% 
% %get FilenameMat
% if vaVector==1
%     [~,id,~,~,masseinheit,messgroesseB,~,~,cNr]=Dataimport.getMP_Info(char(ob),vaname(vapos,:));
%     if strcmp(strcat(type),'raw')==1
%         [~,filenameMat]=Savefiles.getFname(ob,va,dataYears,type,masseinheit,cNr);
%     else
%         [~,filenameMat]=Savefiles.getFname(ob,va,dataYears,strcat(type,'_',resolution),masseinheit,cNr);
%     end
% else
%     [~,id,~,~,masseinheit,messgroesseB,~,~,cNr]=Dataimport.getMP_Info2(char(ob),vaname(vapos,:));
% end
%Button buisy
% %Daten für alle Jahre schon vorhanden?
% %(wenn alle Eintäge von datasaved=1 sind, wurden alle Jahre schon geladen.)
% if vaVector==1
%     datasaved=Savefiles.getDS(filenameMat);
%     if datasaved==1
%     %     old=cd('save');
%     %     load(char(filenameMat),'time');
%     %     cd(old);
%         starttime=datetime(str2double(years1(pos1,:)),str2double(month1(posm1,:)),str2double(day1(posd1,:)),str2double(st),0,0,'TimeZone','UTC');
%         endtime=datetime(str2double(years(pos,:)),str2double(month(posm,:)),str2double(day(posd,:)),str2double(et),0,0,'TimeZone','UTC');
%     %     if endtime>time(end)
%     %         warndlg('Die gespeicherten Daten sind nicht aktuell. Bitte laden Sie das Jahr erneut.');
%     %     else
%     %        display ('Daten sind aktuell');
%             Savefiles.plotdata(filenameMat,starttime,endtime,vaname,vapos,masseinheit,messgroesseB);
%     %     end
% %     else
%         missing=find(~datasaved);
%         missingyears=dataYears(missing);
%         choice=questdlg(strcat('Es fehlen noch Daten aus den Jahren :', mat2str(missingyears),' Sollen die Daten trotzdem angezeigt werden?'),'Datenabruf','Plot ohne Download','abbrechen','abbrechen');
%         if strcmp(choice,'Plot ohne Download')==1
%             starttime=datetime(str2double(years1(pos1,:)),str2double(month1(posm1,:)),str2double(day1(posd1,:)),str2double(st),0,0,'TimeZone','UTC');
%             endtime=datetime(str2double(years(pos,:)),str2double(month(posm,:)),str2double(day(posd,:)),str2double(et),0,0,'TimeZone','UTC');
%             %[~,id,~,~,masseinheit,messgroesseB,~,~,cNr]=Dataimport.getMP_Info(char(ob),char(va));
%             %[buildingNames, DSids]=Dataimport.getBuildingNames(benutzername, passwort);
%             %BData=Dataimport.getBData(char(ob), benutzername, passwort);
%             %[~,id]=Dataimport.getMP_Info(char(ob), char(va));
%             [time, values, error]=Dataimport.getTV(benutzername, passwort, id,starttime,endtime, type, resolution);
%             if error==0
%                 va=char(vaname(vapos,:));
%                 plot(time,values,'b*')
%                 xlabel('time')
%                 ylabel(strcat(messgroesseB,' in :',masseinheit))
%                 grid on
%                 legend(strrep(strcat(char(cNr),'-',va(8:end)),'_','.'),'location','best')
%             else
%                 return;
%             end
%         end
%     end
% else
%     starttime=datetime(str2double(years1(pos1,:)),str2double(month1(posm1,:)),str2double(day1(posd1,:)),str2double(st),0,0,'TimeZone','UTC');
%     endtime=datetime(str2double(years(pos,:)),str2double(month(posm,:)),str2double(day(posd,:)),str2double(et),0,0,'TimeZone','UTC');
%     [time1, values1, error1]=Dataimport.getTV(benutzername, passwort, id(1),starttime,endtime, type, resolution);
%     [time2, values2, error2]=Dataimport.getTV(benutzername, passwort, id(2),starttime,endtime, type, resolution);
%     if error1==0 && error2==0
%         plot(time1,values1,'b*')
%         hold on
%         plot(time2,values2,'r*')
%         xlabel('time')
%         ylabel('')
%         grid on
%         x=vaname(vapos,:);
%         x1=char(x(1));
%         x2=char(x(2));
%         cNr1=char(cNr(1));
%         cNr2=char(cNr(2));
%         str1=char(strcat(strrep(strcat(cNr1,'-',x1(8:end)),'_','.'),strcat(messgroesseB(1),' in :',masseinheit(1))));
%         str2=char(strcat(strrep(strcat(cNr2,'-',x2(8:end)),'_','.'),strcat(messgroesseB(2),' in :',masseinheit(2))));
%         legend(str1,str2)
%     else
%         return;
%     end
% end
% x=dir(fullfile('*.xlsx'));
% filematname=Dataimport.excelimport(x);
% load(filematname,'list');
% a=strfind(list(1:end, 3),char(tbname(postable,:)));
% b=find(~cellfun(@isempty, a));
% id=list(b(vapos),1);
% id=char(id);
% starttime=datetime(str2double(years1(pos1,:)),str2double(month1(posm1,:)),str2double(day1(posd1,:)),str2double(st),0,0);
% endtime=datetime(str2double(years(pos,:)),str2double(month(posm,:)),str2double(day(posd,:)),str2double(et),0,0);
% %[time, values]=Dataimport.getTV(benutzername,passwort,id,starttime,endtime);
% set(handles.checkbox3,'visible','on')
% 
% 
%     if get(handles.checkbox3,'Value')==1 %Downloadbox aktiv
%         dl=Savefiles.savedata(filename,starttime,endtime);
%         if dl==1
%             [time, values]=Dataimport.getTV(benutzername,passwort,id,starttime,endtime);
%             save(filename,'time','values','id');
%         end
%         guidata(hObject, handles);
%     end
%     
%     if get(handles.checkbox2,'Value')==1 %plotbox aktiv
%         [dv,pl]=Savefiles.plotdata(filename,starttime,endtime);
%         if get(handles.checkbox3,'Value')==0
%             if dv==0
%                 load(char(strcat(filename,'.mat')));
%             else
%                 load(char(strcat(filename,'.mat')));
%                 a=starttime<time;
%                 b=endtime>time;
%                 c=a==b;
%                 d=find(c);
%                 time=time(d(1):d(end));
%                 values=values(d(1):d(end));
%             end
%         end
%         if pl==1
%             % changed by ES 
%             plot(time,values)
%             %xlim([min(time) max(time)]) %Fehlermeldung, wenn xlim aktiviert
%             datetick('x','keeplimits')
%             % x-axis with timestamp
%             % end of change 
%             grid on
%             legend(vaname(vapos),'location','best')
%             % Start change, TS, 19.03.2012 - Save plotdata
%             handles.PlotDataVal=values;
%             handles.PlotDataTime=time;
%             guidata(hObject, handles);
%             % End change, TS, 19.03.2012
%         end
%     end
guidata(hObject, handles);
set(handles.edit1,'BackgroundColor',[0 0.498 0])
set(handles.edit1,'String','Idle')
pause(0.0001) % won't work without this - End of change
%###########################################################

% --- Executes on button press in checkbox2.
%Plot
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
%save
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox13.
function listbox13_Callback(hObject, eventdata, handles)
% hObject    handle to listbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox13 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox13


% --- Executes during object creation, after setting all properties.
function listbox13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton10.
%Download Year
function pushbutton10_Callback(hObject, eventdata, handles)
%Import der benötigten Eingaben
yearname=get(handles.listbox13,'String');
yearpos=get(handles.listbox13,'Value');
%Benutzerdaten
if get(handles.checkbox5,'Value')==1
    benutzername=get(handles.edit3,'String');
    passwort=get(handles.edit4,'String');
    Savefiles.saveUserdata(benutzername, passwort);
else
    benutzerN=get(handles.popupmenu6,'String');
    benutzerP=get(handles.popupmenu6,'Value');
    benutzer=char(benutzerN(benutzerP,:));
    [benutzername, passwort]=Savefiles.getUserdata(benutzer);
end
%16.09.2015 Usercheck
if exist('user','dir')==7
    oldFolder = cd('user');
    users=dir(fullfile('*.mat'));
    users=strrep(cellstr(char(users.name)),'.mat','');
end
if exist('user','dir')==0
    mkdir('user');
    oldFolder = cd('user');
    users=dir(fullfile('*.mat'));
    users=strrep(cellstr(char(users.name)),'.mat','');
end
cd(oldFolder);
if isempty(users)==1
    set(handles.popupmenu6,'String','keine Benutzer')
else
    set(handles.popupmenu6,'String',users)
end
postable=get(handles.listbox1,'Value');
tbname=get(handles.listbox1,'String');
vapos=get(handles.listbox2,'Value');
vaname=get(handles.listbox2,'String');
typeN=get(handles.popupmenu4,'String');
typeP=get(handles.popupmenu4,'Value');
type=char(typeN(typeP,:));
resolutionN=get(handles.popupmenu5,'String');
resolutionP=get(handles.popupmenu5,'Value');
resolution=char(resolutionN(resolutionP,:));
%Jahresanfang und Ende erzeugen
year=yearname(yearpos,:);
year1=datetime(str2double(year),1,1,0,0,0);
year2=datetime(str2double(year),12,31,23,0,0);
%get Filename (input)
vaVector=isscalar(vapos);
ob=tbname(postable,:);
if vaVector==1
    va=char(vaname(vapos,:));
    va=va(8:end);
    [datagatewayKey, id, datenVon, datenBis, masseinheit, messgroesseBezeichnung, messgroesseId, rechenaufloesung, cNr]=Dataimport.getMP_Info(char(ob), vaname(vapos,:));
else
    [datagatewayKey, id, datenVon, datenBis, masseinheit, messgroesseBezeichnung, messgroesseId, rechenaufloesung, cNr]=Dataimport.getMP_Info2(char(ob), vaname(vapos,:));
end

%ID-Abruf über BData
% id=Dataimport.getExcelID(ob,vapos);
if vaVector==1
    if strcmp(strcat(type),'raw')==1
        [~,filenameMat]=Savefiles.getFname(ob,va,year,type,masseinheit,cNr);
    else
        [~,filenameMat]=Savefiles.getFname(ob,va,year,strcat(type,'_',resolution),masseinheit,cNr);
    end
else
    if strcmp(strcat(type),'raw')==1
        [~,filenameMat]=Savefiles.getFname2(ob,vaname(vapos,:),year,type,masseinheit,cNr);
    else
        [~,filenameMat]=Savefiles.getFname2(ob,vaname(vapos,:),year,strcat(type,'_',resolution),masseinheit,cNr);
    end
end
%save('FNM.mat','filenameMat');
%Button buisy
set(handles.edit1,'BackgroundColor','red')
set(handles.edit1,'String','Busy')
pause(0.0001) % won't work without this - End of change


% 1. Daten für das gewählte Jahr schon vorhanden?
if vaVector==1
    datasaved=Savefiles.getDS(filenameMat);
else
    datasaved=0;
end

% 2. wenn Daten schon vorhanden, neu laden oder nicht laden
if datasaved==1
    choice = questdlg('Die Daten für das gewählte Jahr sind schon vorhanden.','save Data',...
    'neu laden','nicht laden','nicht laden');
    switch choice
        case 'neu laden'
            if strcmp(benutzername,'')==1 || strcmp(passwort,'')==1
                warndlg('Bitte Zugangsdaten überprüfen')
            else
                [time, values, error]=Dataimport.getTV(benutzername, passwort, id, year1, year2, type, resolution);
                if error==0
                    Savefiles.savedata(filenameMat, time, values,datagatewayKey, id, datenVon, datenBis, masseinheit, messgroesseBezeichnung, messgroesseId, rechenaufloesung, cNr);
                else
                    return;
                end
            end
    end
end

% 3. wenn Daten noch nicht vorhanden, laden und speichern
if datasaved==0
    if strcmp(benutzername,'')==1 || strcmp(passwort,'')==1
        warndlg('Bitte Zugangsdaten überprüfen')
    else
        if vaVector==1
            [time, values, error]=Dataimport.getTV(benutzername, passwort, id, year1, year2, type, resolution);
            if error==0
                Savefiles.savedata(filenameMat, time, values,datagatewayKey, id, datenVon, datenBis, masseinheit, messgroesseBezeichnung, messgroesseId, rechenaufloesung, cNr);
            else
                return;
            end
        else
            l=length(filenameMat);
%             time=cell(l,1);
%             values=cell(l,1);
%             error=cell(l,1);
            for k=1:l
                [time2, values2, error2]=Dataimport.getTV(benutzername, passwort, id(k), year1, year2, type, resolution);
%                 time(k)={time2};
%                 values(k)={values2};
%                 error(k)={error2};
                if error2==0
                    Savefiles.savedata(char(filenameMat(k)), time2, values2,char(datagatewayKey(k)), char(id(k)), char(datenVon(k)), char(datenBis(k)), char(masseinheit(k)), char(messgroesseBezeichnung(k)), char(messgroesseId(k)), char(rechenaufloesung(k)), char(cNr(k)));
                else
                    return;
                end
            end
%             save('test.mat','time','values','error');
        end
    end
end

%Button Idle
guidata(hObject, handles);
set(handles.edit1,'BackgroundColor',[0 0.498 0])
set(handles.edit1,'String','Idle')
pause(0.0001) % won't work without this - End of change

% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on selection change in popupmenu4.
%rawOrProc
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
strZ=get(handles.popupmenu4,'String');
posZ=get(handles.popupmenu4,'Value');
rawOrProc=char(strZ(posZ,:));
% 1. wenn proc ausgewählt ist, wird das Popupmenü für das Zeitraster
% aktiviert
if posZ==2
    set(handles.popupmenu5,'Enable','On');
else
    set(handles.popupmenu5,'Enable','Off');
    set(handles.popupmenu5,'Value',1);
end
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu5.
%Zeitraster
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6


% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.checkbox5,'Value')==1
    set(handles.edit3,'Enable','On');
    set(handles.edit4,'Enable','On');
else
    set(handles.edit3,'Enable','Off');
    set(handles.edit4,'Enable','Off');
end
% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
%zoom('on')
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in pushbutton11.
%alphabetisch sortieren
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
messpunkte=get(handles.listbox2,'String');
l=length(messpunkte);
str=cell(l,1);
cNrs=cell(l,1);
for k=1:l
    strk=char(messpunkte(k));
    str(k)=cellstr(strk(8:end));
    cNrs(k)=cellstr(strk(1:7));
end
messp_invers=strcat(str,cNrs);
messpunkte_alp=sort(messp_invers);
for k=1:l
    strk=char(messpunkte_alp(k));
    str(k)=cellstr(strk(1:end-7));
    cNrs(k)=cellstr(strk(end-6:end));
end
messpunkte_alp=strcat(cNrs,str);
set(handles.listbox2,'String',messpunkte_alp);


% --- Executes on button press in pushbutton12.
%nach cNr
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
messpunkte=get(handles.listbox2,'String');
messpunkte_cnr=sort(messpunkte);
set(handles.listbox2,'String',messpunkte_cnr);

%Stars
% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6

%dots
% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7

%line
% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8
