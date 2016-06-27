#!/usr/bin/env bash

# script to process data files from cosp output using cdo commands
# object: -select the radiative variables to exmine toa fluxes
#         -compute the CRE for the total, sw, and lw fluxes
#
# compute the feedbacks of the radiative fields
#
# cdo sub field1 feidl2 = field1 - field2
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
#expbase='c96L32_am4g9'
#expbase='c96L32_am4g5r11'
#period='0007-0011'
#bdir='/archive/Levi.Silvers/sstpatt/am4g5r11_cess_test'
expbase='AM4OM2F_c96l32_am4g5r11'
period='0061-0065'
exp1=${expbase}'_2000climo_1pct'
#exp1=${expbase}'_1860climo_ctlpreg_4co2'
#exp1=${expbase}'_2000climo_p2K'
#exp2=${expbase}'_1860climo_ctl'
exp2=${expbase}'_2000climo'
label='fdbk_am4g5r11_1pctmctl'
bdir='/archive/Levi.Silvers/sstpatt/am4_1pc'
odir='/archive/Levi.Silvers/sstpatt/am4_1pc/'
echo 'base directory is' $bdir
echo 'changing to base directory'
cd $bdir
pwd 
echo 'contents in base directory are: ' $ls  
ls

echo 'computing toa feedback'
# TOA radiative fluxes: 
cdo sub ${odir}atmos_${exp1}_toaflux_${period}.nc ${odir}atmos_${exp2}_toaflux_${period}.nc ${odir}atmos_${expbase}_toaflux_${period}_${label}.nc

# compute CRE
echo 'computing CRE feedback'
#nettoa CRE should be nettoa_clr-nettoa
#nettoa CRE should be lw_cre + sw_cre
cdo sub ${odir}atmos_${exp1}_toaflux_CRE_${period}.nc ${odir}atmos_${exp2}_toaflux_CRE_${period}.nc ${odir}atmos_${expbase}_nettoa_CRE_${period}_${label}.nc
cdo sub ${odir}atmos_${exp1}_olr_CRE_${period}.nc ${odir}atmos_${exp2}_olr_CRE_${period}.nc ${odir}atmos_${expbase}_olr_CRE_${period}_${label}.nc
cdo sub ${odir}atmos_${exp1}_sw_CRE_${period}.nc ${odir}atmos_${exp2}_sw_CRE_${period}.nc ${odir}atmos_${expbase}_sw_CRE_${period}_${label}.nc

# compute clear sky feedbacks
echo 'computing lw clear sky feedback'
cdo sub ${odir}atmos_${exp1}_olr_clr_${period}.nc ${odir}atmos_${exp2}_olr_clr_${period}.nc ${odir}atmos_${expbase}_olrclr_${period}_${label}.nc
echo 'computing sw clear sky feedback'
cdo sub ${odir}atmos_${exp1}_swup_toa_clr_${period}.nc ${odir}atmos_${exp2}_swup_toa_clr_${period}.nc ${odir}atmos_${expbase}_swclr_${period}_${label}.nc

echo 'finished'
