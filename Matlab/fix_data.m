clear;
load('/home/kathrin/Uni/BA/Fette Daten/input_rawdata.mat');
oNames = fieldnames(input);

for loopIndex = 1:length(oNames) - 1
    nans = find(input.(oNames{loopIndex})>1000 | input.(oNames{loopIndex})<-1000);    % Finde unplausible Werte
    time = 1:length(input.(oNames{loopIndex}));    % Erstelle numerischen Zeitvektor
    i = time;                               % Kopiere Zeitvektor
    sens_fixed = input.(oNames{loopIndex});          % Kopiere Volumenstromvektor
    i(nans) = [];                           % Lösche Zeitwerte für unpl. Werte
    sens_fixed(nans) = [];                  % Lösche unplausible Werte
    input.(oNames{loopIndex}) = interp1(i,sens_fixed,time,'linear');    %lin. Interpolation
end