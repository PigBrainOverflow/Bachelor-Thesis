% 创建一个简单的MATLAB GUI
figure('Name', '坐标生成器', 'NumberTitle', 'off', 'Position', [100, 100, 400, 300]);
axes('Position', [0.1, 0.1, 0.8, 0.8]);

% 初始化坐标保存变量
coordinates = [];

% 设置图形交互
set(gcf, 'WindowButtonDownFcn', @generateCoordinates);

% 回调函数，用于生成坐标
function generateCoordinates(~, ~)
    % 获取当前坐标
    pos = get(gca, 'CurrentPoint');
    x = pos(1, 1);
    y = pos(1, 2);
    
    % 在图形上绘制红点
    hold on;
    plot(x, y, 'ro'); % 'ro'表示红色圆点
    hold off;
    
    % 将坐标保存到变量coordinates中
    global coordinates; % 声明coordinates为全局变量
    coordinates = [coordinates; x, y];
    
    % 显示坐标文本
    text(x, y, sprintf('X: %.2f, Y: %.2f', x, y));
    
    % 保存coordinates变量到工作区
    assignin('base', 'coordinates', coordinates);
end
