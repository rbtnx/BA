clear; clf;

% Erstelle Zustandsraummodelle

start = (datenum(2016,4,20)-datenum(2016,1,1))*24*60+1;
ende = start+24*60*3;               % 3 Tage

for i=1:5
   [est_data(:,i),val_data(:,i)] = est(i,start,ende); 
end