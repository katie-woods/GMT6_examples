#!/bin/bash

#Bash GMT6 script to plot time series data. Katie Woods 2 Aug 2022

#FILE PATHS
data='data_examples/POBS18-1_models.txt'

#AXES LIMITS
t1='2019-01-02T'
t2='2019-09-30T'
y11=-25
y12=25
y21=-25
y22=25
d1=737426
d2=737699

#FIG SIZE
proj='-JX3i/2.5i'

#FIGURE
gmt begin figures/time_series pdf

	#SET DEFAULTS
	gmt set FORMAT_DATE_MAP=o FORMAT_DATE_MAP=o FORMAT_DATE_IN=yyyy-mm-dd FONT_LABEL=10p FONT_ANNOT_PRIMARY=10p FONT_TAG=10p FONT_ANNOT_SECONDARY=10p FONT_TITLE=11p
	
	#DATETIME AXIS
	gmt basemap -R"$t1"/"$t2"/"$y11"/"$y12" $proj --MAP_TITLE_OFFSET=4p --MAP_ANNOT_OFFSET=2p -BSW+t"Lowpass filtered POBS data" -Bxa1Og1of1o -Bya10f5g5+l"Pressure (hPa)" --FORMAT_TIME_PRIMARY_MAP=C --MAP_GRID_PEN_PRIMARY=gray69 --FONT_TAG=8p
	
	#DATENUM AXIS AND TIME SERIES PLOT
	awk '{print $1,$2+13}' $data | gmt plot -R"$d1"/"$d2"/"$y11"/"$y12" -W1p,black
	awk '{print $1,$3+2}' $data | gmt plot -W1p,red
	awk '{print $1,$5-5}' $data | gmt plot -W1p,blue
	awk '{print $1,$6-15}' $data | gmt plot -W1p,orange
	
	#TEXT
	gmt text -F+f+j <<- EOF
	737432 22.00 16p,Helvetica-Bold,black LM a
	737694 22.50 10p,Helvetica-Bold,black=~3p,white@10 RM POBS18-1
	737430  4.50 8p,Helvetica-Bold,red=~2p,white@10 LM ECCO2
	737430 -8.50 8p,Helvetica-Bold,blue=~2p,white@10 LM GLORYS
	737430 -18.0 8p,Helvetica-Bold,darkorange=~2p,white@10 LM HYCOM
	737430 17.50 8p,Helvetica-Bold,black=~2p,white@10 LM Observation
	EOF
	
	gmt basemap -Bnswe

gmt end
