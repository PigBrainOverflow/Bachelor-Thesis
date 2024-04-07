function index = find_index_by_id(nodes, id)
	index = 0;
	for i = 1 : size(nodes, 1)
		if nodes(i, 1).id == id
			index = i;
			break;
		end
	end
end