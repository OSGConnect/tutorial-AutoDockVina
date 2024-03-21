#!/bin/bash

VINA_DIR=$1

# Unzip autodock vina software into a folder called autodock
tar -xzf autodock_vina.tar.gz
export PATH=$PWD/${VINA_DIR}/bin:$PATH

# Make a directory for results
mkdir results

# Run vina on multiple ligands
for LIGAND in *ligand.pdbqt
do 
vina --config receptor_config.txt \
     --ligand ${LIGAND} --out results/receptor-${LIGAND} \
     --log results/receptor-${LIGAND}.log
done
