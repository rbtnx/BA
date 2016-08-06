function plot_val(start_date,M)

inputfile = load('/home/kathrin/Uni/BA/Fette Daten/input.mat');
outputfile = load('/home/kathrin/Uni/BA/Fette Daten/output.mat');

iNames = fieldnames(inputfile.input);
oNames = fieldnames(outputfile.output);

start = (datenum(start_date) - datenum(2016,1,1,0,0,0))*24*60 + 1;
ende = start + 1439;        % 1439 = 24*60 - 1 (00:00 - 23:59)

for loopIndex = 1:length(iNames)-1
    val_input(loopIndex,:) = inputfile.input.(iNames{loopIndex})(start:ende);
end

for loopIndex = 1:length(oNames)-1
    val_output(loopIndex,:) = outputfile.output.(oNames{loopIndex})(start:ende);
end

time = inputfile.input.time(start:ende);

val_input = transpose(val_input);
val_output = transpose(val_output);

val_calc = val_input * M;


for loopIndex = 1:5
    subplot(3,2,loopIndex);
    plot(time,val_output(:,loopIndex));
    hold on;
    plot(time, val_calc(:,loopIndex));
    axis([datenum(time(1)) datenum(time(1440)) -10 20])
    legend('gemessen', 'berechnet');
    title(oNames(loopIndex));
end

end