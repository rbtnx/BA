clear;
load('/home/kathrin/Uni/BA/Fette Daten/waerme_rawdata.mat');
oNames = fieldnames(waerme);

for loopIndex = 1:length(oNames) - 3
    nans = find(waerme.(oNames{loopIndex})>1000 | waerme.(oNames{loopIndex})<-1000);    % Finde unplausible Werte
    time = 1:length(waerme.(oNames{loopIndex}));    % Erstelle numerischen Zeitvektor
    i = time;                               % Kopiere Zeitvektor
    sens_fixed = waerme.(oNames{loopIndex});          % Kopiere Volumenstromvektor
    i(nans) = [];                           % Lösche Zeitwerte für unpl. Werte
    sens_fixed(nans) = [];                  % Lösche unplausible Werte
    output.(oNames{loopIndex}) = interp1(i,sens_fixed,time,'linear');    %lin. Interpolation
end