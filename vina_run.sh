#!/bin/bash

# Run vina
vina --config receptor_config.txt \
     --ligand ligand.pdbqt --out results/receptor-ligand.pdbqt
