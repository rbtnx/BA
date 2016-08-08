clear;
load('/home/kathrin/Uni/BA/Fette Daten/output.mat');
oNames = fieldnames(output);

for loopIndex = 1:length(oNames) - 1
    nans = find(output.(oNames{loopIndex})>100);    % Finde unplausible Werte
    time = 1:length(output.(oNames{loopIndex}));    % Erstelle numerischen Zeitvektor
    i = time;                               % Kopiere Zeitvektor
    sens_fixed = output.(oNames{loopIndex});          % Kopiere Volumenstromvektor
    i(nans) = [];                           % Lösche Zeitwerte für unpl. Werte
    sens_fixed(nans) = [];                  % Lösche unplausible Werte
    output.(oNames{loopIndex}) = interp1(i,sens_fixed,time,'linear');    %lin. Interpolation
end