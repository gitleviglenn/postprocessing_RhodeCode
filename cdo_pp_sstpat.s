#!/usr/bin/env bash

# script to process data files from am4 exps output using cdo commands
#
# object: -select the radiative variables to exmine toa fluxes
#         -compute the CRE for the total, sw, and lw fluxes
#
# one should only need change exp name and odir (for standard experimets)
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
# Note: olr, olr_clr, swup_toa, swup_toa_clr, and swdn_toa are all positive
#
# once we have these for each experiment the feedbacks can be computed as the diff.
#
# note!!  cdo sub file1 file2 outfile results in outfile having the variable name 
# the same as the variable name in file1 regardless of what the variable actually is
#
# use ncrename to fix this.
#
# levi.silvers                                     Feb 2016

echo 'good grief'
# set up var names
exp='AM4OM2F_c96l32_am4g5r11_2000climo'
period='0061-0065'
#exp='c96L32_am4g5r11_2000climo_p2K'
#period='0002-0011'
#exp='c96L32_am4g9_last20yr_warmpatt'
#exp='c96L32_am4g9_1860climo_ctlpreg_sc66_qc_test'
#exp='c96L32_am4g9_1860climo_ctl'
#
#bdir='/archive/Levi.Silvers/awg/ulm_201505_cosp14/'$exp'/gfdl.ncrc2-intel-prod-openmp/pp/atmos/av/annual_5yr/'
#bdir='/archive/Levi.Silvers/awg/ulm_201505/'$exp'/gfdl.ncrc3-intel-prod-openmp/pp/atmos/av/annual_10yr/'
#bdir='/archive/Ming.Zhao/awglg/ulm/'$exp'/gfdl.ncrc2-intel-prod-openmp/pp/atmos/av/annual_10yr/'
bdir='/archive/Ming.Zhao/awglg/ulm/'$exp'/gfdl.ncrc2-intel-prod-openmp/pp/atmos/av/annual_5yr/'
#bdir='/archive/Ming.Zhao/awglg/ulm/c96L32_am4g5r11_2000climo/gfdl.ncrc2-intel-prod-openmp/pp/atmos/av/annual_5yr/'
odir='/archive/Levi.Silvers/sstpatt/am4_1pc/'
mkdir $odir
filen='atmos.'$period'.ann.nc'
#
echo 'base directory is' $bdir
echo 'output directory is' $odir
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
varname5='t_surf'

cdo infov ${filen}> output

echo 'selecting variables'
cdo selvar,${varname} ${filen} ${odir}atmos_${exp}_${varname}_${period}.nc
cdo selvar,${varname1} ${filen} ${odir}atmos_${exp}_${varname1}_${period}.nc
cdo selvar,${varname2} ${filen} ${odir}atmos_${exp}_${varname2}_${period}.nc
cdo selvar,${varname3} ${filen} ${odir}atmos_${exp}_${varname3}_${period}.nc
cdo selvar,${varname4} ${filen} ${odir}atmos_${exp}_${varname4}_${period}.nc
cdo selvar,${varname5} ${filen} ${odir}atmos_${exp}_${varname5}_${period}.nc
ls -ltr

echo 'computing toa radiative fluxes'
# TOA radiative fluxes: 
# toaflux = swdn_toa - olr - swup_toa
cdo sub ${odir}atmos_${exp}_${varname1}_${period}.nc ${odir}atmos_${exp}_${varname2}_${period}.nc ${odir}atmos_${exp}_toatemp_${period}.nc
cdo sub ${odir}atmos_${exp}_toatemp_${period}.nc ${odir}atmos_${exp}_${varname}_${period}.nc ${odir}atmos_${exp}_toaflux_${period}.nc
# swdn_toa
ncrename -v swdn_toa,toaflux ${odir}atmos_${exp}_toaflux_${period}.nc 

# and clear sky toa 
# swdn_toa - olr_clr - swup_toa_clr 
cdo sub ${odir}atmos_${exp}_${varname1}_${period}.nc ${odir}atmos_${exp}_${varname4}_${period}.nc ${odir}atmos_${exp}_toatemp_clr_${period}.nc
cdo sub ${odir}atmos_${exp}_toatemp_clr_${period}.nc ${odir}atmos_${exp}_${varname3}_${period}.nc ${odir}atmos_${exp}_toaflux_clr_${period}.nc

rm ${odir}atmos_${exp}_toatemp_${period}.nc
rm ${odir}atmos_${exp}_toatemp_clr_${period}.nc

ncrename -v swdn_toa,toaflux_clr ${odir}atmos_${exp}_toaflux_clr_${period}.nc 

# compute CRE
# olr_cre     = olr_clr - olr
# sw_cre      = swup_toa_clr - swup_toa
# toaflux_cre = olr_cre + sw_cre
echo 'computing CRE'
cdo sub ${odir}atmos_${exp}_${varname4}_${period}.nc ${odir}atmos_${exp}_${varname2}_${period}.nc ${odir}atmos_${exp}_olr_CRE_${period}.nc
ncrename -v olr_clr,olr_cre ${odir}atmos_${exp}_olr_CRE_${period}.nc 
#
cdo sub ${odir}atmos_${exp}_${varname3}_${period}.nc ${odir}atmos_${exp}_${varname}_${period}.nc ${odir}atmos_${exp}_sw_CRE_${period}.nc
ncrename -v swup_toa_clr,sw_cre ${odir}atmos_${exp}_sw_CRE_${period}.nc 
#alternate way of computing cre that should work, but i had a problem
#cdo sub ${odir}atmos_${exp}_toaflux_clr.nc ${odir}atmos_${exp}_toaflux.nc ${odir}atmos_${exp}_toaflux_CRE.nc
cdo add ${odir}atmos_${exp}_olr_CRE_${period}.nc ${odir}atmos_${exp}_sw_CRE_${period}.nc ${odir}atmos_${exp}_toaflux_CRE_${period}.nc
ncrename -v olr_cre,toaflux_cre ${odir}atmos_${exp}_toaflux_CRE_${period}.nc 

echo 'finished'
