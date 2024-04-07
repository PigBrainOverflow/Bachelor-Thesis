% 创建一个新的图形窗口
figure;

% 定义坐标点
x = [10234, 22400, 29004, 32684, 23584, 80000, 4160, 4160]; % x坐标
y = [0.169, 0.122, 0.0843, 0.0831, 0.139, 0.089, 0.044, 0.0064]; % y坐标

% 绘制折线
plot(x(1:4), y(1:4), '-o'); % 使用'-o'选项绘制带有圆点的折线
hold on; % 保持图形窗口以便添加更多元素

% 绘制两个孤立的点
plot(x(5), y(5), 'rs', 'MarkerSize', 10); % 使用'red square'标志
text(x(5), y(5), 'consumption-aware', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');

plot(x(6), y(6), 'rs', 'MarkerSize', 10); % 使用'red square'标志
text(x(6), y(6), 'original', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');

plot(x(7), y(7), 'gd', 'MarkerSize', 10); % 使用'green diamond'标志
text(x(7), y(7), 'ILOR', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');

plot(x(8), y(8), 'gd', 'MarkerSize', 10); % 使用'green diamond'标志
text(x(8), y(8), 'optimal', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');


% 添加标题和标签
title('Comparison with other algorithms');
xlabel('Bytes of transmission');
ylabel('Avg error');

% 添加图例
%legend('折线', '孤立点1', '孤立点2');

% 显示网格
%grid on;

% 保持图形窗口开启，以便查看图形
hold off;
