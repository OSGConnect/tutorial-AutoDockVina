#!/bin/bash

# Run vina
./vina --config receptor_config.txt \
     --ligand ligand.pdbqt --out receptor-ligand.pdbqt
