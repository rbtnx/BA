function [result,sys,x0] = modelsim(est_data,future_data,mode)

if mode == 0
    [sys,x0] = n4sid(est_data,'best');
else
    [sys,x0] = n4sid(est_data,mode);
end

simOpt = simOptions('InitialCondition',x0);
%preOpt = predictOptions('InitialCondition',x0);
result = sim(sys,future_data,simOpt);
%result = predict(sys,future_data,preOpt);
plot(future_data,result);

end