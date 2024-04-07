function estestnodes = estimate_locations_in_all_borders(estnodes, infos)
	% use convex hull to make further estimations

	estestnodes = estnodes;
	for i = 1 : size(infos, 1)
		% create a target function dynamically
		targetFunc = @(x)0;
		info = infos(i, 1);
        if size(info.members, 1) > 3
            continue;
        end
		inner_obs = info.inner_observations;
		inter_obs = info.inter_observations;
		ms = info.members;
		ns = info.neighbors;
		non_anchors = [];

		% collect all non-anchors in this cluster
		for j = 1 : size(ms, 1)
			m = ms(j, 1);
			if m.confidence ~= 1
				non_anchors = [non_anchors; m];
			end
		end

		% build target function by inner-observations in this cluster
		for j = 1 : size(inner_obs, 1)
			inner_ob = inner_obs(j, 1);
			from_id = inner_ob.from_id;
			to_id = inner_ob.to_id;
			theta = inner_ob.theta;
			if theta >= pi
				theta = theta - 2 * pi;	% make theta in [-pi,pi)
			end
			from_index_in_ms = find_index_by_id(ms, from_id);
			to_index_in_ms = find_index_by_id(ms, to_id);
			from_node = ms(from_index_in_ms, 1);
			to_node = ms(to_index_in_ms, 1);
			if from_node.confidence == 1
				if to_node.confidence ~= 1	% from is anchor, to is non-anchor
					to_index_in_non_anchors = find_index_by_id(non_anchors, to_id);
					targetFunc = @(x)targetFunc(x) + (theta - atan2(from_node.y - x(to_index_in_non_anchors, 2), from_node.x - x(to_index_in_non_anchors, 1))) ^2;
				end
			elseif to_node.confidence ~= 1	% from and to are non-anchors
					from_index_in_non_anchors = find_index_by_id(non_anchors, from_id);
					to_index_in_non_anchors = find_index_by_id(non_anchors, to_id);
					targetFunc = @(x)targetFunc(x) + (theta - atan2(x(from_index_in_non_anchors, 2) - x(to_index_in_non_anchors, 2), x(from_index_in_non_anchors, 1) - x(to_index_in_non_anchors, 1))) ^2;
			end
		end

		% build target function by inter-observations in this cluster
		for j = 1 : size(inter_obs, 1)
			inter_ob = inter_obs(j, 1);
			from_id = inter_obs.from_id;
			to_id = inter_obs.to_id;
			theta = inter_obs.theta;
			if theta >= pi
				theta = theta - 2 * pi;	% make theta in [-pi,pi)
			end
			from_index_in_ns = find_index_by_id(ns, from_id);	% must be in neighbors
			to_index_in_ms = find_index_by_id(ms, to_id);	% must be in members
			from_node = ms(from_index_in_ns, 1);
			to_node = ms(to_index_in_ms, 1);
			weight = 0.01 * (exp(from_node.confidence) - 1);
			to_index_in_non_anchors = find_index_by_id(non_anchors, to_id);
			if to_index_in_non_anchors > 0
				targetFunc = @(x)targetFunc(x) + weight * (theta - atan2(from_node.y - x(to_index_in_non_anchors, 2), from_node.x - x(to_index_in_non_anchors, 1))) ^2;
			end
		end

		options = optimset('PlotFcns', @optimplotfval);
		initial_values = [];
		for i = 1 : size(non_anchors, 1)
			initial_values = [initial_values; non_anchors(i, 1).x, non_anchors(i, 1).y];
		end
		% result = fminunc(targetFunc, initial_values, options);
		result = fminsearch(targetFunc, initial_values, options);
		threshold = 1.0;
		for i = 1 : size(result, 1)
			id = non_anchors(i, 1).id;
			distance = sqrt((result(i, 1) - initial_values(i, 1))^2 + (result(i, 2) - initial_values(i, 2)) ^2);
			if distance < threshold
				index_in_estnodes = find_index_by_id(estestnodes, id);
				estestnodes(index_in_estnodes, 1).x = result(i, 1);
				estestnodes(index_in_estnodes, 1).y = result(i, 2);
			end
		end
	end

	write_json_data(estestnodes, "estnodes_3.json");

end