function estnodes = estimate_locations_in_all_clusters(nodes, observations, clusters)
	% this is a wrapper for estimateLocationsInAllClusters.m

	raw_nodes = [];
	n = size(nodes, 1)
	for i = 1 : n
		raw_nodes = [raw_nodes; nodes(i).x, nodes(i).y, nodes(i).confidence];
	end
	raw_observations = [];
	for i = 1 : size(observations, 1)
		raw_observations = [raw_observations; observations(i).from_id, observations(i).to_id, observations(i).theta];
	end
	raw_clusters = {};
	for i = 1 : size(clusters, 1)
		raw_clusters = [raw_clusters; clusters(i).members];
	end
	raw_estnodes = estimateLocationsInAllClusters(raw_nodes, raw_observations, raw_clusters);
	estnodes = struct("id", cell(n, 1), "x", cell(n, 1), "y", cell(n, 1), "confidence", cell(n, 1));
	for i = 1 : n
		estnodes(i).id = i;
		estnodes(i).x = raw_estnodes(i, 1);
		estnodes(i).y = raw_estnodes(i, 2);
		estnodes(i).confidence = raw_estnodes(i, 3);
	end
	write_json_data(estnodes, "estnodes_2.json");