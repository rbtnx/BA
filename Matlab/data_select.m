
load('/home/kathrin/Uni/BA/Fette Daten/input.mat');
load('/home/kathrin/Uni/BA/Fette Daten/output.mat');

iNames = fieldnames(input);
oNames = fieldnames(output);

start = (datenum(2016,4,21,0,0,0) - datenum(2016,1,1,0,0,0))*24*60 + 1;
ende = (datenum(2016,4,22,0,0,0) - datenum(2016,1,1,0,0,0))*24*60;

for loopIndex = 1:length(iNames)-1
    work_input(loopIndex,:) = input.(iNames{loopIndex})(start:ende);
end

for loopIndex = 1:length(oNames)-1
    work_output(loopIndex,:) = output.(oNames{loopIndex})(start:ende);
end

work_input = transpose(work_input);
work_output = transpose(work_output);