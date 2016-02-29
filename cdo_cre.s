#!/usr/bin/env bash

# script to process data files from cosp output using cdo commands
# object: -select the radiative variables to exmine toa fluxes
#         -compute the CRE for the total, sw, and lw fluxes
#
# compute the feedbacks of the radiative fields
#
# levi.silvers                                     Feb 2016

echo 'good grief'

# set up var names
expbase='c96L32_am4g7_1860climo'
exp1='c96L32_am4g7_1860climo_ctlp4k_t4'
exp2='c96L32_am4g7_1860climo_ctl_t4'
bdir='/archive/Levi.Silvers/tempdir'
odir='/archive/Levi.Silvers/tempdir/'
#filen='atmos.0002-0006.ann.nc'
echo 'base directory is' $bdir
echo 'changing to base directory'
cd $bdir
pwd 
echo 'contents in base directory are: ' $ls  
ls

#Variables=${Variables:='swup_toa,swdn_toa,olr,swup_toa_clr,olr_clr'}
#list='swup_toa,swdn_toa,olr,swup_toa_clr,olr_clr'
#varname='swup_toa'
#varname1='swdn_toa'
#varname2='olr'
#varname3='swup_toa_clr'
#varname4='olr_clr'

#echo 'selecting variables'
#cdo selvar,${varname} ${filen} ${odir}atmos_${exp}_${varname}.nc
#cdo selvar,${varname1} ${filen} ${odir}atmos_${exp}_${varname1}.nc
#cdo selvar,${varname2} ${filen} ${odir}atmos_${exp}_${varname2}.nc
#cdo selvar,${varname3} ${filen} ${odir}atmos_${exp}_${varname3}.nc
#cdo selvar,${varname4} ${filen} ${odir}atmos_${exp}_${varname4}.nc
#ls -ltr

echo 'computing toa feedback'
# TOA radiative fluxes: 
cdo sub ${odir}atmos_${exp1}_toaflux.nc ${odir}atmos_${exp2}_toaflux.nc ${odir}atmos_${expbase}_toaflux_fdbk.nc

# compute CRE
echo 'computing CRE feedback'
#nettoa CRE should be nettoa_clr-nettoa
cdo sub ${odir}atmos_${exp1}_toaflux_clr.nc ${odir}atmos_${exp2}_toaflux.nc ${odir}atmos_${expbase}_nettoa_CRE_fdbk.nc
cdo sub ${odir}atmos_${exp1}_olr_clr.nc ${odir}atmos_${exp2}_olr.nc ${odir}atmos_${expbase}_olr_CRE_fdbk.nc
cdo sub ${odir}atmos_${exp1}_swup_toa_clr.nc ${odir}atmos_${exp2}_swup_toa.nc ${odir}atmos_${expbase}_sw_CRE_fdbk.nc

# compute clear sky feedbacks
echo 'computing lw clear sky feedback'
cdo sub ${odir}atmos_${exp1}_olr_clr.nc ${odir}atmos_${exp2}_olr_clr.nc ${odir}atmos_${expbase}_olrclr_fdbk.nc
echo 'computing sw clear sky feedback'
cdo sub ${odir}atmos_${exp1}_swup_toa_clr.nc ${odir}atmos_${exp2}_swup_toa_clr.nc ${odir}atmos_${expbase}_swclr_fdbk.nc

echo 'finished'
