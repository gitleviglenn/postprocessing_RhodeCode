#! /bin/bash 
##

#/archive/Ming.Zhao/awg/warsaw/c96L33_am4p0_longamip_1850rad/gfdl.ncrc3-intel-prod-openmp/history/

tpath=/archive/Ming.Zhao/awg/warsaw/
expn=c96L33_am4p0_longamip_1850rad
#set ppd = gfdl.ncrc2-intel-prod/pp/atmos/ts/monthly/1yr
#set ppd = /archive/ccsp/ipcc_ar4/CM2.1U_Control-1860_D4/pp/atmos/ts/monthly/5yr
ppd=$tpath$expn/gfdl.ncrc3-intel-prod-openmp/pp/atmos/ts/monthly/5yr
yr1=187001
yr2=201412

ls ${expn}
cd /net2/Levi.Silvers/data/amip_long/$expn/ts_all

for varnam in evap high_cld_amt ice_mask IWP low_cld_amt lwdn_sfc_clr lwdn_sfc LWP lwup_sfc_clr lwup_sfc mid_cld_amt olr_clr olr prec_conv precip prec_ls rh_ref shflx snow_conv snow_ls swdn_sfc_clr swdn_sfc swdn_toa_clr swdn_toa swup_sfc_clr swup_sfc swup_toa_clr swup_toa tau_x tau_y temp t_ref t_surf wind_ref WVP 
do 
# ls $varnam
# ncrcat ${tpath}/${expn}/${ppd}/*.${varnam}.nc ${varnam}.atmos.${yr1}-${yr2}.all.nc
 ncrcat ${ppd}/*.${varnam}.nc atmos.${yr1}-${yr2}.${varnam}.nc
done

