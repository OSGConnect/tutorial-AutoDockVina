#!/bin/bash

VINA_DIR=$1

# Unzip autodock vina software into a folder called autodock
tar -xzf autodock_vina.tar.gz
export PATH=$PWD/${VINA_DIR}/bin:$PATH

# Make a directory for results
mkdir results

# Run vina
vina --config receptor_config.txt \
     --ligand ligand.pdbqt --out results/receptor-ligand.pdbqt \
     --log results/receptor-ligand.log
