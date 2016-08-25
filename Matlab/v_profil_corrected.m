clear;

% Output

load('/home/kathrin/Uni/BA/Fette Daten/output_rawdata_fixed.mat');
start = (datenum(2016,4,29)-datenum(2016,1,1))*24*60+1;
ende = (datenum(2016,5,29)-datenum(2016,1,1))*24*60;

oNames = fieldnames(output);
result_out = zeros(ende-start+1,5);

for loopIndex = 1:length(oNames) - 1
    result_out(:,loopIndex) = output.(oNames{loopIndex})(start:ende);
end

time = output.time(start:ende);
result_out = result_out*1000/60;        % Umrechnung m3/h in L/min fuer Korr.faktoren

result_out_corr = result_out;           % erstmal kopieren..
result_out_corr(:,1) =  0.9276*result_out_corr(:,1) + 25.388;
result_out_corr(:,2) =  1.09*result_out_corr(:,2) + 23.8;
% result_out_corr(:,3) =  xxx   - hinreichend genau
result_out_corr(:,4) =  0.4826*result_out_corr(:,4) + 38.528;
result_out_corr(:,5) =  1.03*result_out_corr(:,5) - 3.03;

for i = 1:5
    subplot(2,3,i)
    plot(time,result_out(:,i),time,result_out_corr(:,i));
end

% Input

load('/home/kathrin/Uni/BA/Fette Daten/input_rawdata_fixed.mat');

iNames = fieldnames(input);
result_in = zeros(ende-start+1,9);

for loopIndex = 1:length(oNames) - 1
    result_in(:,loopIndex) = input.(iNames{loopIndex})(start:ende);
end

result_in = result_in*1000/60;        % Umrechnung m3/h in L/min fuer Korr.faktoren

result_in_corr = result_out;           % erstmal kopieren..
result_in_corr(:,1) =  0.9276*result_in_corr(:,1) + 25.388;
result_in_corr(:,2) =  1.09*result_in_corr(:,2) + 23.8;
% result_in_corr(:,3) =  xxx   - hinreichend genau
result_in_corr(:,4) =  0.4826*result_in_corr(:,4) + 38.528;
result_in_corr(:,5) =  1.03*result_in_corr(:,5) - 3.03;

for i = 1:9
    subplot(2,3,i)
    plot(time,result_out(:,i),time,result_out_corr(:,i));
end