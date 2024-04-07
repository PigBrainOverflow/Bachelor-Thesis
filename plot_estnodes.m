function plot_estnodes(nodes, estnodes)
    % plot nodes
    scatter([nodes.x], [nodes.y], 16,'b', 'filled');
    hold on;

    % plot estnodes
    anchor_indices = find([estnodes.confidence] == 1);
    non_anchor_indices = find([estnodes.confidence] ~= 1);
    estx = [estnodes.x];
    esty = [estnodes.y];
    
    scatter(estx(anchor_indices), esty(anchor_indices), 16,'r', 'filled');
    scatter(estx(non_anchor_indices), esty(non_anchor_indices),16, 'o');
    
    % draw lines between each pair
    for i = 1:size(nodes, 1)
        if estnodes(i).confidence == 1
            line([nodes(i).x, estnodes(i).x], [nodes(i).y, estnodes(i).y], 'Color', 'm');
        else
            line([nodes(i).x, estnodes(i).x], [nodes(i).y, estnodes(i).y], 'Color', 'k');
        end
    end
end
