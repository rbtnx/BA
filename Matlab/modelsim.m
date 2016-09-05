function [result,sys,x0] = modelsim(est_data,future_data)

[sys,x0] = n4sid(est_data,'best');
%[sys,x0] = n4sid(est_data,2);

simOpt = simOptions('InitialCondition',x0);
result = sim(sys,future_data,simOpt);
plot(future_data,result);

end