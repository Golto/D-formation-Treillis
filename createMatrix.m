function matrix = createMatrix(connect_table, node_positions, ES, total_dof)
    matrix = zeros(total_dof);
    delta_X = node_positions(connect_table(:, 2), 1) - node_positions(connect_table(:, 1), 1);
    delta_Y = node_positions(connect_table(:, 2), 2) - node_positions(connect_table(:, 1), 2);
    for element_i = 1:size(connect_table, 1)
        dX = delta_X(element_i);
        dY = delta_Y(element_i);
        L = sqrt(dX^2 + dY^2); % longueur de l'élément i
        c = dX / L; % cosinus de l'angle
        s = dY / L; % sinus de l'angle
        elementary_matrix = (ES / L) * [c*c, c*s, -c*c, -c*s; ...
                                        c*s, s*s, -c*s, -s*s; ...
                                        -c*c, -c*s, c*c, c*s; ...
                                        -c*s, -s*s, c*s, s*s]; % matrice de rigidité élémentaire
        localisation = [];
        for i = 1:2
            localisation = [localisation, (connect_table(element_i, i) - 1) * 2 + [1:2]]; % localisation dans la matrice
        end
        matrix(localisation, localisation) = matrix(localisation, localisation) + elementary_matrix; % assemblage
    end
end


