clear; close all;

load('/home/kathrin/Uni/BA/Fette Daten/corrected_data/erzeuger.mat');
load('/home/kathrin/Uni/BA/Fette Daten/t_aussen.mat');
load('/home/kathrin/Uni/BA/Fette Daten/corrected_data/input_erzeuger.mat');
load('/home/kathrin/Uni/BA/Fette Daten/corrected_data/wmz.mat');


%%% Hier Daten eintragen
simzeit = 7;                        % Wie viele Tage sollen simuliert werden?
start_date = datetime(2016,4,16);   % Wann soll die Simulation starten?

startsim = (datenum(start_date)-datenum(2016,1,1))*24*60+1;
endsim = startsim + simzeit*1440-1;
timesim = WMZ.WMZ1.time(startsim:endsim);


[SS_tv,SS_q,SS_dt,M,wp_calc,start,ende,est_data] = fette_ident(start_date);
%[tv_sim,q_sim,tr_sim,v_calc,val_data] = fette_sysval(SS_tv,SS_q,SS_dt,M,start_date,7);
hz1_input = erzeuger.HZ1.c0022(startsim:endsim);
hz2_input = erzeuger.HZ2.c0154(startsim:endsim);
komp_input = erzeuger.Kompressor.c0105(startsim:endsim);
ta = t_aussen.aussentemp(startsim:endsim);
v_input = select(input, [1 2 3]);
v_input = v_input(startsim:endsim,1:3);

[tv,q,v_calc,tr] = fette_sim(start_date,hz1_input,hz2_input,komp_input,ta,v_input);

% Plotting Action

figure(1);
subplot(3,1,1);
plot(timesim,WMZ.WMZ1.c0246(startsim:endsim));hold on;plot(timesim,tv.Tv1);
title('Vorlauftemperatur WMZ1');
subplot(3,1,2);
plot(timesim,WMZ.WMZ1.c0247(startsim:endsim));hold on;plot(timesim,smooth(tr.Tr1,21));
title('Rücklauftemperatur WMZ1');
subplot(3,1,3);
plot(timesim,WMZ.WMZ1.c0044(startsim:endsim));hold on;plot(timesim,v_calc(:,1));
title('Volumenstrom WMZ1');

figure(2);
subplot(3,1,1);
plot(timesim,WMZ.WMZ2.c0114(startsim:endsim));hold on;plot(timesim,tv.Tv2);
title('Vorlauftemperatur WMZ2');
subplot(3,1,2);
plot(timesim,WMZ.WMZ2.c0113(startsim:endsim));hold on;plot(timesim,smooth(tr.Tr2,21));
title('Rücklauftemperatur WMZ2');
subplot(3,1,3);
plot(timesim,WMZ.WMZ2.c0070(startsim:endsim));hold on;plot(timesim,v_calc(:,2));
title('Volumenstrom WMZ2');

figure(3);
subplot(3,1,1);
plot(timesim,WMZ.WMZ3.c0172(startsim:endsim));hold on;plot(timesim,tv.Tv3);
title('Vorlauftemperatur WMZ3');
subplot(3,1,2);
plot(timesim,WMZ.WMZ3.c0173(startsim:endsim));hold on;plot(timesim,smooth(tr.Tr3,21));
title('Rücklauftemperatur WMZ3');
subplot(3,1,3);
plot(timesim,WMZ.WMZ3.c0178(startsim:endsim));hold on;plot(timesim,v_calc(:,3));
title('Volumenstrom WMZ3');

figure(4);
subplot(3,1,1);
plot(timesim,WMZ.WMZ4.c0190(startsim:endsim));hold on;plot(timesim,tv.Tv4);
title('Vorlauftemperatur WMZ4');
subplot(3,1,2);
plot(timesim,WMZ.WMZ4.c0191(startsim:endsim));hold on;plot(timesim,smooth(tr.Tr4,21));
title('Rücklauftemperatur WMZ4');
subplot(3,1,3);
plot(timesim,WMZ.WMZ4.c0196(startsim:endsim));hold on;plot(timesim,v_calc(:,4));
title('Volumenstrom WMZ4');

figure(5);
subplot(3,1,1);
plot(timesim,WMZ.WMZ5.c0056(startsim:endsim));hold on;plot(timesim,tv.Tv5);
title('Vorlauftemperatur WMZ5');
subplot(3,1,2);
plot(timesim,WMZ.WMZ5.c0057(startsim:endsim));hold on;plot(timesim,smooth(tr.Tr5,21));
title('Rücklauftemperatur WMZ5');
subplot(3,1,3);
plot(timesim,WMZ.WMZ5.c0062(startsim:endsim));hold on;plot(timesim,v_calc(:,5));
title('Volumenstrom WMZ5');
