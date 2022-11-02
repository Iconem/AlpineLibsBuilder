# AlpineLibsBuilder

## Objectif
Un utilitaire permettant de générer des exécutables compatibles alpine (version: **node:16.14.0-alpine3.15**) :
- PotreeConverter1.7
- PotreeConverter2.1
- camCalibNode (solveur PNP)

## Build
Attention : il peut être nécessaire de lancer la commande avec les droits admin.
`sh build.sh`
Les exécutables sont générés dans le dossier `build`.

## Lancement des exécutables

### PotreeConverter1.7
cd build/PotreeConverter1.7
mv lib/* /usr/local/lib
./PotreeConverter

### PotreeConverter2.1
cd build/PotreeConverter2.1
./PotreeConverter

### camCalibNode
cd build/PNPSolver
mv lib/* /usr/local/lib
./camCalibNode
