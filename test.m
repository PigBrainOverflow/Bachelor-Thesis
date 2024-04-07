% 创建一个结构数组
dataStruct = struct('column1', [], 'column2', [], 'column3', []);

% 假设你的矩阵名为matrix
matrix = [1, 2, 3; 4, 5, 6; 7, 8, 9]; % 用你的实际数据替换这个示例数据

% 使用循环将每列的数据添加到结构数组中
for i = 1:size(matrix, 2)
    columnName = sprintf('column%d', i);
    dataStruct(1).(columnName) = matrix(:, i);
end

% 现在dataStruct包含了每列数据的结构数组
