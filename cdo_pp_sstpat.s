#!/usr/bin/env bash

# script to process data files from cosp output using cdo commands
# object: -merge all months into one file
#         -add all clouds within a certain vertical level
#         -add one or more values of optical depth (tau) so that 
#          we can plot tau > 0.3, for example
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



echo 'changing back to /archive/Levi.Silvers/tempdir'
cd /archive/Levi.Silvers/tempdir

