function val_calc = plot_val(start_date,M,simzeit)

% Änderung 09-07: simzeit hinzugefügt

inputfile = load('/home/kathrin/Uni/BA/Fette Daten/corrected_data/input_corr.mat');
outputfile = load('/home/kathrin/Uni/BA/Fette Daten/corrected_data/output_corr.mat');

iNames = fieldnames(inputfile.input);
oNames = fieldnames(outputfile.output);

start = (datenum(start_date) - datenum(2016,1,1,0,0,0))*24*60 + 1;
ende = start + simzeit*1440-1;

for loopIndex = 1:length(iNames)-1
    val_input(loopIndex,:) = inputfile.input.(iNames{loopIndex})(start:ende);
end

for loopIndex = 1:length(oNames)-1
    val_output(loopIndex,:) = outputfile.output.(oNames{loopIndex})(start:ende);
end

time = inputfile.input.time(start:ende);

val_input = transpose(val_input);
val_output = transpose(val_output);

val_calc = val_input * M;

f = figure(6);
p = uipanel(f,'Title','Control','Position',[.60 .07 .30 .25]);
vor = uicontrol(p,'Style', 'pushbutton', 'String', 'Vor','Units','normalized','Position',[.1 .55 .3 .3],'Callback', {@vor_Callback,start,M});
zur = uicontrol(p,'Style', 'pushbutton', 'String', 'Zurueck','Units','normalized','Position',[.5 .55 .3 .3], 'Callback', {@zurueck_Callback,start,M});

for loopIndex = 1:5
    subplot(3,2,loopIndex);
    plot(time,val_output(:,loopIndex));
    hold on;
    plot(time, val_calc(:,loopIndex));
    %axis([datenum(time(1)) datenum(time(1440)) -10 20])
    %xlim([datenum(time(1)) datenum(time(1440))])
    %legend('gemessen', 'berechnet');
    title(oNames(loopIndex));
end
legend('gemessen', 'berechnet', 'Location', 'best');

end

function vor_Callback(hObject, eventdata, x,y)
start_neu = datestr(datenum(2016,1,1 + (x+1439)/24/60));
display(start_neu);
display(x);
clf;
plot_val(start_neu, y);
end

function zurueck_Callback(hObject, eventdata, x,y)
start_neu = datestr(datenum(2016,1,1 + (x-1441)/24/60));
display(start_neu);
clf;
plot_val(start_neu, y);
end