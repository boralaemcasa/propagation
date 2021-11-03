function plot_fuzzy(h,M,m)

h_plot = h(:,[1 2]);
M_plot = M(:,[1 2]);

[x,y,Z,~] = eval_fcm(h_plot,M_plot,m);

% Plot
figure
hold on
box on
contourf(x,y,Z')
colormap(gray(256));
hcb = colorbar;
title(hcb,'$\mu$', 'interpreter', 'latex')
hcb.TickLabelInterpreter = 'latex';

% Clusters
plot(M_plot(:,1), M_plot(:,2), 'xk', 'Markersize', 20, 'LineWidth', 3)

% Dados
% plot(h_plot(:,1), h_plot(:,2), '.', 'Color', [0.83 0.82 0.78], 'Markersize', 20, 'LineWidth', 3)
plot(h_plot(:,1), h_plot(:,2), '.k','Markersize', 20, 'LineWidth', 3)

hPlots = flip(findall(gcf,'Type','Line'));
legend_str = {'Centros','Dados'};
legend(hPlots, legend_str,'Interpreter','latex')

set(gca,'FontSize',20,'TickLabelInterpreter','latex');
xlabel('Dimens\~ao 1', 'Fontsize', 20, 'Interpreter', 'latex');
ylabel('Dimens\~ao 2', 'Fontsize', 20, 'Interpreter', 'latex');
axis tight

end