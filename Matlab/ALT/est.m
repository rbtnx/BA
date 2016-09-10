function [est,val] = est(number,start,ende)

wpr = load('/home/kathrin/Uni/BA/Fette Daten/corrected_data/wprofil.mat');
wmz = load('/home/kathrin/Uni/BA/Fette Daten/corrected_data/wmz.mat');
erz = load('/home/kathrin/Uni/BA/Fette Daten/corrected_data/erzeuger.mat');

startn = ende + 1;
enden = startn + 1439;

if number == 1
    est = iddata(wmz.WMZ.WMZ1.c0246(start:ende)',[erz.erzeuger.HZ1.c0022(start:ende);wpr.wprofil.W1(start:ende)]',60);
    val = iddata(wmz.WMZ.WMZ1.c0246(startn:enden)',[erz.erzeuger.HZ1.c0022(startn:enden);wpr.wprofil.W1(startn:enden)]',60);
elseif number == 2
    est = iddata(wmz.WMZ.WMZ2.c0114(start:ende)',[wmz.WMZ.WMZ1.c0246(start:ende); wpr.wprofil.W2(start:ende)]',60);
    val = iddata(wmz.WMZ.WMZ2.c0114(startn:enden)',[wmz.WMZ.WMZ1.c0246(startn:enden); wpr.wprofil.W2(startn:enden)]',60);
elseif number == 3
    est = iddata(wmz.WMZ.WMZ3.c0172(start:ende)',[wmz.WMZ.WMZ2.c0114(start:ende);wpr.wprofil.W3(start:ende)]',60);
    val = iddata(wmz.WMZ.WMZ3.c0172(startn:enden)',[wmz.WMZ.WMZ2.c0114(startn:enden);wpr.wprofil.W3(startn:enden)]',60);
elseif number == 4
    est = iddata(wmz.WMZ.WMZ4.c0190(start:ende)',[erz.erzeuger.Kompressor.c0105(start:ende);wpr.wprofil.W5(start:ende)]',60);
    val = iddata(wmz.WMZ.WMZ4.c0190(startn:enden)',[erz.erzeuger.Kompressor.c0105(startn:enden);wpr.wprofil.W5(startn:enden)]',60);
elseif number == 5
    est = iddata(wmz.WMZ.WMZ5.c0056(start:ende)',erz.erzeuger.HZ1.c0022(start:ende)',60);
    val = iddata(wmz.WMZ.WMZ5.c0056(startn:enden)',erz.erzeuger.HZ1.c0022(startn:enden)',60);
end
    
end