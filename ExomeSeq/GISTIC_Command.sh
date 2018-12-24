#!/bin/sh
# by Qi Zhao <zhaoqi@sysucc.orgcn>
##################################
OUTDIR=$1
INPUT_SEG=$2
REF_MAT=$3


## set MCR environment and launch GISTIC executable

## NOTE: change the line below if you have installed the Matlab MCR in an alternative location
MCR_ROOT=/disk/soft/GISTIC_2_0_23/MATLAB_Compiler_Runtime
MCR_VER=v83

echo Setting Matlab MCR root to $MCR_ROOT

## set up environment variables
LD_LIBRARY_PATH=$MCR_ROOT/$MCR_VER/runtime/glnxa64:$LD_LIBRARY_PATH
LD_LIBRARY_PATH=$MCR_ROOT/$MCR_VER/bin/glnxa64:$LD_LIBRARY_PATH
LD_LIBRARY_PATH=$MCR_ROOT/$MCR_VER/sys/os/glnxa64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH
XAPPLRESDIR=$MCR_ROOT/$MCR_VER/MATLAB_Component_Runtime/v83/X11/app-defaults
export XAPPLRESDIR


# run command 
gp_gistic2_from_seg -b $OUTDIR -seg $INPUT_SEG -refgene $REF_MAT -genegistic 1 -broad 1 -armpeel 1 -savegene 1 -twoside 1 
