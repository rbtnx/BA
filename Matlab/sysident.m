function [M] = sysident(start_date)
in_file = load('/home/kathrin/Uni/BA/Fette Daten/input_nur_erzeuger.mat');
o_file = load('/home/kathrin/Uni/BA/Fette Daten/output_rawdata_fixed.mat');

iNames = fieldnames(in_file.input);
oNames = fieldnames(o_file.output);

start = (datenum(start_date) - datenum(2016,1,1,0,0,0))*24*60 + 1
ende = start + 1439                 % 23h, 59 min = 1439 min

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