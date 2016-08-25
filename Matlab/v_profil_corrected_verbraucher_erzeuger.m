load('/home/kathrin/Uni/BA/Fette Daten/rawdata_fixed/input_rawdata_fixed.mat');

start = 1;
ende = 309480;

%start = (datenum(2016,4,29)-datenum(2016,1,1))*24*60+1;
%ende = (datenum(2016,5,29)-datenum(2016,1,1))*24*60;

iNames = fieldnames(input);
result_in = zeros(ende-start+1,9);

for loopIndex = 1:length(iNames) - 1
    result_in(:,loopIndex) = input.(iNames{loopIndex})(start:ende);
end

time = input.time(start:ende);
result_in = result_in*1000/60;        % Umrechnung m3/h in L/min fuer Korr.faktoren

result_in_corr = result_in;           % erstmal kopieren..
% c0204:
% result_in_corr(:,1) =  xxx     - hinreichend genau
% c0160:
result_in_corr(:,2) =  1.1706*result_in_corr(:,2) + 18.042;
% c0124:
% result_in_corr(:,3) =  xxx     - hinreichend genau
% c0093:
% result_in_corr(:,4) =  0.4826*result_in_corr(:,4) + 38.528;
% c0250: 
result_in_corr(:,5) =  0.93*result_in_corr(:,5) + 8.2;
% c0008:
result_in_corr(:,6) =  1.039*result_in_corr(:,6) + 2.28;
% c0142:
result_in_corr(:,7) =  1.2649*result_in_corr(:,7) - 2.455;
% c0213:
result_in_corr(:,8) =  1.3814*result_in_corr(:,8) - 13.426;
% c0214:
result_in_corr(:,9) =  0.6479*result_in_corr(:,9) + 14.822;

vergleich_in = zeros(9,2);

for i = 1:9
    subplot(3,3,i)
    plot(time,result_in(:,i),time,result_in_corr(:,i));
    title(iNames(i));
    % vergleiche Werte <0 vor und nach Korrekturfaktoren
    vergleich_in(i,:) = [length(find(result_in(:,i) < 0)) length(find(result_in_corr(:,i) < 0))];
end