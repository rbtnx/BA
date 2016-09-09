function fette_sysval(SS_tv,SS_q,M,wp_calc,start_date,simzeit)

%%%%%% Validation des identifizierten Systems

start = (datenum(start_date)-datenum(2016,1,1))*24*60+1;
ende = start + 7*1440-1;

tr_m = load('/home/kathrin/Uni/BA/Fette Daten/corrected_data/trueck.mat');

sNames = fieldnames(SS_tv);
tNames = {'Tv1','Tv2','Tv3','Tv4','Tv5'};
rNames = {'Tr1','Tr2','Tr3','Tr4','Tr5'};
qNames = {'Q1','Q2','Q3','Q4','Q5'};
k = 4.182*1000/3600;        % cp * rho * Umrechnung h<->sek

v_calc = plot_val(start_date,M,simzeit);

for i = 1:5
   [tv_val.(tNames{i}),q_val.(qNames{i})] = val(i,start,simzeit);
   simOpt = simOptions('InitialCondition',SS_tv.(sNames{i*2}));
   tv_sim.(tNames{i}) = sim(SS_tv.(sNames{2*i-1}),tv_val.(tNames{i}),simOpt);
   figure(i+1);
   plot(tv_val.(tNames{i}),tv_sim.(tNames{i}));
   simOpt = simOptions('InitialCondition',SS_q.(sNames{i*2}));
   q_sim.(qNames{i}) = sim(SS_q.(sNames{2*i-1}),q_val.(qNames{i}),simOpt);
   figure(i+6);
   plot(q_val.(qNames{i}),q_sim.(qNames{i}));
   tr.(rNames{i}) = tv_sim.(tNames{i}).y - q_sim.(qNames{i}).y./(k*v_calc(:,i));
end

figure(12);
for i = 1:5
   subplot(2,3,i);
   plot(tr_m.trueck.(rNames{i})(start:ende));hold on;plot(smooth(tr.(rNames{i}),21));
end

end