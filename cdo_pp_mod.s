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
# this can be used together with the ncl script glb_cc.ncl to produce 
# figures
# 
# does git work? yes it does
#
# levi.silvers                                     Oct 2015

echo 'good grief'
#cdo infov atmos_month_misr.0002-0006.08.nc 
#echo 'file1 is' atmos_month_misr.0002-0006.01.nc

# set up var names
bname='atmos_month_misr'
exp='am4g9'
years='.0002-0011'
#years='.0002-0006'
bdir='/archive/Levi.Silvers/awg/ulm_201505/c96L32_'$exp'_2000climo_cosp_isccp/gfdl.ncrc3-intel-prod-openmp/pp/atmos_month_misr/av/monthly_10yr/'
#bdir='/archive/Levi.Silvers/awg/ulm_201505_cosp14/c96L32_'$exp'_2000climo_cosp/gfdl.ncrc2-intel-prod-openmp/pp/atmos_month_misr/av/monthly_5yr/'
#wdir='/work/Levi.Silvers/moddata/misr_pp_'$exp
wdir='/work/Levi.Silvers/moddata/testgarbage'
echo 'working directory is' $wdir

cd $wdir 

echo 'merging time into one file:' 
 #cdo mergetime ${bname}.0002-0006*nc ${bname}_mtime.nc
echo 'mergetime on files' $bdir${bname}${years}*.nc 
 cdo mergetime $bdir${bname}${years}*nc ${bname}_mtime.nc

echo 'grabbing the desired height elves'
lev='_under3km'
 cdo selname,misr_1,misr_2,misr_3,misr_4,misr_5,misr_6,misr_7 ${bname}_mtime.nc ${bname}_mtime${lev}.nc

echo 'split the tau levels into separate files'
 cdo splitlevel ${bname}_mtime${lev}.nc ${bname}_mtime${lev}_tau

#the tau levels for misr are 0.15,0.8,2.45,6.5,16.2,41.5,100.
echo 'adding the desired tau levels'
#cdo add ${bname}_mtime${lev}_tau0000.8.nc2 ${bname}_mtime${lev}_tau000.15.nc2 ${bname}_mtime${lev}_tau_ab.nc2
cdo add ${bname}_mtime${lev}_tau0000.8.nc2 ${bname}_mtime${lev}_tau000.15.nc2 ${bname}temp1.nc
cdo add ${bname}_mtime${lev}_tau002.45.nc2 ${bname}temp1.nc ${bname}temp2.nc
cdo add ${bname}_mtime${lev}_tau0006.5.nc2 ${bname}temp2.nc ${bname}temp3.nc
cdo add ${bname}_mtime${lev}_tau0016.2.nc2 ${bname}temp3.nc ${bname}temp4.nc
cdo add ${bname}_mtime${lev}_tau0041.5.nc2 ${bname}temp4.nc ${bname}temp5.nc
cdo add ${bname}_mtime${lev}_tau000100.nc2 ${bname}temp5.nc ${bname}temp6.nc

#take the time average 
echo 'taking the time average: in most cases this results in an annual mean value'
cdo timmean ${bname}temp6.nc ${bname}_mtime${lev}_tau_mn.nc2

#split and add the misr levels
echo 'splitting single file into the misr-height levels'
cdo splitparam,misr_1,misr_2,misr_3,misr_4,misr_5,misr_6,misr_7 ${bname}_mtime${lev}_tau_mn.nc2 ${bname}_mtime${lev}_tau_mn_

echo 'adding the misr-height levels together'
cdo add ${bname}_mtime${lev}_tau_mn_-1.nc2 ${bname}_mtime${lev}_tau_mn_-2.nc2 ${bname}_mtime${lev}_tau_mn_ab.nc2 
cdo add ${bname}_mtime${lev}_tau_mn_-3.nc2 ${bname}_mtime${lev}_tau_mn_ab.nc2 ${bname}_mtime${lev}_tau_mn_bc.nc2 
cdo add ${bname}_mtime${lev}_tau_mn_-4.nc2 ${bname}_mtime${lev}_tau_mn_bc.nc2 ${bname}_mtime${lev}_tau_mn_cd.nc2 
cdo add ${bname}_mtime${lev}_tau_mn_-5.nc2 ${bname}_mtime${lev}_tau_mn_cd.nc2 ${bname}_mtime${lev}_tau_mn_de.nc2 
cdo add ${bname}_mtime${lev}_tau_mn_-6.nc2 ${bname}_mtime${lev}_tau_mn_de.nc2 ${bname}_mtime${lev}_tau_mn_ef.nc2 
cdo add ${bname}_mtime${lev}_tau_mn_-7.nc2 ${bname}_mtime${lev}_tau_mn_ef.nc2 ${bname}_mtime${lev}_tau_mn_final.nc2 

echo 'changing back to home/scripts directory'
cd ~/scripts

