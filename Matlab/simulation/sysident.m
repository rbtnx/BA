function [M] = sysident(start_date)

% 09-09: Nur Erzeuger-Daten als input! Keine Genauigkeitsveränderung zu 9
% inputs (alte Version)
in_file = load('/home/kathrin/Uni/BA/Fette Daten/corrected_data/input_erzeuger.mat'); 
o_file = load('/home/kathrin/Uni/BA/Fette Daten/corrected_data/output_corr.mat');

iNames = fieldnames(in_file.input);
oNames = fieldnames(o_file.output);

start = (datenum(start_date) - datenum(2016,1,1))*24*60 + 1;
ende = start + 3*1440-1;                 %start + 3 Tage


for loopIndex = 1:length(iNames)-1
    work_input(loopIndex,:) = in_file.input.(iNames{loopIndex})(start:ende);
end

for loopIndex = 1:length(oNames)-1
    work_output(loopIndex,:) = o_file.output.(oNames{loopIndex})(start:ende);
end

work_input = transpose(work_input);
work_output = transpose(work_output);
M = work_input \ work_output;

end