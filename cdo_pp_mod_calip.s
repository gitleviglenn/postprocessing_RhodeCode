#!/usr/bin/env bash

# script to process data files from cosp output using cdo commands
# object: -merge all months into one file
#         -add all clouds within a certain vertical level
#         -add one or more values of optical depth (tau) so that 
#          we can plot tau > 0.3, for example
#
# the MISR files originally have fields for each vertical level named
# misr_1 - misr_16 with dimensions of
# misr_1(time,tauindex,lat,lon)
# because tau is originally a dimension, the files need to be split 
# apart with cdo splitlevel.  after that the desired tau levels need
# to be summed up. 
#
# levi.silvers                                     Feb 2016

echo 'good grief'
#cdo infov atmos_month_misr.0002-0006.08.nc 
echo 'file1 is' atmos_month_misr.0002-0006.01.nc

# set up var names
bname='atmos_month_cospx'
exp='am4g7'
bdir='/archive/Levi.Silvers/awg/ulm_201505_cosp14/c96L32_'$exp'_2000climo_cosp_nolat/gfdl.ncrc2-intel-prod-openmp/pp/'$bname'/av/monthly_10yr/'
wdir='/work/Levi.Silvers/moddata/calip_pp_'$exp
echo 'working directory is' $wdir

cd $wdir 

echo 'merging time into one file:' 
echo 'mergetime on files' $bdir${bname}.0002-0011*nc 
 cdo mergetime $bdir${bname}.0002-0011*nc ${bname}_mtime.nc

cdo selvar,tca atmos_month_cospx_mtime.nc atmos_month_cospx_mtime_tca.nc
cdo timmean atmos_month_cospx_mtime_tca.nc atmos_month_cospx_tmn_tca.nc
cdo zonmean atmos_month_cospx_tmn_tca.nc atmos_month_cospx_tzonmn_tca.nc

echo 'changing back to home/scripts directory'
cd ~/scripts

