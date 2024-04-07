
figure;

plot(0:3,errors0, 'r--', 'LineWidth', 1);
hold on;
plot(0:3,errors2, 'b-', 'LineWidth', 1);
plot(0:3,errors1, 'g:', 'LineWidth', 1);

scatter(0:3, errors0, 20, 'r', 'filled'); 
scatter(0:3, errors2, 20, 'b', 'filled'); 
scatter(0:3, errors1, 20, 'g', 'filled'); 

legend('N=50, L=0.2', 'N=50, L=0.1', 'N=100, L=0.1');

xlabel('Phase No.');
ylabel('MSE (of location)');
xticks(0:3)

title('MSE after each phase');
hold off;
