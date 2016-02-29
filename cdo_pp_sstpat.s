#!/usr/bin/env bash

# script to process data files from cosp output using cdo commands
# object: -select the radiative variables to exmine toa fluxes
#         -compute the CRE for the total, sw, and lw fluxes
#
# to generate something like Fig. 4 from Andrews et al 2015 we need to compute
# the feedback of the radiative fluxes, so we need first
# 1. Net TOA flux
#       need swdn_toa, swup_toa, olr
# 2. Net CRE (clear sky net toa - total sky toa) fluxes
#       need swup_toa_clr, olr_clr      
# 3. olr_clr
# 4. swup_toa_clr
# 5. olr CRE
# 6. swup_toa CRE
#
# once we have these for each experiment the feedbacks can be computed as the diff.
#
# levi.silvers                                     Feb 2016

echo 'good grief'

# set up var names
exp='c96L32_am4g7_1860climo_ctlp4k_t4'
bdir='/archive/Levi.Silvers/awg/ulm_201505_cosp14/'$exp'/gfdl.ncrc2-intel-prod-openmp/pp/atmos/av/annual_5yr/'
odir='/archive/Levi.Silvers/tempdir/'
filen='atmos.0002-0006.ann.nc'
echo 'base directory is' $bdir
echo 'changing to base directory'
cd $bdir
pwd 
echo 'contents in base directory are: ' $ls  
ls

#Variables=${Variables:='swup_toa,swdn_toa,olr,swup_toa_clr,olr_clr'}
#list='swup_toa,swdn_toa,olr,swup_toa_clr,olr_clr'
varname='swup_toa'
varname1='swdn_toa'
varname2='olr'
varname3='swup_toa_clr'
varname4='olr_clr'

cdo infov ${filen}> output

cdo selvar,${varname} ${filen} ${odir}atmos_${exp}_${varname}.nc
cdo selvar,${varname1} ${filen} ${odir}atmos_${exp}_${varname1}.nc
cdo selvar,${varname2} ${filen} ${odir}atmos_${exp}_${varname2}.nc
cdo selvar,${varname3} ${filen} ${odir}atmos_${exp}_${varname3}.nc
cdo selvar,${varname4} ${filen} ${odir}atmos_${exp}_${varname4}.nc
ls -ltr

# TOA radiative fluxes: 
cdo sub ${odir}atmos_${exp}_${varname1}.nc ${odir}atmos_${exp}_${varname2}.nc ${odir}atmos_${exp}_toatemp.nc
cdo sub ${odir}atmos_${exp}_toatemp.nc ${odir}atmos_${exp}_${varname}.nc ${odir}atmos_${exp}_toaflux.nc

rm ${odir}atmos_${exp}_toatemp.nc

# compute CRE
cdo sub ${odir}atmos_${exp}_${varname4}.nc ${odir}atmos_${exp}_${varname2}.nc ${odir}atmos_${exp}_olr_CRE.nc
cdo sub ${odir}atmos_${exp}_${varname3}.nc ${odir}atmos_${exp}_${varname}.nc ${odir}atmos_${exp}_sw_CRE.nc

echo 'finished'
