classdef Savefiles
    
    properties
    end
    
    methods(Static)
        %speichert Times und Values in filenameMat ab
        function savedata(filenameMat,time,values,datagatewayKey, id, datenVon, datenBis, masseinheit, messgroesseBezeichnung, messgroesseId, rechenaufloesung, cNr)
            %Ordner save erzeugen, wenn noch nicht vorhanden und den Ordner
            %wechseln
            if exist('save','dir')==7
                oldFolder = cd('save');
            end
            if exist('save','dir')==0
                mkdir('save');
                oldFolder = cd('save');
            end
            save(filenameMat,'time','values','datagatewayKey', 'id', 'datenVon', 'datenBis', 'masseinheit', 'messgroesseBezeichnung', 'messgroesseId', 'rechenaufloesung', 'cNr')
            cd (oldFolder);
        end
        %dv=1->daten vorhanden %dv=0->nicht alle daten vorhanden
        function plotdata(filenameMat,starttime,endtime,vaname,vapos,masseinheit,messgroesseB)
            va=char(vaname(vapos,:));
            va=va(8:end);
            if exist('save','dir')==7
                oldFolder = cd('save');
            end
            if exist('save','dir')==0
                mkdir('save');
                oldFolder = cd('save');
            end
            if length(filenameMat)==1
                load(char(filenameMat),'time','values','cNr');
                if time(1)<starttime||time(end)>endtime
                    a=starttime<time;
                    b=endtime>time;
                    c=a==b;
                    d=find(c);
                    ptime=time(d(1):d(end));
                    pvalues=values(d(1):d(end));
                else
                    ptime=time;
                    pvalues=values;
                    display ('Es fehlen möglicherweise Daten.');
                end
                %Datenvergleich
                if endtime>time(end)
                    warndlg('Die gespeicherten Daten sind nicht aktuell. Bitte laden Sie das Jahr erneut.');
                else
                    %display ('Die Daten sind aktuell');
                    plot(ptime,pvalues)
                    xlabel('time')
                    ylabel(strcat(messgroesseB,' in :',masseinheit))
                    %zoom('on')
                    %xlim([min(time) max(time)]) %Fehlermeldung, wenn xlim aktiviert
                    %datetick('x','keeplimits')
                    % x-axis with timestamp
                    % end of change 
                    grid on
                    legend(strrep(strcat(char(cNr),'-',va),'_','.'),'location','best')
                    % Start change, TS, 19.03.2012 - Save plotdata
                end
            else
                l=1;
                for k=1:length(filenameMat)
                    load(char(filenameMat(k)),'time','values','cNr');
                    l2=l+length(time)-1;
                    t(l:l2)=time;
                    v(l:l2)=values;
                    l=l2+1;
                end
                time=t;
                values=v;
                if time(1)<starttime||time(end)>endtime
                    a=starttime<time;
                    b=endtime>time;
                    c=a==b;
                    d=find(c);
                    ptime=time(d(1):d(end));
                    pvalues=values(d(1):d(end));
                else
                    ptime=time;
                    pvalues=values;
                    display ('Es fehlen möglicherweise Daten.');
                end
                if endtime>time(end)
                    warndlg('Die gespeicherten Daten sind nicht aktuell. Bitte laden Sie das Jahr erneut.');
                else
                    display ('Die Daten sind aktuell');
                    plot(ptime,pvalues)
                    xlabel('time')
                    ylabel(strcat(messgroesseB,' in :',masseinheit))
                    %zoom('on')
                    %xlim([min(time) max(time)]) %Fehlermeldung, wenn xlim aktiviert
                    %datetick('x','keeplimits')
                    % x-axis with timestamp
                    % end of change 
                    grid on
                    legend(strrep(strcat(char(cNr),'-',va),'_','.'),'location','best')
                    % Start change, TS, 19.03.2012 - Save plotdata
                end
            end
            cd(oldFolder);
        end
        
        %Methoden Download Years
        %convert Objektname, Varname, year to filename
        function [filename,filenameMat]=getFname(object, var, year, resolution, masseinheit, cNr)
            if isnan(str2double(year))==0
                howManyYears=length(str2double(year));
                filename=char(strcat(object,'__',cNr,'__',var,'__',year,'__',masseinheit,'_',resolution));
                filenameMat1=char(strcat(filename,'.mat'));
                %Sonderzeichen erzeugen Probleme beim Speichern der Datei
                filenameMat=strrep(filenameMat1,'\','_');
                filenameMat=strrep(filenameMat,'/','_');
                filenameMat=strrep(filenameMat,':','_');
            else
                howManyYears=length(year);
                filename=cell(1,howManyYears);
                filenameMat1=cell(1,howManyYears);
                for k=1:howManyYears
                    filename(k)=cellstr(char(strcat(object,'__',cNr,'__',var,'__',mat2str(year(k)),'__',masseinheit,'_',resolution)));
                    filenameMat1(k)=cellstr(char(strcat(filename(k),'.mat')));
                end
                filenameMat=strrep(filenameMat1,'\','_');
                filenameMat=strrep(filenameMat,'/','_');
                filenameMat=strrep(filenameMat,':','_');
            end
        end
        
        function [filename,filenameMat2]=getFname2(object, var, year, resolution, masseinheit, cNr)
            %display (cNr);
            l=length(var);
            filenameMat2=cell(l,1);
            for i=1:l
                if isnan(str2double(year))==0
                    howManyYears=length(str2double(year));
                    var2=char(var(i));
                    filename=char(strcat(object,'__',cNr(i),'__',var2(8:end),'__',year,'__',masseinheit(i),'_',resolution));
                    filenameMat1=char(strcat(filename,'.mat'));
                    %Sonderzeichen erzeugen Probleme beim Speichern der Datei
                    filenameMat=strrep(filenameMat1,'\','_');
                    filenameMat=strrep(filenameMat,'/','_');
                    filenameMat2(i)=cellstr(strrep(filenameMat,':','_'));
                else
                    howManyYears=length(year);
                    filename={};
                    filenameMat1={};
                    var2=char(var(i));
                    for k=1:howManyYears
                        filename(k)=cellstr(char(strcat(object,'__',cNr(i),'__',var2(8:end),'__',mat2str(year(k)),'__',masseinheit(i),'_',resolution)));
                        filenameMat1(k)=cellstr(char(strcat(filename(k),'.mat')));
                    end
                    filenameMat=strrep(filenameMat1,'\','_');
                    filenameMat=strrep(filenameMat,'/','_');
                    filenameMat2(i)=cellstr(strrep(filenameMat,':','_'));
                end
            end
        end
        
        %Suche nach gespeicherten Daten, datasaved=1->year schon geladen
        %datasaved=array->mehrere Years zu plotten
        function datasaved=getDS(filenameMat)
            if exist('save','dir')==7
                oldFolder = cd('save');
            end
            if exist('save','dir')==0
                mkdir('save');
                oldFolder = cd('save');
            end
            
            if iscell(filenameMat)==0
                if exist(filenameMat,'file')
                    datasaved=1;
                else
                    datasaved=0;
                end
            else
                for k=1:length(filenameMat)
                    if exist(char(filenameMat(k)),'file')
                        datasaved(k)=1;
                    else
                        datasaved(k)=0;
                    end
                end
            end
            cd(oldFolder);
        end
        
        %Userdata Methoden
        function saveUserdata(benutzername, passwort)
            if exist('user','dir')==7
                oldFolder = cd('user');
            end
            if exist('user','dir')==0
                mkdir('user');
                oldFolder = cd('user');
            end
            benutzer=strcat(benutzername,'.mat');
            save(benutzer,'benutzername','passwort')
            cd (oldFolder);
        end
        function [benutzername, passwort]=getUserdata(benutzer)
            if exist('user','dir')==7
                oldFolder = cd('user');
            end
            if exist('user','dir')==0
                mkdir('user');
                oldFolder = cd('user');
            end
            benutzer=strcat(benutzer,'.mat');
            load(benutzer,'benutzername','passwort');
            cd (oldFolder);
        end
        
    end
                
            
end