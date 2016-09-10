function [tv_sim,q_sim,tr_sim,v_calc,val_data] = fette_sysval(SS_tv,SS_q,SS_dt,M,start_date,simzeit)

%%%%%% Validation des identifizierten Systems

start = (datenum(start_date)-datenum(2016,1,1))*24*60+1;
ende = start + 7*1440-1;

tr_m = load('/home/kathrin/Uni/BA/Fette Daten/corrected_data/trueck.mat');

sNames = fieldnames(SS_tv);
tNames = {'Tv1','Tv2','Tv3','Tv4','Tv5'};
rNames = {'Tr1','Tr2','Tr3','Tr4','Tr5'};
qNames = {'Q1','Q2','Q3','Q4','Q5'};
dtNames = {'dt1','dt2','dt3','dt4','dt5'};
k = 4.182*1000/3600;        % cp * rho * Umrechnung h<->sek

v_calc = plot_val(start_date,M,simzeit);

for i = 1:5
   % erstelle Validierungs-Daten
   [val_data.tv_val.(tNames{i}),val_data.q_val.(qNames{i}),val_data.dt_val.(dtNames{i})] = val(i,start,simzeit);
end

for i=1:5   
   % Simuliere Vorlauftemperaturen und plotte sie
   simOpt = simOptions('InitialCondition',SS_tv.(sNames{i*2}));
   tv_sim.(tNames{i}) = sim(SS_tv.(sNames{2*i-1}),val_data.tv_val.(tNames{i}),simOpt);
   figure(2)
   subplot(2,3,i)
   plot(val_data.tv_val.(tNames{i}),tv_sim.(tNames{i}));
   title(['Vorlauftemperatur WMZ',int2str(i)]);
   
   % Simuliere Wärmeleistungen und plotte sie
   simOpt = simOptions('InitialCondition',SS_q.(sNames{i*2}));
   q_sim.(qNames{i}) = sim(SS_q.(sNames{2*i-1}),val_data.q_val.(qNames{i}),simOpt);
   figure(3)
   subplot(2,3,i)
   plot(val_data.q_val.(qNames{i}),q_sim.(qNames{i}));
   title(['Wärmeleistung WMZ',int2str(i)]);
   
   %Simuliere Rücklauftemperaturen und plotte sie
   simOpt = simOptions('InitialCondition',SS_dt.(sNames{i*2}));
   dt_sim.(dtNames{i}) = sim(SS_dt.(sNames{2*i-1}),val_data.dt_val.(dtNames{i}),simOpt);
   tr_sim.(rNames{i}) = tv_sim.(tNames{i}).y - dt_sim.(dtNames{i}).y;
   figure(4)
   subplot(2,3,i)
   plot(tr_m.trueck.(rNames{i})(start:ende));hold on;plot(smooth(tr_sim.(rNames{i}),21));
   title(['Rücklauftemperatur an WMZ',int2str(i),' (Simulation)']);
   
   % Berechne Rücklauftemperaturen und plotte sie
   tr_calc.(rNames{i}) = tv_sim.(tNames{i}).y - q_sim.(qNames{i}).y./(k*v_calc(:,i));
   figure(5)
   subplot(2,3,i)
   plot(tr_m.trueck.(rNames{i})(start:ende));hold on;plot(smooth(tr_calc.(rNames{i}),21));
   title(['Rücklauftemperatur an WMZ',int2str(i),' (berechnet)']);
end


end