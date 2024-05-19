function new_positions = postProcessing(U, node_positions, dof_per_node, number_nodes)
    new_positions = node_positions;
    j = 1;
    for i = 1:number_nodes
        new_positions(i, 1) = node_positions(i, 1) + U(j);
        new_positions(i, 2) = node_positions(i, 2) + U(j+1);
        j = j + dof_per_node;
    end
end
