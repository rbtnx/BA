function [est_tv,val_tv,est_q,val_q] = est(number,start,ende,simzeit)

wpr = load('/home/kathrin/Uni/BA/Fette Daten/corrected_data/wprofil.mat');
wmz = load('/home/kathrin/Uni/BA/Fette Daten/corrected_data/wmz.mat');
erz = load('/home/kathrin/Uni/BA/Fette Daten/corrected_data/erzeuger.mat');
wae = load('/home/kathrin/Uni/BA/Fette Daten/corrected_data/waerme_wmz.mat');
ta = load('/home/kathrin/Uni/BA/Fette Daten/t_aussen.mat');

startn = ende + 1;
enden = startn + simzeit*1440-1;

if number == 1
    est_tv = iddata(wmz.WMZ.WMZ1.c0246(start:ende)',[erz.erzeuger.HZ1.c0022(start:ende);wpr.wprofil.W1(start:ende)]',60);
    val_tv = iddata(wmz.WMZ.WMZ1.c0246(startn:enden)',[erz.erzeuger.HZ1.c0022(startn:enden);wpr.wprofil.W1(startn:enden)]',60);
    est_q = iddata(wae.waerme.Q1(start:ende)',[ta.t_aussen.aussentemp(start:ende);wmz.WMZ.WMZ1.c0246(start:ende)]',60);
    val_q = iddata(wae.waerme.Q1(startn:enden)',[ta.t_aussen.aussentemp(startn:enden);wmz.WMZ.WMZ1.c0246(startn:enden)]',60);
%elseif number == 2
    %est = iddata(wmz.WMZ.WMZ2.c0114(start:ende)',wmz.WMZ.WMZ1.c0246(start:ende)',60);
    %val = iddata(wmz.WMZ.WMZ2.c0114(startn:enden)',wmz.WMZ.WMZ1.c0246(startn:enden)',60);    
elseif number == 2
    est_tv = iddata(wmz.WMZ.WMZ2.c0114(start:ende)',[wmz.WMZ.WMZ1.c0246(start:ende); wpr.wprofil.W2(start:ende)]',60);
    val_tv = iddata(wmz.WMZ.WMZ2.c0114(startn:enden)',[wmz.WMZ.WMZ1.c0246(startn:enden); wpr.wprofil.W2(startn:enden)]',60);
    est_q = iddata(wae.waerme.Q2(start:ende)',[ta.t_aussen.aussentemp(start:ende);wmz.WMZ.WMZ2.c0114(start:ende)]',60);
    val_q = iddata(wae.waerme.Q2(startn:enden)',[ta.t_aussen.aussentemp(startn:enden);wmz.WMZ.WMZ2.c0114(startn:enden)]',60);
elseif number == 3
    est_tv = iddata(wmz.WMZ.WMZ3.c0172(start:ende)',[wmz.WMZ.WMZ2.c0114(start:ende);wpr.wprofil.W3(start:ende)]',60);
    val_tv = iddata(wmz.WMZ.WMZ3.c0172(startn:enden)',[wmz.WMZ.WMZ2.c0114(startn:enden);wpr.wprofil.W3(startn:enden)]',60);
    est_q = iddata(wae.waerme.Q3(start:ende)',[ta.t_aussen.aussentemp(start:ende);wmz.WMZ.WMZ3.c0172(start:ende)]',60);
    val_q = iddata(wae.waerme.Q3(startn:enden)',[ta.t_aussen.aussentemp(startn:enden);wmz.WMZ.WMZ3.c0172(startn:enden)]',60);
elseif number == 4
    est_tv = iddata(wmz.WMZ.WMZ4.c0190(start:ende)',[erz.erzeuger.Kompressor.c0105(start:ende);wpr.wprofil.W5(start:ende)]',60);
    val_tv = iddata(wmz.WMZ.WMZ4.c0190(startn:enden)',[erz.erzeuger.Kompressor.c0105(startn:enden);wpr.wprofil.W5(startn:enden)]',60);
    est_q = iddata(wae.waerme.Q4(start:ende)',[ta.t_aussen.aussentemp(start:ende);wmz.WMZ.WMZ4.c0190(start:ende)]',60);
    val_q = iddata(wae.waerme.Q4(startn:enden)',[ta.t_aussen.aussentemp(startn:enden);wmz.WMZ.WMZ4.c0190(startn:enden)]',60);
elseif number == 5
    est_tv = iddata(wmz.WMZ.WMZ5.c0056(start:ende)',erz.erzeuger.HZ1.c0022(start:ende)',60);
    val_tv = iddata(wmz.WMZ.WMZ5.c0056(startn:enden)',erz.erzeuger.HZ1.c0022(startn:enden)',60);
    est_q = iddata(wae.waerme.Q5(start:ende)',[ta.t_aussen.aussentemp(start:ende);wmz.WMZ.WMZ5.c0056(start:ende)]',60);
    val_q = iddata(wae.waerme.Q5(startn:enden)',[ta.t_aussen.aussentemp(startn:enden);wmz.WMZ.WMZ5.c0056(startn:enden)]',60);
end
    
end