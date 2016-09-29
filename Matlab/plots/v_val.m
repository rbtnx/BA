
figure(1)
plot(1:10080,output.(oNames{1})(start:ende));hold on;plot(val_calc(:,1));
xlim([1 10080]);
ylim([2 18]);
xl = xlabel('Zeit in min'); yl = ylabel('$\dot{V}_{1}$ in $m^3h^{-1}$');
set(gcf, 'PaperPosition', [0 0 15 3])
set(gcf, 'PaperSize', [15 3.5]);
saveas(gcf,'/home/kathrin/Uni/BA/Latex/Thesis/figures/val/v1.pdf','pdf');

figure(2)
plot(1:10080,output.(oNames{2})(start:ende));hold on;plot(val_calc(:,2));
xlim([1 10080]);
ylim([2 8]);
xl = xlabel('Zeit in min'); yl = ylabel('$\dot{V}_{2}$ in $m^3h^{-1}$');
set(gcf, 'PaperPosition', [0 0 15 3])
set(gcf, 'PaperSize', [15 3.5]);
saveas(gcf,'/home/kathrin/Uni/BA/Latex/Thesis/figures/val/v2.pdf','pdf');

figure(3)
plot(1:10080,output.(oNames{3})(start:ende));hold on;plot(val_calc(:,3));
xlim([1 10080]);
ylim([-3 3]);
xl = xlabel('Zeit in min'); yl = ylabel('$\dot{V}_{3}$ in $m^3h^{-1}$');
set(gcf, 'PaperPosition', [0 0 15 3])
set(gcf, 'PaperSize', [15 3.5]);
saveas(gcf,'/home/kathrin/Uni/BA/Latex/Thesis/figures/val/v3.pdf','pdf');

figure(4)
plot(1:10080,output.(oNames{4})(start:ende));hold on;plot(val_calc(:,4));
xlim([1 10080]);
ylim([0 2.5]);
xl = xlabel('Zeit in min'); yl = ylabel('$\dot{V}_{4}$ in $m^3h^{-1}$');
set(gcf, 'PaperPosition', [0 0 15 3])
set(gcf, 'PaperSize', [15 3.5]);
saveas(gcf,'/home/kathrin/Uni/BA/Latex/Thesis/figures/val/v4.pdf','pdf');

figure(5)
plot(1:10080,output.(oNames{5})(start:ende));hold on;plot(val_calc(:,5));
xlim([1 10080]);
ylim([-8 -1]);
xl = xlabel('Zeit in min'); yl = ylabel('$\dot{V}_{5}$ in $m^3h^{-1}$');
set(gcf, 'PaperPosition', [0 0 15 3])
set(gcf, 'PaperSize', [15 3.5]);
saveas(gcf,'/home/kathrin/Uni/BA/Latex/Thesis/figures/val/v5.pdf','pdf');