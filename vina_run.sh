#!/bin/bash

VINA_TGZ=$1
VINA_DIR=$2

# Unzip autodock vina software into a folder called autodock
tar -xzf ${VINA_TGZ}
export PATH=$PWD/${VINA_DIR}/bin:$PATH

# Run vina
vina --config receptor_config.txt \
     --ligand ligand.pdbqt --out receptor-ligand.pdbqt \
     --log receptor-ligand.log
