function errors = calculate_errors(nodes, estnodes)

n = [];
est = [];

for i = 1 : length(nodes)
    n = [n; nodes(i).x, nodes(i).y];
    est = [est; estnodes(i).x, estnodes(i).y];
end

distances = sum((n(:, 1:2) - est(:, 1:2)).^2, 2);
mse = mean(distances);
errors = mse;
