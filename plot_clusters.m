function plot_clusters(nodes, clusters)

	edges_from = [];
	edges_to = [];

	for i = 1 : length(clusters)
		cluster = clusters(i);
		head = cluster.head;
		members = cluster.members;

		for j = 1 : length(members)
			member_id = members(j);
			edges_from = [edges_from, member_id];
			edges_to = [edges_to, head];
		end
	end

	G = graph(edges_from, edges_to, "omitselfloops");
	plot(G, 'XData', [nodes.x], 'YData', [nodes.y]);

	title('Cluster Graph with Positions');
	xlabel('X');
	ylabel('Y');
	xlim([0, 8]);
	ylim([0, 8]);

end
