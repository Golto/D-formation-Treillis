%{
# Informations

- Auteur : Guillaume FOUCAUD
- Groupe : M1-MACS
- Date : 19/05/2024
- Logiciels nécessaires (un des deux):
  - Octave : https://octave.org/
  - Matlab : https://fr.mathworks.com/

# Contexte

Notre objet d'étude est un treillis composé d'éléments barres sur lequel on applique une force latérale.
L'objectif est de simuler les déformations du treillis et de les visualiser.

Le code est en très grande partie une réécriture d'un code de référence `treillisexemple.m` (non fournie)

# Utilisation

Pour lancer le programme, exécuter `main.m`.

Pour modifier les données du problème, modifier les paramètres suivant dans `main.m` :
```matlab
F = 0.01; % force extérieur
ES = 1.0; % raideur

number_floors = 5; % nombre d'étages
bar_length = 1.0; % longueur d'une barre
```

!Important - Dans un même fichier vous devez avoir les dépendances suivantes :
- `main.m`
- `createNodeCoords.m`
- `createConnectTable.m`
- `createMatrix.m`
- `solveDisplacements.m`
- `postProcessing.m`
- `plotStructure.m`
%}

function main

  disp('---------------------------------------------------------------------------------');
  disp('Structure étudiée: treillis');
  disp('---------------------------------------------------------------------------------');

  %=========================================================================================
  %               PREMIERE ETAPE: DONNEES DU PROBLEME, MAILLAGE
  %=========================================================================================

  %*****************************************************************************************
  %    1 DEFINITIONS: GEOMETRIE, MAILLAGE, forces ET CONDITIONS AUX LIMITES
  %*****************************************************************************************

  F = 0.01; % force extérieur
  ES = 1.0; % raideur

  number_floors = 5; % nombre d'étages
  bar_length = 1.0; % longueur d'une barre


  node_coords = createNodeCoords(number_floors); % création des coordonnées des noeuds
  node_positions = node_coords * bar_length; % positions des noeuds
  number_nodes = length(node_positions); % nombre de noeuds

  dof_per_node = 2; % nombre de degrés de liberté par noeud
  total_dof = number_nodes * dof_per_node; % nombre de degrés de liberté

  %*****************************************************************************************
  %    2 TABLE DES CONNECTIVITES
  %*****************************************************************************************

  connect_table = createConnectTable(number_floors);
  number_bars = size(connect_table, 1);

  %*****************************************************************************************
  %   3  CONDITIONS AUX LIMITES
  %*****************************************************************************************

  boundary_conditions = [1, 1, 1; ...  % noeud 1, u bloqué, v bloqué
                         2, 1, 1];     % noeud 2, u bloqué, v bloqué
  number_embeds = size(boundary_conditions, 1);

  %*****************************************************************************************
  %   4  CHARGEMENT EXTERIEUR
  %*****************************************************************************************

  % force latérale s'applique sur les noeuds impairs (cf FIGURE 1 & 2)
  forces = [];
  for i = 1:2:number_nodes
    forces = [forces; i, F, 0];
  end
  number_forces = size(forces, 1);


  %*****************************************************************************************
  %   5  AFFICHAGE GRAPHIQUE
  %*****************************************************************************************

  plotStructure(node_positions, connect_table, forces, number_forces, number_nodes, number_bars, number_floors, boundary_conditions, number_embeds);

  %=========================================================================================
  %               SECONDE ETAPE: BLOC DE CALCUL
  %=========================================================================================

  %*****************************************************************************************
  %    1  MATRICES et VECTEURS ASSEMBLES
  %*****************************************************************************************

  % Création de la matrice K
  K = createMatrix(connect_table, node_positions, ES, total_dof);


  %*****************************************************************************************
  %    2  SOLUTION DU CALCUL DES DEPLACEMENTS INCONNUS
  %    3  VECTEURS DES DEPLACEMENTS: LES SOLUTIONS+LES DEPLACEMENTS IMPOSES
  %*****************************************************************************************

  U = solveDisplacements(K, forces, number_forces, boundary_conditions, number_embeds, total_dof);

  %*****************************************************************************************
  %    4  POST TRAITEMENT
  %*****************************************************************************************

  new_positions = postProcessing(U, node_positions, dof_per_node, number_nodes)

  plotStructure(new_positions, connect_table, forces, number_forces, number_nodes, number_bars, number_floors, boundary_conditions, number_embeds);

  %=========================================================================================

end


main;



