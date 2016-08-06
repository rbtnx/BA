classdef Dataimport
    properties
    end
    
    methods(Static)
        
      %Grundfunktionen
        %Datenabruf, Zeiten müssen als datetime übergeben werden
        function [time, values, error]=getTV(benutzername, passwort, id,startdatetime,enddatetime, type, resolution)
            yearA=sprintf('%04d',year(startdatetime));
            monthA=sprintf('%02d',month(startdatetime));
            dayA=sprintf('%02d',day(startdatetime));
            stA=sprintf('%02d',hms(startdatetime));
            yearB=sprintf('%04d',year(enddatetime));
            monthB=sprintf('%02d',month(enddatetime));
            dayB=sprintf('%02d',day(enddatetime));
            etB=sprintf('%02d',hms(enddatetime));
            benutzername=strrep(benutzername,'ü','%C3%BC');
            timespace=strcat('FromUtc=',yearA,'-',monthA,'-',dayA,'T',stA,':00:00Z&ToUtc=',yearB,'-',monthB,'-',dayB,'T',etB,':00:00Z');
            url=strcat('https://observe.interwatt.net/api/ObserveSchnittstelle/ZwValues?username=',benutzername,'&password=',passwort,'&id=',id,'&',timespace,'&Type=',type,'&Resolution=',resolution);
            url=char(url);
            [time, values, error]=Dataimport.urlimport(url);
        end
        function [times, values, error] = urlimport(url)
            %display (url);
            str = urlread(url);
            str = strrep(str, 'null', 'NaN');
            %Fehlerkontrolle
            err=strsplit(str, {'{"data":{"error":',',"errorHrId":',',"errorMessage":',',"results":'});
            if strcmp(err(2),'true')==1
                errID=strrep(char(err(3)),'"','');
                errMsg=strrep(char(err(4)),'"','');
                warndlg(strcat('Error ID:',errID,'Error Message:',errMsg), 'Download Error');
                times=0;
                values=0;
                error=1;
            else
                [a, ~] = strsplit(str,{'[','}]'});
                [d, ~] = strsplit(a{2}, {'{"timeUtc":"', '","value":', '},'});
                v = d(3:2:end);
                values = str2double(v);
                e = d(2:2:end);
                t1 = e(1);
                x = e(2:end); 
                t2 = strcat(x,'Z');
                t = [t1, t2];
                times=datetime(t,'InputFormat','yyyy-MM-dd''T''HH:mm:ssXXXX','TimeZone','UTC');
                error=0;
            end
        end
        function filematname=excelimport(file)
            if isempty(strfind(file.name,'.xlsx'))==0
                l=strfind(file.name,'.xlsx');
                filematname=char(strcat(file.name(1:l),'mat'));
                if exist (file.name,'file')==2 && exist(filematname,'file')==0
                    [~,list]=xlsread(char(file.name));
                    save(char(filematname),'list');
                    display ('Liste wurde aktualisiert');
                else
                    filemat=dir(fullfile(filematname));
                    if datetime(filemat.date)>datetime(file.date)
                        display ('Liste ist aktuell');
                    else
                        delete(filematname);
                        [~,list]=xlsread(char(file.name));
                        save(char(filematname),'list');
                        display ('Liste wurde aktualisiert');
                    end
                end
            else
                display ('Keine .xlsx Liste vorhanden.');
            end
        end
        
      %Datenbank
        %gibt die Gebäudeliste für Listbox 1 wieder
        function [buildingNames, DSids]=getBuildingNames(benutzername, passwort)
            benutzername=strrep(benutzername,'ü','%C3%BC');
            url=strcat('https://observe.interwatt.net/api/observeschnittstelle/Datasubscriptions?username=',benutzername,'&password=',passwort);
            str=urlread(url);
            [a, ~] = strsplit(str,{'{"datasubscriptions":[',']'});
            b=strsplit(a{2},{'{"key":',',"value":','}'});
            ids=b(2:3:end);
            DSids=strrep(ids,'"','');
            buildings=b(3:3:end);
            buildingNames=strrep(buildings,'"','');
            %temporärer Dateiordner für die IDs
            if exist('temporaere_Dateien','dir')==7
                oldFolder = cd('temporaere_Dateien');
            end
            if exist('temporaere_Dateien','dir')==0
                mkdir('temporaere_Dateien');
                oldFolder = cd('temporaere_Dateien');
            end
            save('datasubscriptionsIDs','buildingNames','DSids');
            cd(oldFolder);
        end
        %Download der Messpunkte eines Gebäudes
        function BData=getBData(building, benutzername, passwort)
            benutzername=strrep(benutzername,'ü','%C3%BC');
            oldFolder = cd('temporaere_Dateien');
            load('datasubscriptionsIDs','buildingNames','DSids');
            cd(oldFolder);
            a=strfind(buildingNames,building);
            b=find(~cellfun(@isempty, a));
            DSid=DSids{b};
            url=strcat('https://observe.interwatt.net/api/observeschnittstelle/DatasubscriptionZaehlwerke?username=',benutzername,'&password=',passwort,'&datasubscriptionId=',DSid);
            str=urlread(url);
            [c, ~] = strsplit(str,{'"zaehlwerke":[','],"error":'});
            d=strsplit(c{2},{'{"datagatewayKey":',',"datasubscriptionId":',',"datenVorhandenAbUtc":',',"datenVorhandenBisUtc":',',"masseinheit":',',"messgroesseBezeichnung":',',"messgroesseId":',',"objektOrDatasubscriptionBezeichnung":',',"rechenaufloesung":',',"weitereDatenfelder":',',"zaehlwerkBezeichnung":',',"zaehlwerkId":'});
            d=d(2:end);
            wdf=d(10:12:end);
            nr=length(d)/12+1;
            cNr=cell(nr-1,1);
            for k=1:nr-1
                if isempty(strfind(char(wdf(k)),'"Plenum_Bez","wert":"'))==0
                    x=char(wdf(k));
                    cStelle=strfind(x,'"Plenum_Bez","wert":"');
                    cNr(k)=cellstr(x(cStelle+21:cStelle+25));
                else
                    cStelle(k)=0;
                    cNr(k)=cellstr('NoCNR');
                end
            end
            BData=cell(nr,13);
            BData(1,1)=cellstr('datagatewayKey');
            BData(1,2)=cellstr('datasubscriptionId');
            BData(1,3)=cellstr('datenVorhandenAbUtc');
            BData(1,4)=cellstr('datenVorhandenBisUtc');
            BData(1,5)=cellstr('masseinheit');
            BData(1,6)=cellstr('messgroesseBezeichnung');
            BData(1,7)=cellstr('messgroesseId');
            BData(1,8)=cellstr('objektOrDatasubscriptionBezeichnung');
            BData(1,9)=cellstr('rechenaufloesung');
            BData(1,10)=cellstr('c-Nummern');
            BData(1,11)=cellstr('zaehlwerkBezeichnung');
            BData(1,12)=cellstr('zaehlwerkId');
            BData(1,13)=cellstr('c_zB');
            BData(2:nr,1)=d(1:12:end);
            BData(2:nr,2)=d(2:12:end);
            BData(2:nr,3)=d(3:12:end);
            BData(2:nr,4)=d(4:12:end);
            BData(2:nr,5)=d(5:12:end);
            BData(2:nr,6)=d(6:12:end);
            BData(2:nr,7)=d(7:12:end);
            BData(2:nr,8)=d(8:12:end);
            BData(2:nr,9)=d(9:12:end);
            BData(2:nr,10)=cNr;
            BData(2:nr,11)=d(11:12:end);
            BData(2:nr,12)=d(12:12:end);
            for k=1:nr-1
                BData(k+1,13)=cellstr(strcat(BData(k+1,10),BData(k+1,11)));
            end
            BData=strrep(BData,'"},','');
            BData=strrep(BData,'"','');
            %temporärer Dateiordner für BData
            if exist('temporaere_Dateien','dir')==7
                oldFolder = cd('temporaere_Dateien');
            end
            if exist('temporaere_Dateien','dir')==0
                mkdir('temporaere_Dateien');
                oldFolder = cd('temporaere_Dateien');
            end
            save(strcat('Data_',building),'BData');
            cd(oldFolder);
        end
        
        %gibt die Informationen des Messpunkts wieder (BData)
        function [datagatewayKey, zaehlwerkId, datenVon, datenBis, masseinheit, messgroesseBezeichnung, messgroesseId, rechenaufloesung, cNr]=getMP_Info(building, messpunkt)
            %Load BData
            if exist('temporaere_Dateien','dir')==7
                oldFolder = cd('temporaere_Dateien');
            end
            if exist('temporaere_Dateien','dir')==0
                mkdir('temporaere_Dateien');
                oldFolder = cd('temporaere_Dateien');
            end
            if exist(strcat('Data_',building,'.mat'),'file')==2
                load(strcat('Data_',building),'BData');
            else
                warndlg('Bitte ein Gebäude auswählen. Daten nicht vorhanden')
                cd(oldFolder);
                return
            end
            cd(oldFolder);
            mp=char(messpunkt);
            mpCZ=strcat(mp(1:5),mp(8:end));
            line=strfind(BData(1:end,13), mpCZ);
            line=find(~cellfun(@isempty, line));
            datagatewayKey=BData{line,1};
            datenVon=BData{line,3};
            datenBis=BData{line,4};
            masseinheit=BData{line,5};
            messgroesseBezeichnung=BData{line,6};
            messgroesseId=BData{line,7};
            rechenaufloesung=BData{line,9};
            zaehlwerkId=BData{line,12};
            cNr=BData{line,10};
            if strcmp(datenVon,'null')||strcmp(datenBis,'null')==1
                warndlg(strcat(char(messpunkt),':Data-times are null'));
                datenVon='Error';
                datenBis='Error';
            end
            datagatewayKey=cellstr(datagatewayKey);
            datenVon=cellstr(datenVon);
            datenBis=cellstr(datenBis);
            masseinheit=cellstr(masseinheit);
            messgroesseBezeichnung=cellstr(messgroesseBezeichnung);
            messgroesseId=cellstr(messgroesseId);
            rechenaufloesung=cellstr(rechenaufloesung);
            zaehlwerkId=cellstr(zaehlwerkId);
            cNr=cellstr(cNr);
        end
        
        function [datagatewayKey, zaehlwerkId, datenVon, datenBis, masseinheit, messgroesseBezeichnung, messgroesseId, rechenaufloesung, cNr]=getMP_Info2(building, messpunkt)
            %Load BData
            if exist('temporaere_Dateien','dir')==7
                oldFolder = cd('temporaere_Dateien');
            end
            if exist('temporaere_Dateien','dir')==0
                mkdir('temporaere_Dateien');
                oldFolder = cd('temporaere_Dateien');
            end
            if exist(strcat('Data_',building,'.mat'),'file')==2
                load(strcat('Data_',building),'BData');
            else
                warndlg('Bitte ein Gebäude auswählen. Daten nicht vorhanden')
                cd(oldFolder);
                return
            end
            cd(oldFolder);
            l=length(messpunkt);
            datagatewayKey=cell(l,1);
            datenVon=cell(l,1);
            datenBis=cell(l,1);
            masseinheit=cell(l,1);
            messgroesseBezeichnung=cell(l,1);
            messgroesseId=cell(l,1);
            rechenaufloesung=cell(l,1);
            zaehlwerkId=cell(l,1);
            cNr=cell(l,1);
            for k=1:l
                mp=char(messpunkt(k));
                mpCZ=strcat(mp(1:5),mp(8:end));
                line=strfind(BData(1:end,13), mpCZ);
                line=find(~cellfun(@isempty, line));
                datagatewayKey(k,1)=cellstr(BData{line,1});
                datenVon(k)=cellstr(BData{line,3});
                datenBis(k)=cellstr(BData{line,4});
                masseinheit(k)=cellstr(BData{line,5});
                messgroesseBezeichnung(k)=cellstr(BData{line,6});
                messgroesseId(k)=cellstr(BData{line,7});
                rechenaufloesung(k)=cellstr(BData{line,9});
                zaehlwerkId(k)=cellstr(BData{line,12});
                cNr(k)=cellstr(BData{line,10});
                if strcmp(char(datenVon(k)),'null')||strcmp(char(datenBis(k)),'null')==1
                    warndlg('Some Data are not available');
                    datenVon='Error';
                    datenBis='Error';
                    break
                end
            end
        end

      %alte Methoden
        %Messgrößen ID-Abruf aus Excel Tabelle (später aus Datenbank)
        function id=getExcelID(object, vapos)
            x=dir(fullfile('*.xlsx'));
            filematname=Dataimport.excelimport(x);
            load(filematname,'list');
            a=strfind(list(1:end, 3),char(object));
            b=find(~cellfun(@isempty, a));
            id=list(b(vapos),1);
            id=char(id);
        end
    end
end 