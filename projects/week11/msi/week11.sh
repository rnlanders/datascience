#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --mem=16gb
#SBATCH -t 00:05:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rlanders@umn.edu
#SBATCH -p msismall
cd ~/msi
module load R/4.4.2-openblas-rocky8
Rscript week11-cluster.R