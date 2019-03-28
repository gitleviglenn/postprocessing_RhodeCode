#! /bin/bash

##dir='/archive/Levi.Silvers/doubly_periodic/testing_20181203/bronx-13/c8x160L33_am4p0_25km_wlkr_ent0p9/gfdl.ncrc4-intel-prod-openmp/history'
##ls ${dir}

##dirlist='/archive/Levi.Silvers/doubly_periodic/testing_20181203/bronx-13/c8x160L33_am4p0_25km_wlkr_ent0p9/gfdl.ncrc4-intel-prod-openmp/history,/archive/Levi.Silvers/doubly_periodic/testing_20181203/bronx-13/c8x160L33_am4p0_25km_wlkr_ent0p9_noconv_lwoff/gfdl.ncrc4-intel-prod-openmp/history,/archive/Levi.Silvers/doubly_periodic/testing_20181203/bronx-13/c8x160L33_am4p0_25km_wlkr_ent0p9_lwoff/gfdl.ncrc4-intel-prod-openmp/history'
path2exp="/archive/Levi.Silvers/doubly_periodic/testing_20181203/bronx-13/"
cd $path2exp
ls
gridspace="2km"
baseexpn="c50x2000L33_am4p0_${gridspace}_wlkr_4K"
expn=("${baseexpn}" "${baseexpn}_lwoff")
for i in ${expn[@]}; do
echo $i
cd $i
pwd
p2his="gfdl.ncrc4-intel-prod-openmp/history/"
cd $p2his
pwd
monthface=("01" "02" "03" "04" "05" "06")
# the loop below is to process monthly data
for t in ${monthface[@]}; do
cdo selvar,precip,evap,shflx,tdt_ls,tdt_lw,tdt_sw,heat2d_rad,temp,t_surf,ps,ucomp,vcomp,omega,w,cld_amt,tot_liq_amt,tot_ice_amt,rh,pfull,z_full,sphum 1979${t}01.atmos_month.nc ${t}_tmp.nc 
ls 1979${t}01.atmos_month.nc
done
cdo copy 01_tmp.nc 02_tmp.nc 03_tmp.nc 04_tmp.nc 05_tmp.nc 06_tmp.nc 1979_6mn.atmos_month.nc
rm *_tmp.nc
ls
cd $path2exp
done
##for i in ${!dirlist[@]}; do
##  ls $i 
##  echo $i
##done
