#!/usr/bin/env bash

# script to process data files from cosp output using cdo commands
# object: -select the radiative variables to exmine toa fluxes
#         -compute the CRE for the total, sw, and lw fluxes
#
# compute the feedbacks of the radiative fields
#
# generally this script will use the output generated from the script
# cdo_pp_sstpat.s which selects the variables from output files and 
# computes the CRE and radiative fluxes at TOA.  For the current script
# to work teh cdo_pp_sstpat.s script will need to be run on the 
# output from both exp1 and exp2.
#
# levi.silvers                                     Feb 2016

echo 'good grief'

# set up var names
expbase='c96L32_am4g9_1860climo'
exp1=${expbase}'_ctlpreg'
exp2=${expbase}'_ctl'
label='preg_fdbk'
bdir='/archive/Levi.Silvers/sstpatt'
odir='/archive/Levi.Silvers/sstpatt/'
#filen='atmos.0002-0006.ann.nc'
echo 'base directory is' $bdir
echo 'changing to base directory'
cd $bdir
pwd 
echo 'contents in base directory are: ' $ls  
ls

echo 'computing toa feedback'
# TOA radiative fluxes: 
cdo sub ${odir}atmos_${exp1}_toaflux.nc ${odir}atmos_${exp2}_toaflux.nc ${odir}atmos_${expbase}_toaflux_${label}.nc

# compute CRE
echo 'computing CRE feedback'
#nettoa CRE should be nettoa_clr-nettoa
cdo sub ${odir}atmos_${exp1}_toaflux_clr.nc ${odir}atmos_${exp2}_toaflux.nc ${odir}atmos_${expbase}_nettoa_CRE_${label}.nc
cdo sub ${odir}atmos_${exp1}_olr_clr.nc ${odir}atmos_${exp2}_olr.nc ${odir}atmos_${expbase}_olr_CRE_${label}.nc
cdo sub ${odir}atmos_${exp1}_swup_toa_clr.nc ${odir}atmos_${exp2}_swup_toa.nc ${odir}atmos_${expbase}_sw_CRE_${label}.nc

# compute clear sky feedbacks
echo 'computing lw clear sky feedback'
cdo sub ${odir}atmos_${exp1}_olr_clr.nc ${odir}atmos_${exp2}_olr_clr.nc ${odir}atmos_${expbase}_olrclr_${label}.nc
echo 'computing sw clear sky feedback'
cdo sub ${odir}atmos_${exp1}_swup_toa_clr.nc ${odir}atmos_${exp2}_swup_toa_clr.nc ${odir}atmos_${expbase}_swclr_${label}.nc

echo 'finished'
