#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=128
#SBATCH --mem=16gb
#SBATCH -t 01:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rlanders@umn.edu
#SBATCH -p agsmall
cd ~/datascience/projects/week11/msi/
module load R/4.3.0-openblas
Rscript week11-cluster.R
