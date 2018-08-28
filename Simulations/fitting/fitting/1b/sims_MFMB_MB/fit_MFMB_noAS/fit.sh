#!/bin/bash
#
#SBATCH -p ncf
#SBATCH -t 0-01:30
#SBATCH --mem 300
#SBATCH -o /dev/null
#SBATCH -e /dev/null

nStarts="25"
fixedParams="[-1 -1 -1 -1 -1 1 0]"

dataname="sims.mat"
envname="env_1b.mat"
savename="params"
outputname="Params_Subj${SLURM_ARRAY_TASK_ID}.txt"

datapath="fitting/1b/sims_MFMB_MB"
envpath="env"
savepath="fitting/1b/sims_MFMB_MB/fit_MFMB_noAS"

homedir="/users/amorris/Documents/Dezfouli/git/Simulations";
scratchdir="/scratch/amorris/$SLURM_JOBID/$SLURM_ARRAY_TASK_ID"

if [ ! -f "$homedir/$datapath/$savename/$outputname" ]; then

	if [ ! -d "$scratchdir/$savename/" ]; then
		mkdir -p "$scratchdir/$savename/"
	fi
	if [ ! -d "$homedir/$savepath/$savename/" ]; then
		mkdir "$homedir/$savepath/$savename/"
	fi

	cp "$homedir/$datapath/$dataname" "$scratchdir/"
	cp "$homedir/$envpath/$envname" "$scratchdir/"

	matlab -nojvm -nodisplay -nosplash -nodesktop -r "addpath $homedir; fitModel('$scratchdir/$dataname', '$scratchdir/$envname', '$scratchdir/$savename/', $nStarts, $SLURM_ARRAY_TASK_ID, $fixedParams); exit;"

	mv "$scratchdir/$savename/$outputname" "$homedir/$savepath/$savename/$outputname"
fi