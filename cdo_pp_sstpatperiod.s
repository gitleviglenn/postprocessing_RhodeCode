#!/usr/bin/env bash

# script to process data files from cosp output using cdo commands
# object: -select the radiative variables to exmine toa fluxes
#         -compute the CRE for the total, sw, and lw fluxes
#
# to generate something like Fig. 4 from Andrews et al 2015 we need to compute
# the feedback of the radiative fluxes, so we need 
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

# set up dir and file names
# output from one of miz's experiments:
exp='c96L32_am4g9_last20yr_warmpatt'
fbase='atmos_last20yr_warmpatt'
#bdir='/archive/Ming.Zhao/awgom2/ulm_201505/AM4OM2F_c96l32_am4g9_1860climo_hist0/ts_all/'
bdir='/archive/Levi.Silvers/awg/ulm_201505/'$exp'/gfdl.ncrc3-intel-prod-openmp/pp/atmos/av/annual_10yr'
odir='/archive/Levi.Silvers/sstpatt/am4g9_10yr/'
mkdir $odir
# output from one of my experiments:
#exp='c96L32_am4g9_1860climo_ctlpreg_t4'
##bdir='/archive/Levi.Silvers/awg/ulm_201505_cosp14/'$exp'/gfdl.ncrc2-intel-prod-openmp/pp/atmos/av/annual_5yr/'
#bdir='/archive/Levi.Silvers/awg/ulm_201505/'$exp'/gfdl.ncrc3-intel-prod-openmp/pp/atmos/av/annual_5yr/'
#odir='/archive/Levi.Silvers/sstpatt/am4g9/'
#filen='atmos.0002-0006.ann.nc'

echo 'base directory is' $bdir
echo 'output directory is' $odir
echo 'changing to output directory'
#cd $bdir
cd $odir
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

# for coupled experiments: 
#exp='atmos.186101-200512'
#filen=${exp}${varname}'.nc'
#filen=${exp}${varname1}'.nc'
#filen=${exp}${varname2}'.nc'
#filen=${exp}${varname3}'.nc'
#filen=${exp}${varname4}'.nc'
#filen=${exp}${varname5}'.nc'

echo 'selecting variables'
filen=${bdir}${fbase}${varname}'.nc'
cdo infov ${filen}> output
cdo selvar,${varname} ${filen} ${odir}atmos_full${exp}_${varname}.nc
filen=${bdir}${fbase}${varname1}'.nc'
cdo selvar,${varname1} ${filen} ${odir}atmos_full${exp}_${varname1}.nc
filen=${bdir}${fbase}${varname2}'.nc'
cdo selvar,${varname2} ${filen} ${odir}atmos_full${exp}_${varname2}.nc
filen=${bdir}${fbase}${varname3}'.nc'
cdo selvar,${varname3} ${filen} ${odir}atmos_full${exp}_${varname3}.nc
filen=${bdir}${fbase}${varname4}'.nc'
cdo selvar,${varname4} ${filen} ${odir}atmos_full${exp}_${varname4}.nc
filen=${bdir}${fbase}${varname5}'.nc'
cdo selvar,${varname5} ${filen} ${odir}atmos_full${exp}_${varname5}.nc

#decade=3

echo 'selecting years'
cdo selyear,1985,1986,1987,1988,1989,1990,1991,1992,1993,1994,1995,1996,1997,1998,1999,2000,2001,2002,2003,2004,2005 ${odir}atmos_full${exp}_${varname}.nc ${odir}atmos_timsel${exp}_${varname}.nc
#cdo selyear,19${decade}0,19${decade}1,19${decade}2,19${decade}3,19${decade}4,19${decade}5,19${decade}6,19${decade}7,19${decade}8,19${decade}9 ${odir}atmos_full${exp}_${varname}.nc ${odir}atmos_timsel${exp}_${varname}.nc
cdo timmean ${odir}atmos_timsel${exp}_${varname}.nc ${odir}atmos_${exp}_${varname}.nc

cdo selyear,1985,1986,1987,1988,1989,1990,1991,1992,1993,1994,1995,1996,1997,1998,1999,2000,2001,2002,2003,2004,2005 ${odir}atmos_full${exp}_${varname1}.nc ${odir}atmos_timsel${exp}_${varname1}.nc
#cdo selyear,19${decade}0,19${decade}1,19${decade}2,19${decade}3,19${decade}4,19${decade}5,19${decade}6,19${decade}7,19${decade}8,19${decade}9 ${odir}atmos_full${exp}_${varname1}.nc ${odir}atmos_timsel${exp}_${varname1}.nc
cdo timmean ${odir}atmos_timsel${exp}_${varname1}.nc ${odir}atmos_${exp}_${varname1}.nc

#echo ' selecting years '19${decade}0,19${decade}1,19${decade}2,19${decade}3,19${decade}4,19${decade}5,19${decade}6,19${decade}7,19${decade}8,19${decade}9'

cdo selyear,1985,1986,1987,1988,1989,1990,1991,1992,1993,1994,1995,1996,1997,1998,1999,2000,2001,2002,2003,2004,2005 ${odir}atmos_full${exp}_${varname2}.nc ${odir}atmos_timsel${exp}_${varname2}.nc
#cdo selyear,19${decade}0,19${decade}1,19${decade}2,19${decade}3,19${decade}4,19${decade}5,19${decade}6,19${decade}7,19${decade}8,19${decade}9 ${odir}atmos_full${exp}_${varname2}.nc ${odir}atmos_timsel${exp}_${varname2}.nc
cdo timmean ${odir}atmos_timsel${exp}_${varname2}.nc ${odir}atmos_${exp}_${varname2}.nc

cdo selyear,1985,1986,1987,1988,1989,1990,1991,1992,1993,1994,1995,1996,1997,1998,1999,2000,2001,2002,2003,2004,2005 ${odir}atmos_full${exp}_${varname3}.nc ${odir}atmos_timsel${exp}_${varname3}.nc
#cdo selyear,19${decade}0,19${decade}1,19${decade}2,19${decade}3,19${decade}4,19${decade}5,19${decade}6,19${decade}7,19${decade}8,19${decade}9 ${odir}atmos_full${exp}_${varname3}.nc ${odir}atmos_timsel${exp}_${varname3}.nc
cdo timmean ${odir}atmos_timsel${exp}_${varname3}.nc ${odir}atmos_${exp}_${varname3}.nc

cdo selyear,1985,1986,1987,1988,1989,1990,1991,1992,1993,1994,1995,1996,1997,1998,1999,2000,2001,2002,2003,2004,2005 ${odir}atmos_full${exp}_${varname4}.nc ${odir}atmos_timsel${exp}_${varname4}.nc
#cdo selyear,19${decade}0,19${decade}1,19${decade}2,19${decade}3,19${decade}4,19${decade}5,19${decade}6,19${decade}7,19${decade}8,19${decade}9 ${odir}atmos_full${exp}_${varname4}.nc ${odir}atmos_timsel${exp}_${varname4}.nc
cdo timmean ${odir}atmos_timsel${exp}_${varname4}.nc ${odir}atmos_${exp}_${varname4}.nc

cdo selyear,1985,1986,1987,1988,1989,1990,1991,1992,1993,1994,1995,1996,1997,1998,1999,2000,2001,2002,2003,2004,2005 ${odir}atmos_full${exp}_${varname5}.nc ${odir}atmos_timsel${exp}_${varname5}.nc
#cdo selyear,19${decade}0,19${decade}1,19${decade}2,19${decade}3,19${decade}4,19${decade}5,19${decade}6,19${decade}7,19${decade}8,19${decade}9 ${odir}atmos_full${exp}_${varname5}.nc ${odir}atmos_timsel${exp}_${varname5}.nc
cdo timmean ${odir}atmos_timsel${exp}_${varname5}.nc ${odir}atmos_${exp}_${varname5}.nc

# clean up a bit
echo 'deleting extra files...'
rm -rf *full*nc *timsel*nc

## for use with non coupled experiments... 
#cdo selvar,${varname} ${filen} ${odir}atmos_${exp}_${varname}.nc
#cdo selvar,${varname} ${filen} ${odir}atmos_${exp}_${varname1}.nc
#cdo selvar,${varname} ${filen} ${odir}atmos_${exp}_${varname2}.nc
#cdo selvar,${varname} ${filen} ${odir}atmos_${exp}_${varname3}.nc
#cdo selvar,${varname} ${filen} ${odir}atmos_${exp}_${varname4}.nc
#cdo selvar,${varname} ${filen} ${odir}atmos_${exp}_${varname5}.nc

ls -ltr

echo 'computing toa radiative fluxes'
# TOA radiative fluxes: 
cdo sub ${odir}atmos_${exp}_${varname1}.nc ${odir}atmos_${exp}_${varname2}.nc ${odir}atmos_${exp}_toatemp.nc
cdo sub ${odir}atmos_${exp}_toatemp.nc ${odir}atmos_${exp}_${varname}.nc ${odir}atmos_${exp}_toaflux.nc
# and clear sky toa 
cdo sub ${odir}atmos_${exp}_${varname1}.nc ${odir}atmos_${exp}_${varname4}.nc ${odir}atmos_${exp}_toatemp_clr.nc
cdo sub ${odir}atmos_${exp}_toatemp_clr.nc ${odir}atmos_${exp}_${varname3}.nc ${odir}atmos_${exp}_toaflux_clr.nc

rm ${odir}atmos_${exp}_toatemp.nc
rm ${odir}atmos_${exp}_toatemp_clr.nc

# compute CRE
echo 'computing CRE'
cdo sub ${odir}atmos_${exp}_${varname4}.nc ${odir}atmos_${exp}_${varname2}.nc ${odir}atmos_${exp}_olr_CRE.nc
cdo sub ${odir}atmos_${exp}_${varname3}.nc ${odir}atmos_${exp}_${varname}.nc ${odir}atmos_${exp}_sw_CRE.nc
#cdo sub ${odir}atmos_${exp}_toaflux_clr.nc ${odir}atmos_${exp}_toaflux.nc ${odir}atmos_${exp}_toaflux_CREsub.nc
cdo add ${odir}atmos_${exp}_olr_CRE.nc ${odir}atmos_${exp}_sw_CRE.nc ${odir}atmos_${exp}_toaflux_CRE.nc

echo 'finished'
