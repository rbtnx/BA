function t_abh(start_date, end_date, sensor)

start = (datenum(start_date)-datenum(2016,1,1))*24*60+1;
ende = (datenum(end_date)-datenum(2016,1,1))*24*60;

ta_file = load('/home/kathrin/Uni/BA/Fette Daten/t_aussen.mat');

f = figure(1);
p = uipanel(f,'Title','Control','Position',[.80 .80 .20 .20]);
vor = uicontrol(p,'Style', 'pushbutton', 'String', 'Vor','Units','normalized','Position',[.1 .40 .3 .3],'Callback', {@vor_Callback,start,ende,sensor});
zur = uicontrol(p,'Style', 'pushbutton', 'String', 'Zurueck','Units','normalized','Position',[.5 .40 .3 .3], 'Callback', {@zurueck_Callback,start,ende,sensor});


scatter(ta_file.t_aussen.aussentemp(start:ende),sensor(start:ende));
title([datestr((start-1)/24/60+datenum(2016,1,1),31),' bis ', datestr((ende-1)/24/60+datenum(2016,1,1),31)]); 
ylim([20 80]);
xlim([-10 30]);

end

function vor_Callback(hObject, eventdata, x,y,z)
start_neu = datestr(datenum(2016,1,1 + (x+1439)/24/60));
ende_neu = datestr(datenum(2016,1,1 + (y+1439)/24/60));
display(start_neu);
display(x);
clf;
t_abh(start_neu,ende_neu,z);
end

function zurueck_Callback(hObject, eventdata, x,y,z)
start_neu = datestr(datenum(2016,1,1 + (x-1441)/24/60));
ende_neu = datestr(datenum(2016,1,1 + (y-1441)/24/60));
display(start_neu);
clf;
t_abh(start_neu,ende_neu,z);
end