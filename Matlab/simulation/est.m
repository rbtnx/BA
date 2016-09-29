function [est_tv,est_q,est_dt] = est(number,start,ende)

    wpr = load('/home/kathrin/Uni/BA/Fette Daten/corrected_data/wprofil.mat');
    wmz = load('/home/kathrin/Uni/BA/Fette Daten/corrected_data/wmz.mat');
    erz = load('/home/kathrin/Uni/BA/Fette Daten/corrected_data/erzeuger.mat');
    wae = load('/home/kathrin/Uni/BA/Fette Daten/corrected_data/waerme_wmz.mat');
    ta = load('/home/kathrin/Uni/BA/Fette Daten/t_aussen.mat');

    if number == 1
        %est_tv = iddata(wmz.WMZ.WMZ1.c0246(start:ende)',[erz.erzeuger.HZ1.c0022(start:ende);wpr.wprofil.W1(start:ende)]',60);
        est_tv = iddata(wmz.WMZ.WMZ1.c0246(start:ende)',erz.erzeuger.HZ1.c0022(start:ende)',60);
        est_q = iddata(wae.waerme.Q1(start:ende)',[ta.t_aussen.aussentemp(start:ende);wmz.WMZ.WMZ1.c0246(start:ende)]',60);
        dt = wmz.WMZ.WMZ1.c0246(start:ende) - wmz.WMZ.WMZ1.c0247(start:ende);
        est_dt = misdata(iddata(dt',[wae.waerme.Q1(start:ende);1./wmz.WMZ.WMZ1.c0044(start:ende)]',60));

    %elseif number == 2
        %est = iddata(wmz.WMZ.WMZ2.c0114(start:ende)',wmz.WMZ.WMZ1.c0246(start:ende)',60);
        %val = iddata(wmz.WMZ.WMZ2.c0114(startn:enden)',wmz.WMZ.WMZ1.c0246(startn:enden)',60);    
    elseif number == 2
        %est_tv = iddata(wmz.WMZ.WMZ2.c0114(start:ende)',[wmz.WMZ.WMZ1.c0246(start:ende); wpr.wprofil.W2(start:ende)]',60);
        est_tv = iddata(wmz.WMZ.WMZ2.c0114(start:ende)',wmz.WMZ.WMZ1.c0246(start:ende)',60);
        est_q = iddata(wae.waerme.Q2(start:ende)',[ta.t_aussen.aussentemp(start:ende);wmz.WMZ.WMZ2.c0114(start:ende)]',60);
        dt = wmz.WMZ.WMZ2.c0114(start:ende) - wmz.WMZ.WMZ2.c0113(start:ende);
        est_dt = misdata(iddata(dt',[wae.waerme.Q2(start:ende);1./wmz.WMZ.WMZ2.c0070(start:ende)]',60));
    elseif number == 3
        %est_tv = iddata(wmz.WMZ.WMZ3.c0172(start:ende)',[wmz.WMZ.WMZ2.c0114(start:ende);erz.erzeuger.HZ2.c0154(start:ende);wpr.wprofil.W3(start:ende)]',60);
        %est_tv = iddata(wmz.WMZ.WMZ3.c0172(start:ende)',[wmz.WMZ.WMZ2.c0114(start:ende);erz.erzeuger.HZ2.c0154(start:ende)]',60);
        est_tv = iddata(wmz.WMZ.WMZ3.c0172(start:ende)',wmz.WMZ.WMZ2.c0114(start:ende)',60);
        est_q = iddata(wae.waerme.Q3(start:ende)',[ta.t_aussen.aussentemp(start:ende);wmz.WMZ.WMZ3.c0172(start:ende)]',60);
        dt = wmz.WMZ.WMZ3.c0172(start:ende) - wmz.WMZ.WMZ3.c0173(start:ende);
        est_dt = misdata(iddata(dt',[wae.waerme.Q3(start:ende);1./wmz.WMZ.WMZ3.c0178(start:ende)]',60));
    elseif number == 4
        %est_tv = iddata(wmz.WMZ.WMZ4.c0190(start:ende)',[erz.erzeuger.Kompressor.c0105(start:ende);erz.erzeuger.HZ2.c0154(start:ende);wpr.wprofil.W5(start:ende)]',60);
        est_tv = iddata(wmz.WMZ.WMZ4.c0190(start:ende)',[erz.erzeuger.Kompressor.c0105(start:ende);erz.erzeuger.HZ2.c0154(start:ende)]',60);
        est_q = iddata(wae.waerme.Q4(start:ende)',[ta.t_aussen.aussentemp(start:ende);wmz.WMZ.WMZ4.c0190(start:ende)]',60);
        dt = wmz.WMZ.WMZ4.c0190(start:ende) - wmz.WMZ.WMZ4.c0191(start:ende);
        est_dt = misdata(iddata(dt',[wae.waerme.Q4(start:ende);1./wmz.WMZ.WMZ4.c0196(start:ende)]',60));
    elseif number == 5
        est_tv = iddata(wmz.WMZ.WMZ5.c0056(start:ende)',erz.erzeuger.HZ1.c0022(start:ende)',60);
        est_q = iddata(wae.waerme.Q5(start:ende)',[ta.t_aussen.aussentemp(start:ende);wmz.WMZ.WMZ5.c0056(start:ende)]',60);
        dt = wmz.WMZ.WMZ5.c0056(start:ende) - wmz.WMZ.WMZ5.c0057(start:ende);
        est_dt = misdata(iddata(dt',[wae.waerme.Q5(start:ende);1./wmz.WMZ.WMZ5.c0062(start:ende)]',60));
    end
    
end