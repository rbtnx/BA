eNames = {'est_tv1';'est_tv2';'est_tv3';'est_tv4';'est_tv5';'est_q1';'est_q2';'est_q3';'est_q4';'est_q5';'est_dt1';'est_dt2';'est_dt3';'est_dt4';'est_dt5'};
startsim = ende+1;
endsim = startsim + 7*1440-1;
WMZ.WMZ1.time(startsim);

for i=1:5
    [val_data.(eNames{i}),val_data.(eNames{i+5}),val_data.(eNames{i+10})] = est(i,startsim,endsim);
end

tv1_val = iddata(tv.Tv1,hz1_input',60);
tv2_val = iddata(tv.Tv2,tv.Tv1,60);
tv3_val = iddata(tv.Tv3,tv.Tv2,60);
tv4_val = iddata(tv.Tv4,[komp_input;hz2_input]',60);
tv5_val = iddata(tv.Tv5,hz1_input',60);

q1_val = iddata(q.Q1,[t_aussen.aussentemp(startsim:endsim)',tv.Tv1],60);
q2_val = iddata(q.Q2,[t_aussen.aussentemp(startsim:endsim)',tv.Tv2],60);
q3_val = iddata(q.Q3,[t_aussen.aussentemp(startsim:endsim)',tv.Tv3],60);
q4_val = iddata(q.Q4,[t_aussen.aussentemp(startsim:endsim)',tv.Tv4],60);
q5_val = iddata(q.Q5,[t_aussen.aussentemp(startsim:endsim)',tv.Tv5],60);