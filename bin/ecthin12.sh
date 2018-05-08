#!/bin/bash
#靠靠 aaaaaaaaaaaaa
echo $PATH
export Here_PATH=/home/WORK/ecthin
export rawdata_PATH=${Here_PATH}/rawdata
export PATH=$PATH:${Here_PATH}/bin
echo $PATH
#  bbbbbbbbbbbbbbbbbbb
#日期计算
today=`date -d "today"  +%d`
today_mmdd=`date -d "today"  +%m%d`
today_yymmdd=`date -d "today"  +%y%m%d`
today_yyyymmdd=`date -d "today"  +%Y%m%d`
<<<<<<< HEAD
#dddddddddddddddddddddd
echo 今天是：${today}日${today_yyyymmdd}
yesterday=`date -d "yesterday"  +%d`
yesterday_mmdd=`date -d "yesterday"  +%m%d`
yesterday_yymmdd=`date -d "yesterday"  +%y%m%d`
yesterday_yyyymmdd=`date -d "yesterday"  +%Y%m%d`
echo 昨天是：${yesterday}日${yesterday_yyyymmdd}
thedaybefor=`date -d " -2 day"  +%d`
thedaybefor_mmdd=`date -d " -2 day"  +%m%d`
thedaybefor_yymmdd=`date -d " -2 day"  +%y%m%d`
thedaybefor_yyyymmdd=`date -d " -2 day"  +%Y%m%d`
echo 前天是：${thedaybefor}日${thedaybefor_yyyymmdd}

sc='12'
echo ${sc}
if [ "${sc}" = "18" ] || [ "${sc}" = "12" ]
then
mmdd=${yesterday_mmdd}
yyyymmdd=${yesterday_yyyymmdd}
fi

if [ "${sc}" = "00" ] || [ "${sc}" = "06" ]
then
mmdd=${today_mmdd}
yyyymmdd=${today_yyyymmdd}
fi
echo 模式初始日期：${yyyymmdd} ${mmdd}

cd ${rawdata_PATH}

#取当前文件名
current_filename=ECthin_${yyyymmdd}${sc}
rm -f *
rm -f ./.listing
cp ${Here_PATH}/bin/rgbset.gs ${rawdata_PATH}
cp ${Here_PATH}/bin/cbar.gs ${rawdata_PATH}
cp ${Here_PATH}/bin/newdate ${rawdata_PATH}
#0场资料处理
wget -q -nv ftp://getdata:getdata@172.18.73.19//cmacastdata/nafp/ecmf/W_NAFP_C_ECMF_*_P_C1D${mmdd}${sc}00${mmdd}${sc}011.bz2
bunzip2 W_NAFP_C_ECMF_*_P_C1D${mmdd}${sc}00${mmdd}${sc}011.bz2

 if [ ! -f W_NAFP_C_ECMF_*_P_C1D${mmdd}${sc}00${mmdd}${sc}011 ]
 then
    bunzip2 W_NAFP_C_ECMF_*_P_C1D${mmdd}${sc}00${mmdd}${sc}011.bz2
 fi

ls W_NAFP_C_ECMF_*_P_C1D${mmdd}${sc}00${mmdd}${sc}011 | while read line
do
    echo $line
    wgrib -s $line | grep "mb:" | wgrib $line -i -grib -o ${current_filename}_cst.high
    wgrib -s $line | grep ":sfc:" | wgrib $line -i -grib -o ${current_filename}_cst.sfc
    grib2ctl.pl ${current_filename}_cst.high > ${current_filename}_cst.high.ctl
    grib2ctl.pl ${current_filename}_cst.sfc > ${current_filename}_cst.sfc.ctl
    gribmap -i ${current_filename}_cst.high.ctl
    gribmap -i ${current_filename}_cst.sfc.ctl
done
cat > ${current_filename}_cst.high.gs << EOF
'reinit'
'c'
'open ${current_filename}_cst.high.ctl'
'set display color white'
'set map 4 1 10'
'set mpdset cnworld cnriver shanxi shanxi_q'
'set parea 0 11 1 7.7'
'set lon 102 120'
'set lat 33 43'
z.1='850'
z.2='700'
z.3='500'
z.4='200'
j=1
while(j<5)
'set lev 'z.j
'set csmooth on'
*综合图1_'z.j'HPA Relative humidity % wind Temperature
'set grads off'
'set grid off'
*相对湿度
'set gxout shaded'
'run rgbset.gs'
'set clevs 20 30 40 50 60 70 80 90 100'
'set ccols 0 31 32 33 34 35 36 37 38 39'
'd Rprs'
'run cbar.gs'
*风场
'set gxout barb'
'set digsize 0.045'
'set ccolor 9'
'set cthick 5'
'd skip(Uprs,2,2);skip(Vprs,2,2)'
*气温
'set gxout contour'
'set cint 2'
'run rgbset.gs'
'set ccolor 2'
'd Tprs-273.16'
*高度
'set gxout contour'
'set cint 2'
'run rgbset.gs'
'set ccolor 1'
'set cthick 5'
'd GHprs/9.8'
'draw title ECthin 'z.j'H.RH.WIND.T ${mmdd}${sc}'
'draw string 9.0 0.2 ${yyyymmdd}${sc}(CST)'
'printim ECthin_1_H.RH.WIND.T_'z.j'_${yyyymmdd}${sc}_${mmdd}${sc}.gif gif'
*综合图2 'z.j'HPA垂直速度 Vertical velocity [Pa s**-1]
'c'
'set grads off'
'set grid off'
'set gxout shaded'
'run rgbset.gs'
'set clevs -12 -10 -8 -6 -4 -2 0 2 4 6 8 10 12'
'set ccols 49 47 46 45 44 42 41 61 62 63 64 65 67 68 69'
'd Wprs'
'run cbar.gs'
'set gxout contour'
'set cint 2'
'set clab on'
'd Wprs'
'draw title   ECthin 'z.j'HPa Vertical velocity [Pa s**-1] ${mmdd}${sc}'
'draw string 9.0 0.2 ${yyyymmdd}${sc}(CST)'
'printim ECthin_2_Wprs_'z.j'_${yyyymmdd}${sc}_${mmdd}${sc}.gif gif'
*综合图3_'z.j'HPa_STREAM
'c'
'set grads off'
'set grid off'
'run rgbset.gs'
'set clevs 15 30 40 50'
'set ccols 0 72 74 76 78'
'set gxout shaded'
'd mag(Uprs,Vprs)'
'run cbar.gs'
'set ccolor 1'
'set gxout stream'
'd Uprs;Vprs'
'draw title  ECthin 'z.j'HPA STREAM ${mmdd}${sc}'
'draw string 9.0 0.2 ${yyyymmdd}${sc}(CST)'
'printim ECthin_3_STREAM_'z.j'_${yyyymmdd}${sc}_${mmdd}${sc}.gif gif'
*综合图4_'z.j'HPa_Relative vorticity [K m**2 kg**-1 s**-1 1e-06]
'c'
'set grads off'
'set grid off'
'run rgbset.gs'
'set clevs -48 -36 -24 -12 0 12 24 36 48 60 72 84'
'set ccols 46 45 44 43 41 61 62 63 64 65 66 67 69'
'set gxout shaded'
'd hcurl(Uprs,Vprs)*1000000'
'run cbar.gs'
'set gxout contour'
'set cint 24'
'set clab on'
'set ccolor 1'
'd hcurl(Uprs,Vprs)*1000000'
'draw title  ECthin 'z.j'HPa Relative vorticity ${mmdd}${sc}'
'draw string 6.0 0.2 [K m**2 kg**-1 s**-1 1e-06]${yyyymmdd}${sc}(CST)'
'printim ECthin_4_vorticity_'z.j'_${yyyymmdd}${sc}_${mmdd}${sc}.gif gif'
*综合图5_'z.j'HPa_Divergence[s**-1 1e-5]
'c'
'set grads off'
'set grid off'
'run rgbset.gs'
'set clevs -20 -16 -12 -8 -4 0 4 8 12 16 20'
'set ccols 47 46 45 44 43 41 61 63 64 65 66 69'
'set gxout shaded'
'd Dprs*100000'
'run cbar.gs'
'set gxout contour'
'set cint 8'
'set clab on'
'set ccolor 1'
'd Dprs*100000'
'draw title  ECthin 'z.j'HPa Divergence ${mmdd}${sc}'
'draw string 9.0 0.2 [s**-1 1e-5]${yyyymmdd}${sc}(CST)'
'printim ECthin_5_Divergence_'z.j'_${yyyymmdd}${sc}_${mmdd}${sc}.gif gif'
*综合图11(profile) 'z.j'HPa Specific humidity kg kg**-1
'c'
'set grads off'
'set grid off'
'set gxout shaded'
'run rgbset.gs'
'set clevs 2 3 4 5 6 7 8 9 10'
'set ccols 0 31 32 33 34 35 36 37 38 39'
'd Qprs*1000'
'run cbar.gs'
'set gxout contour'
'set cint 1'
'set clab on'
'd Qprs*1000'
'draw title  ECthin 'z.j'HPa Specific humidity [g kg**-1] ${mmdd}${sc}'
'draw string 9.0 0.2 ${yyyymmdd}${sc}(CST)'
'printim ECthin_11_Qprs_'z.j'_${yyyymmdd}${sc}_${mmdd}${sc}.gif gif'
j=j+1
endwhile
'quit'
EOF
grads -lbc "${current_filename}_cst.high.gs"
cat > ${current_filename}_cst.sfc.gs << EOF
'reinit'
'c'
'open ${current_filename}_cst.sfc.ctl'
'set display color white'
'set map 4 1 10'
'set mpdset cnworld cnriver shanxi shanxi_q'
'set parea 1 7.7 1 10'
'set lon 108 115'
'set lat 33 42'
*综合图7 Temperature at 2M
'set grads off'
'set grid off'
'run rgbset.gs'
'set clevs -20 -16 -12 -8 -4 0 4 8 12 16 20 24 28 32'
'set ccols 46 45 44 43 42 41 61 62 63 64 65 66 67 68 69'
'set gxout shaded'
'd no2Tsfc-273.16'
'run cbar.gs'
'set gxout contour'
'set cint 4'
'set clab on'
'd no2Tsfc-273.16'
'draw title  ECthin Temperature at 2M ${mmdd}${sc}'
'draw string 6.0 0.2 ${yyyymmdd}${sc}(CST)'
'printim ECthin_7_TMP2m_surf_${yyyymmdd}${sc}_${mmdd}${sc}.gif gif'
*综合图8 surface Total cloud cover [(0 - 1)]
'c'
'set grads off'
'set grid off'
'set gxout shaded'
'run rgbset.gs'
'set clevs 10 20 30 40 50 60 70 80 90 100'
'set ccols 42 44 46 48 52 53 54 55 56 57 59'
'd TCCsfc*100'
'run cbar.gs'
'set gxout contour'
'set cint 20'
'set clab on'
'd TCCsfc*100'
'draw title  ECthin surface Total cloud cover ${mmdd}${sc}'
'draw string 6.0 0.2 ${yyyymmdd}${sc}(CST)'
'printim ECthin_8_TCCsfc_surf_${yyyymmdd}${sc}_${mmdd}${sc}.gif gif'
*综合图10_surface Skin temperature [K]
'c'
'set grads off'
'set grid off'
'run rgbset.gs'
'set clevs -12 -8 -4 0 4 8 12 16 20 24 28 32'
'set ccols  44 43 42 41 61 62 63 64 65 66 67 68 69'
'set gxout shaded'
'd SKTsfc-273.16'
'run cbar.gs'
'set gxout contour'
'set cint 4'
'set clab on'
'd SKTsfc-273.16'
'draw title  ECthin surface Skin temperature ${mmdd}${sc}'
'draw string 6.0 0.2 ${yyyymmdd}${sc}(CST)'
'printim ECthin_10_SKTsfc_surf_${yyyymmdd}${sc}_${mmdd}${sc}.gif gif'
*综合图12 surface 2 metre dewpoint temperature [K]
'c'
'set grads off'
'set grid off'
'run rgbset.gs'
'set clevs -12 -8 -4 0 4 8 12 16 20 24 28 32'
'set ccols 44 43 42 41 61 62 63 64 65 66 67 68 69'
'set gxout shaded'
'd no2Dsfc-273.16'
'run cbar.gs'
'set gxout contour'
'set cint 4'
'set clab on'
'd no2Dsfc-273.16'
'draw title  ECthin surface 2m dewpoint temperature ${mmdd}${sc}'
'draw string 6.0 0.2 ${yyyymmdd}${sc}(CST)'
'printim ECthin_12_no2Dsfc_surf_${yyyymmdd}${sc}_${mmdd}${sc}.gif gif'
*综合图6 地面海平面气压 Mean sea level pressure [Pa]和10m风
'c'
'set grads off'
'set grid off'
'run rgbset.gs'
'set clevs 4 8 12 16 20'
'set ccols 71 72 73 74 75 76'
'set gxout shaded'
'd mag(no10Usfc,no10Vsfc)'
*地面PRESSURE
'run rgbset.gs'
'set gxout contour'
'set cint 2.5'
*'set cthink 9'
'set ccolor 1'
'd MSLsfc*0.01'
'run cbar.gs'
'set gxout barb'
'set ccolor 9'
'd skip(no10Usfc,4,4);skip(no10Vsfc,4,4)'
'set gxout contour'
'set cint 4'
'set ccolor 2'
'set clab on'
'd no2Tsfc-273.16'
'draw title  ECthin sea level pressure 10M Wind ${mmdd}${sc}'
'draw string 9.0 0.2 ${yyyymmdd}${sc}(CST)'
'printim ECthin_6_2MT.10wind.P_surf_${yyyymmdd}${sc}_${mmdd}${sc}.gif gif'
'quit'
EOF
grads -pbc "${current_filename}_cst.sfc.gs"
cat > ${current_filename}_6_cst.sfc.gs << EOF
'reinit'
'c'
'open ${current_filename}_cst.sfc.ctl'
'set display color white'
'set map 4 1 10'
'set mpdset cnworld cnriver shanxi shanxi_q'
'set parea 0 11 1 7.7'
'set lon 102 120'
'set lat 33 43'
*综合图6 地面海平面气压 Mean sea level pressure [Pa]和10m风
'c'
'set grads off'
'set grid off'
'run rgbset.gs'
'set clevs 4 8 12 16 20'
'set ccols 71 72 73 74 75 76'
'set gxout shaded'
'd mag(no10Usfc,no10Vsfc)'
*地面PRESSURE
'run rgbset.gs'
'set gxout contour'
'set cint 2.5'
*' set cthink 9 '
'set ccolor 1'
'd SPsfc*0.01'
'run cbar.gs'
'set gxout barb'
'set ccolor 9'
'd skip(no10Usfc,4,4);skip(no10Vsfc,4,4)'
'set gxout contour'
'set cint 4'
'set ccolor 2'
'set clab on'
'd no2Tsfc-273.16'
'draw title  ECthin sea level pressure 10M Wind ${mmdd}${sc}'
'draw string 9.0 0.2 ${yyyymmdd}${sc}(CST)'
'printim ECthin_6_2MT.10wind.P_surf_${yyyymmdd}${sc}_${mmdd}${sc}.gif gif'
'quit'
EOF
grads -lbc "${current_filename}_6_cst.sfc.gs"

declare -i ybh
for k in {1..20}
do
	let ybh=ybh+12
	yb_yyyymmddhh=`/home/WORK/ecthin/etc/newdate ${yyyymmdd}${sc} +${ybh}`
	echo "yb_yyyymmddhh="${yb_yyyymmddhh}
    yb_mmddhh=${yb_yyyymmddhh:4:6}
	echo "yb_mmddhh="${yb_mmddhh}
	echo wget -q -nv ftp://getdata:getdata@172.18.73.19//cmacastdata/nafp/ecmf/W_NAFP_C_ECMF_*_P_C1D${mmdd}${sc}00${yb_mmddhh}001.*
	wget -q -nv ftp://getdata:getdata@172.18.73.19//cmacastdata/nafp/ecmf/W_NAFP_C_ECMF_*_P_C1D${mmdd}${sc}00${yb_mmddhh}001.bz2
    bunzip2 W_NAFP_C_ECMF_*_P_C1D${mmdd}${sc}00${yb_mmddhh}001.bz2
     if [ ! -f W_NAFP_C_ECMF_*_P_C1D${mmdd}${sc}00${yb_mmddhh}001 ]
     then
         bunzip2 W_NAFP_C_ECMF_*_P_C1D${mmdd}${sc}00${yb_mmddhh}001.bz2
     fi
    
    ls W_NAFP_C_ECMF_*_P_C1D${mmdd}${sc}00${yb_mmddhh}001 | while read line
	do
        eval $(echo $line|awk -F"_" '{for ( x = 1; x <= NF; x++ ) { print "arrfold["x"]="$x}}')
        mscs_mmddhh=${arrfold[7]:3:6}
        echo "mscs_mmddhh="${mscs_mmddhh} "current_mmddsc="${yyyymmdd}${sc}
        ybsx_mmddhh=${arrfold[7]:11:6}
        echo "ybsx_mmddhh="${ybsx_mmddhh} "yb_yyyymmddhh="${yb_yyyymmddhh}
        wgrib -s $line | grep "mb:" | wgrib $line -i -grib -append -o ${current_filename}.high
		wgrib -s $line | grep ":TP:" | wgrib -i -grib $line -o ${current_filename}_${ybsx_mmddhh}.TP
        wgrib -s $line | grep ":2T:" | wgrib -i -grib $line -append -o ${current_filename}_${ybsx_mmddhh}.TP
		grib2ctl.pl -verf ${current_filename}_${ybsx_mmddhh}.TP > ${current_filename}_${ybsx_mmddhh}.TP.ctl
		gribmap -i ${current_filename}_${ybsx_mmddhh}.TP.ctl
		cat > ${current_filename}_${ybsx_mmddhh}_Rain.gs << EOF
'reinit'
'c'
'open ${current_filename}_${ybsx_mmddhh}.TP.ctl'
'set display color white'
'set map 4 1 10'
'set mpdset cnworld cnriver shanxi shanxi_q'
'set parea 1 7.7 1 10'
'set lon 108 116'
'set lat 34 43'
'set csmooth on' 
*累积降水量
'set grads off'
'set grid off'
'set gxout shaded'
'run rgbset.gs'
'set clevs 1 10 25 50 100 250'
'set rgb 100 253 253 253'
'set rgb 21  166   242  143'
'set rgb 22  61   186   61'
'set rgb 23  97  184   255'
'set rgb 24  0  0   225'
'set rgb 25  250  0   250'
'set rgb 26  128 0   64'
'set ccols 100 21 22 23 24 25 26 '
*'set clevs 0 0.5 1 1.5 2 2.5 5 10 20 25 50 80 100'
*'set ccols 0 42 43 44 45 46 47 48 49 56 58 59 65 9'
'd TPsfc*1000'
'run cbar.gs'
'set gxout contour'
*'set cint 10'
'set clevs 0 0.1 10 25 50 100 250'
'set clab on'
'd TPsfc*1000'
'draw title   ECthin rain ${yyyymmdd}${sc}-${ybsx_mmddhh}'
'draw string 6.0 0.2 ${yyyymmdd}${sc}(CST)'
'printim ECthin_9_rain_${yyyymmdd}${sc}_${ybsx_mmddhh}.gif gif'
'quit'
EOF
		grads -pbc "${current_filename}_${ybsx_mmddhh}_Rain.gs"
 		wgrib -s $line | grep ":10U:" | wgrib -i -grib $line -o ${current_filename}_${ybsx_mmddhh}.6
        wgrib -s $line | grep ":10V:" | wgrib -i -grib $line -append -o ${current_filename}_${ybsx_mmddhh}.6
        wgrib -s $line | grep ":2T:" | wgrib -i -grib $line -append -o ${current_filename}_${ybsx_mmddhh}.6
        wgrib -s $line | grep ":SP:" | wgrib -i -grib $line -append -o ${current_filename}_${ybsx_mmddhh}.6
		grib2ctl.pl -verf ${current_filename}_${ybsx_mmddhh}.6 > ${current_filename}_${ybsx_mmddhh}.6.ctl
		gribmap -i ${current_filename}_${ybsx_mmddhh}.6.ctl
		cat > ${current_filename}_${ybsx_mmddhh}.6.gs << EOF
*综合图6 地面海平面气压 Mean sea level pressure [Pa]和10m风
'reinit'
'c'
'open ${current_filename}_${ybsx_mmddhh}.6.ctl'
'set display color white'
'set map 4 1 10'
'set mpdset cnworld cnriver shanxi shanxi_q'
'c'
'set grads off'
'set grid off'
'set parea 0 11 1 7.7'
'set lon 102 120'
'set lat 33 43'
'run rgbset.gs'
'set clevs 4 8 12 16 20'
'set ccols 71 72 73 74 75 76'
'set gxout shaded'
'd mag(no10Usfc,no10Vsfc)'
*地面PRESSURE
'run rgbset.gs'
'set gxout contour'
'set cint 2.5'
*'set cthink 9'
'set ccolor 1'
'd SPsfc*0.01'
'run cbar.gs'
'set gxout barb'
'set ccolor 9'
'd skip(no10Usfc,4,4);skip(no10Vsfc,4,4)'
'set gxout contour'
'set cint 4'
'set ccolor 2'
'set clab on'
'd no2Tsfc-273.16'
'draw title  ECthin sea level pressure 10M Wind ${ybsx_mmddhh}'
'draw string 9.0 0.2 ${yyyymmdd}${sc}(CST)'
'printim ECthin_6_2MT.10wind.P_surf_${yyyymmdd}${sc}_${ybsx_mmddhh}.gif gif'
'quit'
EOF
		grads -lbc "${current_filename}_${ybsx_mmddhh}.6.gs"
        wgrib -s $line | grep ":TCC:" | wgrib -i -grib $line -o ${current_filename}_${ybsx_mmddhh}.sfc
        wgrib -s $line | grep ":VIS:" | wgrib -i -grib $line -append -o ${current_filename}_${ybsx_mmddhh}.sfc
        wgrib -s $line | grep ":MX2T6:" | wgrib -i -grib $line -append -o ${current_filename}_${ybsx_mmddhh}.sfc
        wgrib -s $line | grep ":MN2T6:" | wgrib -i -grib $line -append -o ${current_filename}_${ybsx_mmddhh}.sfc
        wgrib -s $line | grep ":CAPE:" | wgrib -i -grib $line -append -o ${current_filename}_${ybsx_mmddhh}.sfc
        wgrib -s $line | grep ":CAPES:" | wgrib -i -grib $line -append -o ${current_filename}_${ybsx_mmddhh}.sfc
        grib2ctl.pl -verf ${current_filename}_${ybsx_mmddhh}.sfc > ${current_filename}_${ybsx_mmddhh}.sfc.ctl
		gribmap -i ${current_filename}_${ybsx_mmddhh}.sfc.ctl
		cat > ${current_filename}_${ybsx_mmddhh}.sfc.gs << EOF
'reinit'
'c'
'open ${current_filename}_${ybsx_mmddhh}.sfc.ctl'
'set display color white'
'set map 4 1 10'
'set mpdset cnworld cnriver shanxi shanxi_q'
'set parea 1 7.7 1 10'
'set lon 108 115'
'set lat 33 42'
*综合图7 能见度
'c'
'set grads off'
'set grid off'
'run rgbset.gs'
'set clevs 0 4 8 12 16 20 24 28 32'
'set ccols 41 61 62 63 64 65 66 67 68 69'
'set gxout shaded'
'd VISsfc*0.001'
'run cbar.gs'
'set gxout contour'
*'set cint 4'
'set clab on'
'd VISsfc*0.001'
'draw title  ECthin VIS ${ybsx_mmddhh}'
'draw string 6.0 0.2 ${yyyymmdd}${sc}(CST)'
'printim ECthin_7_VIS_surf_${yyyymmdd}${sc}_${ybsx_mmddhh}.gif gif'
*综合图8 surface Total cloud cover [(0 - 1)]
'c'
'set grads off'
'set grid off'
'set gxout shaded'
'run rgbset.gs'
'set clevs 10 20 30 40 50 60 70 80 90 100'
'set ccols 42 44 46 48 52 53 54 55 56 57 59'
'd TCCsfc*100'
'run cbar.gs'
'set gxout contour'
'set cint 20'
'set clab on'
'd TCCsfc*100'
'draw title  ECthin surface Total cloud cover ${ybsx_mmddhh}'
'draw string 6.0 0.2 ${yyyymmdd}${sc}(CST)'
'printim ECthin_8_TCCsfc_surf_${yyyymmdd}${sc}_${ybsx_mmddhh}.gif gif'
*综合图12 过去6小时2米最高温度 [K]
'c'
'set grads off'
'set grid off'
'run rgbset.gs'
'set clevs -12 -8 -4 0 4 8 12 16 20 24 28 32'
'set ccols  44 43 42 41 61 62 63 64 65 66 67 68 69'
'set gxout shaded'
'd MX2T6sfc-273.16'
'run cbar.gs'
'set gxout contour'
'set cint 4'
'set clab on'
'd MX2T6sfc-273.16'
'draw title  ECthin 2 metre last 6H MAX temperature ${ybsx_mmddhh}'
'draw string 6.0 0.2 ${yyyymmdd}${sc}(CST)'
'printim ECthin_12_MX2T6sfc_surf_${yyyymmdd}${sc}_${ybsx_mmddhh}.gif gif'
*综合图12 过去6小时2米最低温度 [K]
'c'
'set grads off'
'set grid off'
'run rgbset.gs'
'set clevs -12 -8 -4 0 4 8 12 16 20 24 28 32'
'set ccols 44 43 42 41 61 62 63 64 65 66 67 68 69'
'set gxout shaded'
'd MN2T6sfc-273.16'
'run cbar.gs'
'set gxout contour'
'set cint 4'
'set clab on'
'd MN2T6sfc-273.16'
'draw title  ECthin 2 metre last 6H MIN temperature ${ybsx_mmddhh}'
'draw string 6.0 0.2 ${yyyymmdd}${sc}(CST)'
'printim ECthin_12_MN2T6sfc_surf_${yyyymmdd}${sc}_${ybsx_mmddhh}.gif gif'
'quit'
EOF
		grads -pbc "${current_filename}_${ybsx_mmddhh}.sfc.gs"
        
	done
done
grib2ctl.pl -verf ${current_filename}.high > ${current_filename}.high.ctl
gribmap -i ${current_filename}.high.ctl
cat > ${current_filename}.high.gs << EOF
'reinit'
'c'
'open ${current_filename}.high.ctl'
'set display color white'
'set map 4 1 10'
'set mpdset cnworld cnriver shanxi shanxi_q'
'set parea 0 11 1 7.7'
'set lon 102 120'
'set lat 33 43'
i=1
while(i<21)
'set t 'i
'q time'
say i' 'result
in_time1= subwrd(result,3)
in_time_hour= substr(in_time1,1,2)
in_time_day= substr(in_time1,4,2)
in_time_mon= substr(in_time1,6,3)
in_time_year= substr(in_time1,9,4)
year=subwrd(in_time_year,1)  
day=subwrd(in_time_day,1)  
hour=subwrd(in_time_hour,1)
  if(in_time_mon='JAN')
  month=01
  endif
  if(in_time_mon='FEB')
  month=02
  endif
  if(in_time_mon='MAR')
  month=03
  endif
  if(in_time_mon='APR')
  month=04
  endif
  if(in_time_mon='MAY')
  month=05
  endif
  if(in_time_mon='JUN')
  month=06
  endif
  if(in_time_mon='JUL')
  month=07
  endif
  if(in_time_mon='AUG')
  month=08
  endif
  if(in_time_mon='SEP')
  month=09
  endif
  if(in_time_mon='OCT')
  month=10
  endif
  if(in_time_mon='NOV')
  month=11
  endif
  if(in_time_mon='DEC')
  month=12
  endif
say year month day hour
z.1='850'
z.2='700'
z.3='500'
z.4='200'
j=1
while(j<5)
'set lev 'z.j
'set csmooth on'
*综合图1_'z.j'HPA Relative humidity % wind Temperature
'c'
'set grads off'
'set grid off'
*相对湿度
'set gxout shaded'
'run rgbset.gs'
'set clevs 20 30 40 50 60 70 80 90 100'
'set ccols 0 31 32 33 34 35 36 37 38 39'
'd Rprs'
'run cbar.gs'
*风场
'set gxout barb'
'set digsize 0.045'
'set ccolor 9'
'set cthick 5'
'd skip(Uprs,2,2);skip(Vprs,2,2)'
*气温
'set gxout contour'
'set cint 2'
'run rgbset.gs'
'set ccolor 2'
'd Tprs-273.16'
*高度
'set gxout contour'
'set cint 2'
'run rgbset.gs'
'set ccolor 1'
'set cthick 5'
'd GHprs/9.8'
'draw title ECthin 'z.j'H.RH.WIND.T 'month day hour
'draw string 9.0 0.2 ${yyyymmdd}${sc}(CST)'
'printim ECthin_1_H.RH.WIND.T_'z.j'_${yyyymmdd}${sc}_'month day hour'.gif gif'
*综合图2 'z.j'HPA垂直速度 Vertical velocity [Pa s**-1]
'c'
'set grads off'
'set grid off'
'set gxout shaded'
'run rgbset.gs'
'set clevs -12 -10 -8 -6 -4 -2 0 2 4 6 8 10 12'
'set ccols 49 47 46 45 44 42 41 61 62 63 64 65 67 68 69'
'd Wprs'
'run cbar.gs'
'set gxout contour'
'set cint 2'
'set clab on'
'd Wprs'
'draw title   ECthin 'z.j'HPa Vertical velocity [Pa s**-1] 'month day hour
'draw string 9.0 0.2 ${yyyymmdd}${sc}(CST)'
'printim ECthin_2_Wprs_'z.j'_${yyyymmdd}${sc}_'month day hour'.gif gif'
*综合图3_'z.j'HPa_STREAM
'c'
'set grads off'
'set grid off'
'run rgbset.gs'
'set clevs 15 30 40 50'
'set ccols 0 72 74 76 78'
'set gxout shaded'
'd mag(Uprs,Vprs)'
'run cbar.gs'
'set ccolor 1'
'set gxout stream'
'd Uprs;Vprs'
'draw title  ECthin 'z.j'HPA STREAM 'month day hour
'draw string 9.0 0.2 ${yyyymmdd}${sc}(CST)'
'printim ECthin_3_STREAM_'z.j'_${yyyymmdd}${sc}_'month day hour'.gif gif'
*综合图4_'z.j'HPa_Relative vorticity [K m**2 kg**-1 s**-1 1e-06]
'c'
'set grads off'
'set grid off'
'run rgbset.gs'
'set clevs -48 -36 -24 -12 0 12 24 36 48 60 72 84'
'set ccols 46 45 44 43 41 61 62 63 64 65 66 67 69'
'set gxout shaded'
'd hcurl(Uprs,Vprs)*1000000'
'run cbar.gs'
'set gxout contour'
'set cint 24'
'set clab on'
'set ccolor 1'
'd hcurl(Uprs,Vprs)*1000000'
'draw title  ECthin 'z.j'HPa Relative vorticity 'month day hour
'draw string 6.0 0.2 [K m**2 kg**-1 s**-1 1e-06]${yyyymmdd}${sc}(CST)'
'printim ECthin_4_vorticity_'z.j'_${yyyymmdd}${sc}_'month day hour'.gif gif'
*综合图5_'z.j'HPa_Divergence[s**-1 1e-5]
'c'
'set grads off'
'set grid off'
'run rgbset.gs'
'set clevs -20 -16 -12 -8 -4 0 4 8 12 16 20'
'set ccols 47 46 45 44 43 41 61 63 64 65 66 69'
'set gxout shaded'
'd Dprs*100000'
'run cbar.gs'
'set gxout contour'
'set cint 8'
'set clab on'
'set ccolor 1'
'd Dprs*100000'
'draw title  ECthin 'z.j'HPa Divergence 'month day hour
'draw string 9.0 0.2 [s**-1 1e-5]${yyyymmdd}${sc}(CST)'
'printim ECthin_5_Divergence_'z.j'_${yyyymmdd}${sc}_'month day hour'.gif gif'
*综合图11(profile) 'z.j'HPa Specific humidity kg kg**-1
'c'
'set grads off'
'set grid off'
'set gxout shaded'
'run rgbset.gs'
'set clevs 2 3 4 5 6 7 8 9 10'
'set ccols 0 31 32 33 34 35 36 37 38 39'
'd Qprs*1000'
'run cbar.gs'
'set gxout contour'
'set cint 1'
'set clab on'
'd Qprs*1000'
'draw title  ECthin 'z.j'HPa Specific humidity [g kg**-1] 'month day hour
'draw string 9.0 0.2 ${yyyymmdd}${sc}(CST)'
say year month day hour
'printim ECthin_11_Qprs_'z.j'_${yyyymmdd}${sc}_'month day hour'.gif gif'
j=j+1
endwhile
i=i+1
endwhile
'quit'
EOF
grads -lbc "${current_filename}.high.gs"
#24小时降水、24小时变温
 declare i ltime ctime
 echo 24H Rain dT
 for i in {1..9}
 do
	let ltime=($i-1)*24+12
	let ctime=$i*24+12
#取前24小时文件名
	last_yyyymmddhh=`/home/WORK/ecthin/etc/newdate ${yyyymmdd}${sc} +$ltime`
	echo "last_yyyymmddhh="${last_yyyymmddhh}
	last_mmddhh=${last_yyyymmddhh:4:6}
	echo "last_mmddhh="${last_mmddhh}
	last_filename=${current_filename}_${last_mmddhh}.TP
	echo "last_filename="${last_filename}
	present_yyyymmddhh=`/home/WORK/ecthin/etc/newdate ${yyyymmdd}${sc} +$ctime`
	echo "present_yyyymmddhh="${present_yyyymmddhh}
	present_mmddhh=${present_yyyymmddhh:4:6}
	echo "present_mmddhh="${present_mmddhh}
	present_filename=${current_filename}_${present_mmddhh}.TP
	echo "present_filename="${present_filename}
	if [ -f ${last_filename}.ctl ] ; then
		echo "last_filename.ctl="${last_filename}.ctl
		rm -f ${present_filename}_24R.gs
		cat > ${present_filename}_24R.gs << EOF
'reinit'
'c'
'open ${last_filename}.ctl'
'open ${present_filename}.ctl'
'set display color white'
'set map 4 1 10'
'set mpdset cnworld cnriver shanxi shanxi_q'
'set parea 1 7.7 1 10'
'set lon 108 116'
'set lat 34 43'
'set csmooth on' 
*24小时降水量
'c'
'set grads off'
'set grid off'
'set gxout shaded'
'run rgbset.gs'
'set clevs 1 10 25 50 100 250'
'set rgb 100 253 253 253'
'set rgb 21  166   242  143'
'set rgb 22  61   186   61'
'set rgb 23  97  184   255'
'set rgb 24  0  0   225'
'set rgb 25  250  0   250'
'set rgb 26  128 0   64'
'set ccols 100 21 22 23 24 25 26 '
*'set clevs 0 0.5 1 1.5 2 2.5 5 10 20 25 50 80 100'
*'set ccols 0 42 43 44 45 46 47 48 49 56 58 59 65 9'
'd (TPsfc.2-TPsfc.1)*1000'
'run cbar.gs'
'set gxout contour'
*'set cint 5'
'set clevs 1 10 25 50 100 250'
'set clab on'
'd (TPsfc.2-TPsfc.1)*1000'
'draw title   ECthin 24H rain ${last_mmddhh}-${present_mmddhh}'
'draw string 6.0 0.2 ${yyyymmdd}${sc}(CST)'
'printim ECthin_9_24rain_${yyyymmdd}${sc}_${present_mmddhh}.gif gif'
*地面2metre 24小时变温 surface 2 metre temperature
'c'
'set grads off'
'set grid off'
'set gxout shaded'
'run rgbset.gs'
'set cint 2'
'set clevs -12 -10 -8 -6 -4 -2 0 2 4 6 8 10 12 14 16'
'set ccols 46 45 44 43 42 41 21 22 23 24 25 26 27 28 29'
'd no2Tsfc.2-no2Tsfc.1'
'run cbar.gs'
'set gxout contour'
'set clab on'
'set cint 2'
'd no2Tsfc.2-no2Tsfc.1'
'draw title   ECthin 24H 2mT ${last_mmddhh}-${present_mmddhh}'
'draw string 6.0 0.2 ${yyyymmdd}${sc}(CST)'
'printim ECthin_13_24no2Tsfc_${yyyymmdd}${sc}_${present_mmddhh}.gif gif'
'quit'
EOF
		echo "present_filename_24R.gs"=${present_filename}_24R.gs
		grads -pbc "${present_filename}_24R.gs"
	fi			 
 done
 
 echo 12H Rain
 for i in {1..20}
 do
	let ltime=($i-1)*12
	let ctime=$i*12
#取前24小时文件名
	last_yyyymmddhh=`/home/WORK/ecthin/etc/newdate ${yyyymmdd}${sc} +$ltime`
	echo "last_yyyymmddhh="${last_yyyymmddhh}
	last_mmddhh=${last_yyyymmddhh:4:6}
	echo "last_mmddhh="${last_mmddhh}
	last_filename=${current_filename}_${last_mmddhh}.TP
	echo "last_filename="${last_filename}
	present_yyyymmddhh=`/home/WORK/ecthin/etc/newdate ${yyyymmdd}${sc} +$ctime`
	echo "present_yyyymmddhh="${present_yyyymmddhh}
	present_mmddhh=${present_yyyymmddhh:4:6}
	echo "present_mmddhh="${present_mmddhh}
	present_filename=${current_filename}_${present_mmddhh}.TP
	echo "present_filename="${present_filename}
	if [ -f ${last_filename}.ctl ] ; then
		echo "last_filename.ctl="${last_filename}.ctl
		rm -f ${present_filename}_12R.gs
		cat > ${present_filename}_12R.gs << EOF
'reinit'
'c'
'open ${last_filename}.ctl'
'open ${present_filename}.ctl'
'set display color white'
'set map 4 1 10'
'set mpdset cnworld cnriver shanxi shanxi_q'
'set parea 1 7.7 1 10'
'set lon 108 116'
'set lat 34 43'
'set csmooth on' 
*12小时降水量
'c'
'set grads off'
'set grid off'
'set gxout shaded'
'run rgbset.gs'
'set clevs 1 5 15 30 70 140'
'set rgb 100 253 253 253'
'set rgb 21  166   242  143'
'set rgb 22  61   186   61'
'set rgb 23  97  184   255'
'set rgb 24  0  0   225'
'set rgb 25  250  0   250'
'set rgb 26  128 0   64'
'set ccols 100 21 22 23 24 25 26 '
*'set clevs 0 0.5 1 1.5 2 2.5 5 10 20 25 50 80 100'
*'set ccols 0 42 43 44 45 46 47 48 49 56 58 59 65 9'
'd (TPsfc.2-TPsfc.1)*1000'
'run cbar.gs'
'set gxout contour'
*'set cint 5'
'set clevs 1 5 15 30 70 140'
'set clab on'
'd (TPsfc.2-TPsfc.1)*1000'
'draw title   ECthin 12H rain ${last_mmddhh}-${present_mmddhh}'
'draw string 6.0 0.2 ${yyyymmdd}${sc}(CST)'
'printim ECthin_9_12rain_${yyyymmdd}${sc}_${present_mmddhh}.gif gif'
'quit'
EOF
		echo "present_filename_12R.gs"=${present_filename}_12R.gs
		grads -pbc "${present_filename}_12R.gs"
	fi			 
 done
#动画绘图
for lev in 850 700 500 200
do
	convert -loop 50 -delay 50 ECthin_1_H.RH.WIND.T_${lev}_${yyyymmdd}${sc}*.gif ECthin_1_H.RH.WIND.T_${lev}_${yyyymmdd}${sc}.gif
	convert -loop 50 -delay 50 ECthin_2_Wprs_${lev}_${yyyymmdd}${sc}*.gif ECthin_2_Wprs_${lev}_${yyyymmdd}${sc}.gif
	convert -loop 50 -delay 50 ECthin_3_STREAM_${lev}_${yyyymmdd}${sc}*.gif ECthin_3_STREAM_${lev}_${yyyymmdd}${sc}.gif
	convert -loop 50 -delay 50 ECthin_4_vorticity_${lev}_${yyyymmdd}${sc}*.gif ECthin_4_vorticity_${lev}_${yyyymmdd}${sc}.gif
	convert -loop 50 -delay 50 ECthin_5_Divergence_${lev}_${yyyymmdd}${sc}*.gif ECthin_5_Divergence_${lev}_${yyyymmdd}${sc}.gif
	convert -loop 50 -delay 50 ECthin_11_Qprs_${lev}_${yyyymmdd}${sc}*.gif ECthin_11_Qprs_${lev}_${yyyymmdd}${sc}.gif
done
ybh=0
for k in {1..20}
do
	let ybh=ybh+12
	yb_yyyymmddhh=`/home/WORK/ecthin/etc/newdate ${yyyymmdd}${sc} +${ybh}`
	echo "yb_yyyymmddhh="${yb_yyyymmddhh}
    yb_mmddhh=${yb_yyyymmddhh:4:6}
	echo "yb_mmddhh="${yb_mmddhh}
convert -loop 50 -delay 50 ECthin_1_H.RH.WIND.T_*_${yyyymmdd}${sc}_${yb_mmddhh}.gif ECthin_1_H.RH.WIND.T_${yyyymmdd}${sc}_${yb_mmddhh}.gif
convert -loop 50 -delay 50 ECthin_2_Wprs_*_${yyyymmdd}${sc}_${yb_mmddhh}.gif ECthin_2_Wprs_${yyyymmdd}${sc}_${yb_mmddhh}.gif
convert -loop 50 -delay 50 ECthin_3_STREAM_*_${yyyymmdd}${sc}_${yb_mmddhh}.gif ECthin_3_STREAM_${yyyymmdd}${sc}_${yb_mmddhh}.gif
convert -loop 50 -delay 50 ECthin_4_vorticity_*_${yyyymmdd}${sc}_${yb_mmddhh}.gif ECthin_4_vorticity_${yyyymmdd}${sc}_${yb_mmddhh}.gif
convert -loop 50 -delay 50 ECthin_5_Divergence_*_${yyyymmdd}${sc}_${yb_mmddhh}.gif ECthin_5_Divergence_${yyyymmdd}${sc}_${yb_mmddhh}.gif
convert -loop 50 -delay 50 ECthin_11_Qprs_*_${yyyymmdd}${sc}_${yb_mmddhh}.gif ECthin_11_Qprs_${yyyymmdd}${sc}_${yb_mmddhh}.gif
done
convert -loop 50 -delay 50 ECthin_6_2MT.10wind.P_surf_${yyyymmdd}${sc}*.gif ECthin_6_2MT.10wind.P_surf_${yyyymmdd}${sc}.gif
convert -loop 50 -delay 50 ECthin_7_TMP2m_surf_${yyyymmdd}${sc}*.gif ECthin_7_TMP2m_surf_${yyyymmdd}${sc}.gif
convert -loop 50 -delay 50 ECthin_8_TCCsfc_surf_${yyyymmdd}${sc}*.gif ECthin_8_TCCsfc_surf_${yyyymmdd}${sc}.gif
convert -loop 50 -delay 50 ECthin_9_12rain_${yyyymmdd}${sc}*.gif ECthin_9_12rain_${yyyymmdd}${sc}.gif
convert -loop 50 -delay 50 ECthin_9_24rain_${yyyymmdd}${sc}*.gif ECthin_9_24rain_${yyyymmdd}${sc}.gif
convert -loop 50 -delay 50 ECthin_10_SKTsfc_surf_${yyyymmdd}${sc}*.gif ECthin_10_SKTsfc_surf_${yyyymmdd}${sc}.gif
convert -loop 50 -delay 50 ECthin_12_no2Dsfc_surf_${yyyymmdd}${sc}*.gif ECthin_12_no2Dsfc_surf_${yyyymmdd}${sc}.gif
convert -loop 50 -delay 50 ECthin_13_24no2Tsfc_${yyyymmdd}${sc}*.gif ECthin_13_24no2Tsfc_${yyyymmdd}${sc}.gif

ftpsrc='ecthin_'${sc}'_gif_put'
cat > ${ftpsrc} << EOF
user  admin admin
bi
prompt
pass
cd /Download/data/ecthin
mkdir ${yyyymmdd}
cd ${yyyymmdd}
mput ECthin_1*.gif
mput ECthin_2*.gif
mput ECthin_3*.gif
mput ECthin_4*.gif
mput ECthin_5*.gif
mput ECthin_6*.gif
mput ECthin_7*.gif
mput ECthin_8*.gif
mput ECthin_9*.gif
mput ECthin_10*.gif
mput ECthin_11*.gif
mput ECthin_12*.gif
mput ECthin_13*.gif
bye
EOF
ftp -nv 172.18.73.101 < ${ftpsrc}
find /home/WORK/data/ecthin/ecthin${sc} -name "*.gif" -exec rm -rf {} \;
test -d /home/WORK/data/ecthin/ecthin${sc} || mkdir -p /home/WORK/data/ecthin/ecthin${sc}
find . -name "*.gif" -exec mv {} /home/WORK/data/ecthin/ecthin${sc} \;
exit
