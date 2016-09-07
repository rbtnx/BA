%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Systemidentifikation des Rings                     %%%%
%%%% Version 0.1 - 07.09.2016
%%%% 
%%%% Erstellt Zustandsraummodelle für die Berechnung
%%%% von Vorlauf-,Rücklauftemp und Volumenstrom aller
%%%% Punkte im Ring zu jedem Zeitpunkt
%%%% 


clear; clf; close all;
start_date = datetime(2016,4,22);
simzeit = 7;
%%%%% Erstelle Zustandsraummodelle %%%%%

% iddata-Objekte fuer n4sid (input + output aus jedem Ringknoten)

start = (datenum(start_date-3)-datenum(2016,1,1))*24*60+1;
ende = start+24*60*3-1;               % 3 Tage für Systemidentifikation
startsim = ende + 1;
endsim = startsim + simzeit*1440-1;

eNames = {'est_tv1';'est_tv2';'est_tv3';'est_tv4';'est_tv5';'val_tv1';'val_tv2';'val_tv3';'val_tv4';'val_tv5';
    'est_q1';'est_q2';'est_q3';'est_q4';'est_q5';'val_q1';'val_q2';'val_q3';'val_q4';'val_q5'};

for i=1:5
   [est_data.(eNames{i}),est_data.(eNames{i+5}),est_data.(eNames{i+10}),est_data.(eNames{i+15})] = est(i,start,ende,simzeit); 
end

% Systemidentifikation mit n4sid

sNames = {'tvor1';'tvor2';'tvor3';'tvor4';'tvor5';'SS1';'SS2';'SS3';'SS4';'SS5';
    'x0_1';'x0_2';'x0_3';'x0_4';'x0_5'};

for i=1:5
    if i == 2
        [tv.(sNames{i}),SS_tv.(sNames{i+5}),SS_tv.(sNames{i+10})] = modelsim(est_data.(eNames{i}),est_data.(eNames{i+5}),2);
    else
        [tv.(sNames{i}),SS_tv.(sNames{i+5}),SS_tv.(sNames{i+10})] = modelsim(est_data.(eNames{i}),est_data.(eNames{i+5}),0);
    end
    figure(i);
    h = plot(est_data.(eNames{i+5}),tv.(sNames{i}));
    setoptions(h,'TimeUnits','hours');
    title(['Vorlauftemperatur WMZ',int2str(i)]);
end

%%%%% Berechne Volumenstroeme aus statischem Modell %%%%%%

% Erstelle Matrix
M = sysident(start_date-3);     % aus 24 h vor Simulationszeit

% Berechne alle fuenf Volumenstroeme (24h)
v_calc = plot_val(start_date+3,M,simzeit);


%%%%% Berechne durchschnittliche Waermeleistung der letzten 3 Tage an den
%%%%% Knotenpunkten des Ring-WMZ

wae = load('/home/kathrin/Uni/BA/Fette Daten/corrected_data/waerme_wmz.mat');
qNames = {'Q1','Q2','Q3','Q4','Q5'};

% alt: Mit "Profil"
%
%for i=1:5
   %%q_calc.(qNames{i}) = mean(reshape(wae.waerme.(qNames{i})(start:ende),[1440 3]),2);
   %q_calc.(qNames{i}) = smooth(mean(reshape(wae.waerme.(qNames{i})(start:ende),[1440 3]),2),21);   %mit Glättung
%end

% neu: mit n4sid-Blackbox

for i=1:5
    [q_sim.(qNames{i}),SS_q.(sNames{i+5}),SS_q.(sNames{i+10})] = modelsim(est_data.(eNames{i+10}),est_data.(eNames{i+15}),0);
    figure(i+7);
    h = plot(est_data.(eNames{i+15}),q_sim.(qNames{i}));
    setoptions(h,'TimeUnits','hours');
    title(['Wärmeleistung WMZ',int2str(i)]);
end

% Plotte Waermeleistung
% alt! Gehört noch zum Profil

%figure(7);
%for i=1:5
%   subplot(2,3,i);
%   plot(wae.waerme.time(startsim:endsim),wae.waerme.(qNames{i})(startsim:endsim),wae.waerme.time(startsim:endsim),q_calc.(qNames{i}));
%end
%legend('gemeSS_tven','berechnet','Location', 'best');

%%%%% Berechne Ruecklauf-Temperatur an den Knotenpunkten des Ring-WMZ

k = 4.182*1000/3600;        % cp * rho * Umrechnung h<->sek
rNames = {'Tr1','Tr2','Tr3','Tr4','Tr5'};

for i=1:5
    tr.(rNames{i}) = tv.(sNames{i}).y - q_sim.(qNames{i}).y./(k*v_calc(:,i));
    %tr.(rNames{i}) = (k*v_calc(:,i).*tv.(sNames{i}).y-q_calc.(qNames{i}))./(k*v_calc(:,i)); 
end

% Plotte Rücklauftemperatur
tr_m = load('/home/kathrin/Uni/BA/Fette Daten/corrected_data/trueck.mat');
figure(13);
for i=1:5
   subplot(2,3,i);
   plot(wae.waerme.time(startsim:endsim),tr_m.trueck.(rNames{i})(startsim:endsim),wae.waerme.time(startsim:endsim),smooth(tr.(rNames{i}),21));
end
legend('gemeSS_tven','berechnet','Location', 'best');
