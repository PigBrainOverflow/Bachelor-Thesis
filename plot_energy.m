
% 绘制散点图
scatter([nodes.x], [nodes.y], 16, subtrees, 'filled');
colormap(jet); % 使用jet色图来表示权重，可以根据需要选择其他色图
colorbar; % 显示颜色条

% 添加标题和标签
title('二维点的权重表示');
xlabel('X轴');
ylabel('Y轴');

% 可以根据需要保存图像
% saveas(gcf, 'weighted_scatter.png');
