function [SS_tv,SS_q,SS_dt,M,wp_calc,start,ende,est_data] = fette_ident(start_date)

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

    eNames = {'est_tv1';'est_tv2';'est_tv3';'est_tv4';'est_tv5';'est_q1';'est_q2';'est_q3';'est_q4';'est_q5';
        'est_dt1';'est_dt2';'est_dt3';'est_dt4';'est_dt5'};

    for i=1:5
       [est_data.(eNames{i}),est_data.(eNames{i+5}),est_data.(eNames{i+10})] = est(i,start,ende); 
    end

    Options = n4sidOptions;
    Options.Focus = 'simulation';
    Options.N4Weight = 'CVA';
    
    % Systemidentifikation mit n4sid für T(vorlauf)

    sNames = {'SS1';'SS2';'SS3';'SS4';'SS5';'x0_1';'x0_2';'x0_3';'x0_4';'x0_5'};

    for i=1:5
        %[SS_tv.(sNames{i}),SS_tv.(sNames{i+5})] = n4sid(est_data.(eNames{i}),2,'DisturbanceModel','none');
        [SS_tv.(sNames{i}),SS_tv.(sNames{i+5})] = n4sid(est_data.(eNames{i}),2);
    end


    %%%%% Berechne Volumenstroeme aus statischem Modell %%%%%%

    % Erstelle Matrix

    M = sysident(start_date-3);     %Wieder 3 Tage für sys-identifikation

    %%%%% Berechne durchschnittliche Waermeleistung der letzten 3 Tage an den
    %%%%% Knotenpunkten des Ring-WMZ

    % neu: mit n4sid-Blackbox
    % Q + dt an jedem Knoten mit n4sid

    for i=1:5
        %[SS_q.(sNames{i}),SS_q.(sNames{i+5})] = n4sid(est_data.(eNames{i+5}),'best','DisturbanceModel','none');
        %[SS_dt.(sNames{i}),SS_dt.(sNames{i+5})] = n4sid(est_data.(eNames{i+10}),1,'DisturbanceModel','none');
        [SS_q.(sNames{i}),SS_q.(sNames{i+5})] = n4sid(est_data.(eNames{i+5}),'best');
        [SS_dt.(sNames{i}),SS_dt.(sNames{i+5})] = n4sid(est_data.(eNames{i+10}),1);
    end
    
  
    %%%%% Schätze Wärmeprofil aus den letzten 7 Tagen ab
    
    wp_calc = wprofil_calc(start_date-7,7);
    wNames = fieldnames(wp_calc);
    for i = 1:5
       wp_calc.(wNames{i}) = repmat(wp_calc.(wNames{i})',1,7); 
    end
    
    folder = ['/home/kathrin/Uni/BA/Matlab/simulation/simdata/',datestr(start_date,'YY-mm-dd')];
    
    mkdir(folder);
    cd(folder);
    save('SS_tv.mat','SS_tv');
    save('SS_q.mat','SS_q');
    save('SS_dt.mat','SS_dt');
    save('M.mat','M');
    save('wp_calc.mat','wp_calc');
end
