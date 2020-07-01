#!/bin/bash

# Unzip autodock vina software into a folder called autodock
tar -xzf autodock_vina.tar.gz
export PATH=$PWD/AUTODOCK_FOLDER/bin:$PATH

# Run vina
vina --config receptor_config.txt \
     --ligand ligand.pdbqt --out receptor-ligand.pdbqt \
     --log receptor-ligand.log
