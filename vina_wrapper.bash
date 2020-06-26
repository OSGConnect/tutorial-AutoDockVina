#!/bin/bash

# Unzip autodock vina software
tar -xzf VINA_TGZ
export PATH=$PWD/VINA_DIR/bin:$PATH

# Run vina
vina --config receptor_config.txt \
     --ligand ligand.pdbqt --out receptor-ligand.pdbqt \
     --log receptor-ligand.log
