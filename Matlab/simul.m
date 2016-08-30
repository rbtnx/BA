function y = simul(ss,sensor1,sensor2,start_date)

start = (datenum(start_date)-datenum(2016,1,1))*24*60+121;
ende = start + 1439;

%simOpt = simOptions('InitialCondition',sensor1(start));
y = sim(ss,sensor1(start:ende)');
t = 0:1439;
plot(t,sensor2(start:ende)');
hold on;
plot(t,y);
title(datestr(start_date));

f = figure(1);
p = uipanel(f,'Title','Control','Position',[.80 .80 .20 .20]);
vor = uicontrol(p,'Style', 'pushbutton', 'String', 'Vor','Units','normalized','Position',[.1 .40 .3 .3],'Callback', {@vor_Callback,ss,sensor1,sensor2,start_date});
zur = uicontrol(p,'Style', 'pushbutton', 'String', 'Zurueck','Units','normalized','Position',[.5 .40 .3 .3], 'Callback', {@zurueck_Callback,ss,sensor1,sensor2,start_date});


end

function vor_Callback(hObject, eventdata, x,y1,y2,z)
start_neu = z + 1;
display(start_neu);
clf;
simul(x,y1,y2,start_neu);
end

function zurueck_Callback(hObject, eventdata, x,y1,y2,z)
start_neu = z-1;
clf;
simul(x,y1,y2,start_neu);
end