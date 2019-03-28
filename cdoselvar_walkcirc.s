#! /bin/bash

##dir='/archive/Levi.Silvers/doubly_periodic/testing_20181203/bronx-13/c8x160L33_am4p0_25km_wlkr_ent0p9/gfdl.ncrc4-intel-prod-openmp/history'
##ls ${dir}

##dirlist='/archive/Levi.Silvers/doubly_periodic/testing_20181203/bronx-13/c8x160L33_am4p0_25km_wlkr_ent0p9/gfdl.ncrc4-intel-prod-openmp/history,/archive/Levi.Silvers/doubly_periodic/testing_20181203/bronx-13/c8x160L33_am4p0_25km_wlkr_ent0p9_noconv_lwoff/gfdl.ncrc4-intel-prod-openmp/history,/archive/Levi.Silvers/doubly_periodic/testing_20181203/bronx-13/c8x160L33_am4p0_25km_wlkr_ent0p9_lwoff/gfdl.ncrc4-intel-prod-openmp/history'
path2exp="/archive/Levi.Silvers/doubly_periodic/testing_20181203/bronx-13/"
cd $path2exp
ls
gridspace="100km"
baseexpn="c8x40L33_am4p0_${gridspace}_wlkr_ent0p9"
expn=("${baseexpn}" "${baseexpn}_lwoff" "${baseexpn}_noconv" "${baseexpn}_noconv_lwoff")
for i in ${expn[@]}; do
echo $i
cd $i
pwd
p2his="gfdl.ncrc4-intel-prod-openmp/history/"
cd $p2his
##ls -l *_daily.nc
blueface=("1979" "1980" "1981" "1982" "1983")
for t in ${blueface[@]}; do
cdo selvar,w500,precip,prec_ls,prec_conv,olr,u200,u850,v200,v850 ${t}0101.atmos_daily.nc ${t}_tmp.nc
##echo ${t}0101.atmos_daily.nc ${t}_tmp.nc
done
cdo copy 1979_tmp.nc 1980_tmp.nc 1981_tmp.nc 1982_tmp.nc 1983_tmp.nc 1979th1983_daily.nc
rm copy 19*_tmp.nc
pwd
cd $path2exp
pwd
done
##dir1="/archive/Levi.Silvers/doubly_periodic/testing_20181203/bronx-13/c8x160L33_am4p0_25km_wlkr_ent0p9/gfdl.ncrc4-intel-prod-openmp/history" "/archive/Levi.Silvers/doubly_periodic/testing_20181203/bronx-13/c8x160L33_am4p0_25km_wlkr_ent0p9_noconv_lwoff/gfdl.ncrc4-intel-prod-openmp/history" "/archive/Levi.Silvers/doubly_periodic/testing_20181203/bronx-13/c8x160L33_am4p0_25km_wlkr_ent0p9_lwoff/gfdl.ncrc4-intel-prod-openmp/history")

##echo $dirlist

##for i in ${!dirlist[@]}; do
##  ls $i 
##  echo $i
##done
