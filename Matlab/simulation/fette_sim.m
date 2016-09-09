function [tv,q,v_calc] = fette_sim(start_date,hz1_input,komp_input,ta,v_input)

%%%%%% Simulation der nächsten 7 Tage aus Identifikationsdaten

cd(['/home/kathrin/Uni/BA/Matlab/simulation/simdata/',datestr(start_date,'yy-mm-dd')])
load('SS_tv.mat');
load('SS_q.mat');
load('SS_dt.mat');
load('M.mat');
load('wp_calc.mat');

sNames = fieldnames(SS_tv);
tNames = {'Tv1','Tv2','Tv3','Tv4','Tv5'};
qNames = {'Q1','Q2','Q3','Q4','Q5'};

for i = 1:5
   simOpt_tv.(tNames{i}) = simOptions('InitialCondition',SS_tv.(sNames{2*i})); 
   simOpt_q.(qNames{i}) = simOptions('InitialCondition',SS_q.(sNames{2*i}));
end

tv.(tNames{1}) = sim(SS_tv.SS1,[hz1_input;wp_calc.W1]',simOpt_tv.Tv1);
tv.(tNames{2}) = sim(SS_tv.SS2,[tv.Tv1,wp_calc.W2'],simOpt_tv.Tv2);
tv.(tNames{3}) = sim(SS_tv.SS3,[tv.Tv2,wp_calc.W3'],simOpt_tv.Tv3);
tv.(tNames{4}) = sim(SS_tv.SS4,[komp_input;wp_calc.W5]',simOpt_tv.Tv4);
tv.(tNames{5}) = sim(SS_tv.SS5,hz1_input',simOpt_tv.Tv5);


for i = 1:5
    q.(qNames{i}) = sim(SS_q.(sNames{i*2-1}),[ta',tv.(tNames{i})],simOpt_q.(qNames{i}));
end

v_calc = v_input*M;



end