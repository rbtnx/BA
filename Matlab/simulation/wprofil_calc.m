function result = wprofil_calc(start_date,simzeit)
    wpr = load('/home/kathrin/Uni/BA/Fette Daten/corrected_data/wprofil.mat');
    
    start = (datenum(start_date)-datenum(2016,1,1))*24*60+1;
    ende = start + simzeit*1440-1;
    
    wNames = {'W1','W2','W3','W4','W5'};
    for i = 1:5
       result.(wNames{i}) = mean(reshape(wpr.wprofil.(wNames{i})(start:ende)',[1440 simzeit]),2);
    end
end