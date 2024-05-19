
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