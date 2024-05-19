function node_coords = createNodeCoords(N)
    node_coords = [];
    for i = 0:(N-1)
        node_coords = [node_coords; 0, i; 1, i];
    end
end
