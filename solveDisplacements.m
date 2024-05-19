function U = solveDisplacements(K, forces, number_forces, boundary_conditions, number_embeds, total_dof)
    % résout K * U = forceVector -----------------------------------------------------------------------

    forceVector = zeros(total_dof, 1);
    for i = 1:size(forces, 1)
        node_i = forces(i, 1);
        forceVector(2 * node_i - 1) = forces(i, 2);
        forceVector(2 * node_i) = forces(i, 3);
    end

    %K, forceVector % debug

    % résout K_reduced * U = force_reduced -------------------------------------------------------------

    K_reduced = K;
    force_reduced = forceVector;

    % gestion des lignes et des colonnes pour ne garder que les déplacements inconnus
    % ici, notre stratégie est de garder dans des listes tous les indices de lignes et colonnes à supprimer
    % pour éviter de créer des décalages d'indices et de finir par supprimer les mauvaises lignes.
    % C'est important que les indices ne changent pas jusqu'à la fin.
    rows_to_remove = [];
    cols_to_remove = [];

    for i = 1:number_embeds

        node_i = boundary_conditions(i, 1);
        is_blocked_x = boundary_conditions(i, 2);
        is_blocked_y = boundary_conditions(i, 3);

        if is_blocked_x == 1
            rows_to_remove = [rows_to_remove, 2 * node_i - 1];
            cols_to_remove = [cols_to_remove, 2 * node_i - 1];
        end

        if is_blocked_y == 1
            rows_to_remove = [rows_to_remove, 2 * node_i];
            cols_to_remove = [cols_to_remove, 2 * node_i];
        end
    end

    % et maintenant, on peut supprimer les lignes et les colonnes

    K_reduced(rows_to_remove, :) = [];
    K_reduced(:, cols_to_remove) = [];
    force_reduced(rows_to_remove) = [];

    %K_reduced, force_reduced % debug

    U_reduced = K_reduced \ force_reduced;

    % reconstruire U: U_reduced --> U -------------------------------------------------------------------

    U = zeros(total_dof, 1);
    blocked_dof = false(total_dof, 1);

    for i = 1:size(boundary_conditions, 1)
        node_i = boundary_conditions(i, 1);
        if boundary_conditions(i, 2) == 1
            blocked_dof(2 * node_i - 1) = true;
        end
        if boundary_conditions(i, 3) == 1
            blocked_dof(2 * node_i) = true;
        end
    end

    j = 1;
    for i = 1:total_dof
        if blocked_dof(i)
            U(i) = 0;
        else
            U(i) = U_reduced(j);
            j = j + 1;
        end
    end

    %U % debug

end
