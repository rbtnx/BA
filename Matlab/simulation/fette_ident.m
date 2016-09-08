function [SS_tv,SS_q,M,wp_calc,start,ende] = fette_ident(start_date,simzeit)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Systemidentifikation des Rings                     %%%%
%%%% Version 0.1 - 07.09.2016
%%%% 
%%%% Erstellt Zustandsraummodelle für die Berechnung
%%%% von Vorlauf-,Rücklauftemp und Volumenstrom aller
%%%% Punkte im Ring zu jedem Zeitpunkt
%%%% 


    %%%%% Erstelle Zustandsraummodelle %%%%%

    % iddata-Objekte fuer n4sid (input + output aus jedem Ringknoten)

    start = (datenum(start_date-3)-datenum(2016,1,1))*24*60+1;
    ende = start+24*60*3-1;               % 3 Tage für Systemidentifikation

    eNames = {'est_tv1';'est_tv2';'est_tv3';'est_tv4';'est_tv5';'est_q1';'est_q2';'est_q3';'est_q4';'est_q5'};

    for i=1:5
       [est_data.(eNames{i}),est_data.(eNames{i+5})] = est(i,start,ende); 
    end

    % Systemidentifikation mit n4sid für T(vorlauf)

    sNames = {'SS1';'SS2';'SS3';'SS4';'SS5';'x0_1';'x0_2';'x0_3';'x0_4';'x0_5'};

    for i=1:5
        if i == 2
            [SS_tv.(sNames{i}),SS_tv.(sNames{i+5})] = n4sid(est_data.(eNames{i}),2);
        else
            [SS_tv.(sNames{i}),SS_tv.(sNames{i+5})] = n4sid(est_data.(eNames{i}),'best');
        end
    end

    %%%%% Berechne Volumenstroeme aus statischem Modell %%%%%%

    % Erstelle Matrix
    M = sysident(start_date-3);     %Wieder 3 Tage für sys-identifikation

    %%%%% Berechne durchschnittliche Waermeleistung der letzten 3 Tage an den
    %%%%% Knotenpunkten des Ring-WMZ

    wae = load('/home/kathrin/Uni/BA/Fette Daten/corrected_data/waerme_wmz.mat');
    qNames = {'Q1','Q2','Q3','Q4','Q5'};

    % neu: mit n4sid-Blackbox

    for i=1:5
        [SS_q.(sNames{i}),SS_q.(sNames{i+5})] = n4sid(est_data.(eNames{i+5}),'best');
    end
    
    %%%%% Schätze Wärmeprofil aus den letzten 7 Tagen ab
    
    wp_calc = wprofil_calc(start_date-7,7);
    wNames = fieldnames(wp_calc);
    for i = 1:5
       wp_calc.(wNames{i}) = repmat(wp_calc.(wNames{i})',1,7); 
    end
end
