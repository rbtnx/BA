clearvars -except M work_input work_output;


f = figure;
p = uipanel(f,'Title','Control','Position',[.60 .07 .30 .25]);
vor = uicontrol(p,'Style', 'pushbutton', 'String', 'Vor','Units','normalized','Position',[.1 .55 .3 .3],'Callback', '@vor_Callback');
zur = uicontrol(p,'Style', 'pushbutton', 'String', 'Zurueck','Units','normalized','Position',[.5 .55 .3 .3]);

plot_val(datetime(2016,4,20),M)

