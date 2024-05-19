function plotStructure(node_positions, connect_table, forces, number_forces, number_nodes, number_bars, number_floors, boundary_conditions, number_embeds)

  % propriétés générales du graphique
  figure('Position', [20, 100, 800, 800], 'Name', 'Treillis', 'NumberTitle', 'off');
  hold on;
  title('Maillage, CL  et forces appliquées sur la structure étudiee')
  %axis equal;
  grid on;
  xlabel('X');
  ylabel('Y');
  zlabel('Z');



  % tracé des noeuds marqueurs points rouges
  X = node_positions(:, 1);
  Y = node_positions(:, 2);
  Z = zeros(size(X));


  plot3(X, Y, Z, '.', 'color', 'r', 'MarkerSize', 16);

  for i = 1:number_nodes
      text(X(i) + 0.05, Y(i) + 0.05, Z(i) + 0.01, [' ', num2str(i)], 'color', 'r', 'FontSize', 18);
  end

  xlim([-0.2, 1.2]);
  ylim([-0.2, number_floors - 0.8]);
  zlim([-0.2, 0.2]);


  % affichage des encastrements
  for i = 1:number_embeds
    node_i = boundary_conditions(i, 1);
    if (boundary_conditions(i,2) == 0)
        plot3(X(node_i), Y(node_i), Z(node_i), '*', 'color', 'k', 'MarkerSize', 16, 'LineWidth', 1.3);
    else
        plot3(X(node_i), Y(node_i), Z(node_i), '^', 'color', 'k', 'MarkerSize', 16, 'LineWidth', 1.3);
    end

  end

  % affichage des forces
  for i = 1:number_forces
      node_i = forces(i, 1);
      %Fx = forces(i, 2);
      quiver3(X(node_i) - 0.2, Y(node_i), Z(node_i), 0.2, 0, 0, 'k', 'LineWidth', 2, 'MaxHeadSize', 0.3);
  end


  % tracé de l'élément barre et sa numérotation
  for i = 1:number_bars
      node1 = connect_table(i, 1);
      node2 = connect_table(i, 2);

      X1 = X(node1);
      Y1 = Y(node1);
      Z1 = Z(node1);
      X2 = X(node2);
      Y2 = Y(node2);
      Z2 = Z(node2);

      line([X1, X2], [Y1, Y2], [Z1, Z2], 'color', 'b', 'LineWidth', 2);

      Xmean = (X1 + X2) / 2;
      Ymean = (Y1 + Y2) / 2;
      Zmean = (Z1 + Z2) / 2;
      text(Xmean + 0.05, Ymean + 0.05, Zmean + 0.01, ['bar:', num2str(i)], 'color', 'b', 'FontSize', 18);
  end

  hold off;
end
