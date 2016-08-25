c0070 = load('/home/kathrin/Uni/BA/Matlab/MV_04_04_2016/save/LMT Fette__c0070__Durchfluss Kubikmeter pro Stunde__2016__m³_h_raw.mat')
c0113 = load('/home/kathrin/Uni/BA/Matlab/MV_04_04_2016/save/LMT Fette__c0113__Temperatur 1__2016__°C_raw.mat')
c0114 = load('/home/kathrin/Uni/BA/Matlab/MV_04_04_2016/save/LMT Fette__c0114__Temperatur 2__2016__°C_raw.mat')

k = 4.182*1000/3600;   % c*rho*faktor(sek -> h)
Q2 = k*abs(c0070.values(1:309480)).*(c0113.values(1:309480) - c0114.values(1:309480));