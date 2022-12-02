function fnplot(RF)

%RF in table format

% This methodologies assumes Hoop reinforcement only, which doesn't change
% base layup percentage
f=figure;
sgtitle('Reserve Factor vs Number of Reinforcement Layers')

subplot(2,3,1)
plot(RF.n_reinforcement,RF.sigma,'o--','MarkerSize',8)
grid on
hold on
line(xlim(), [1,1], 'LineWidth', 2, 'Color', 'k');
subtitle('Direct Stress')
% xlabel('num of reinforcement')
% ylabel('RF')

subplot(2,3,2)
plot(RF.n_reinforcement,RF.tao,'o--','MarkerSize',8)
grid on
hold on
line(xlim(), [1,1], 'LineWidth', 2, 'Color', 'k');
subtitle('Shear Stress')
% xlabel('num of reinforcement')
% ylabel('RF')

subplot(2,3,3)
plot(RF.n_reinforcement,RF.direct_shear_combined,'o--','MarkerSize',8)
grid on
hold on
line(xlim(), [1,1], 'LineWidth', 2, 'Color', 'k');
subtitle('Direct & Shear Stress Combined')
% xlabel('num of reinforcement')
% ylabel('RF')

subplot(2,3,4)
plot(RF.n_reinforcement,RF.compres_buckling,'o--','MarkerSize',8)
grid on
hold on
line(xlim(), [1,1], 'LineWidth', 2, 'Color', 'k');
subtitle('Compression Buckling')
% xlabel('num of reinforcement')
% ylabel('RF')

subplot(2,3,5)
plot(RF.n_reinforcement,RF.shear_buckling,'o--','MarkerSize',8)
grid on
hold on
line(xlim(), [1,1], 'LineWidth', 2, 'Color', 'k');
subtitle('Shear Buckling')
% xlabel('num of reinforcement')
% ylabel('RF')

subplot(2,3,6)
plot(RF.n_reinforcement,RF.compres_shear_cr_combined,'o--','MarkerSize',8)
grid on
hold on
line(xlim(), [1,1], 'LineWidth', 2, 'Color', 'k');
subtitle('Compression & Shear Buckling Combined')
% xlabel('num of reinforcement')
% ylabel('RF')

end