#!/bin/bash

#Bash GMT6 script to plot earthquakes coloured by depth. Katie Woods 2 Aug 2022


#FILE PATHS
community_fault_model='files/community_fault_model.txt' #Seebeck et al. (2022)
front='files/hikurangi_deformation_front_xy.csv' #Barnes et al. (2010, 2018, 2020), Collot et al. (2001), Crutchley et al. (2020)
catalog='data_examples/eqs2012_to_2020.txt' #GeoNet earthquakes
hiku_cwilliams='files/grid_exclude_wgs84.grd' #updated version of Williams et al. (2013) geometry from Charles Williams on 6 Dec 2018

#MAP SETTINGS
proj='-JM6i'
reg='-Rd173.5/175/-42/-41'

#MAKE COLOUR PALETTE
gmt makecpt -Cdarkred,deepskyblue2,darkorange2 -T0,10,20,30 > earthquakes.cpt

#FIGURE
gmt begin figures/earthquakes_by_depth pdf
	
	#SET DEFAULTS
	gmt set MAP_FRAME_PEN=0.7p,black MAP_FRAME_TYPE=plain FONT_ANNOT_PRIMARY=13p,black
	
	#COASTLINE
	gmt coast $reg $proj -BSWne -Baf -W0.7p,black@50 -Ggray89 -Sgray89 -Lg173.7/-41.5+w10+c173.7/-41.5 -Df
	
	#COMMUNITY FAULT MODEL
	gmt plot $community_fault_model -W0.7p,midnightblue@50

	#HIKURANGI DEFORMATION FRONT
	gmt plot $front -Sf0.5i/0.15+l+t -W1.5p,black -Gblack
	
	##EARTHQUAKES COLOURED BY DEPTH (for earthquakes <30 km depth), SIZED BASED ON MAGNTIUDE
	t1=2013.0 #decimal years for use with TDEFNODE inversion output
	t2=2014.5
	awk -v t1=$t1 -v t2=$t2 '{if ($1 >= t1 && $1 < t2 && $6<30) print $3,$4,$6,($5*$5)/70}' $catalog | gmt plot -Sc -Cearthquakes.cpt -W0.7p,black@50

	#FOCAL MECHANISM
	echo 174.3287 -41.5957 21 233 75 162 6.6 0 0 | gmt psmeca -Sa0.45 -Gblack -Ewhite
	echo 174.1522 -41.7340 15 238 70 171 6.6 0 0 | gmt psmeca -Sa0.45 -Gblack -Ewhite

	gmt coast -W0.7p,black@50

	#SUBDUCTION INTERFACE
	gmt grdcontour $hiku_cwilliams -A10+u" km" -L-110/-3 -W1p,black@35,2_2:4p
	
	#LEGENDS (eq size calculated based on (Mw*Mw)/70 as seen on the catalog plot line)
	gmt plot -Sc -Gwhite -W0.7p,black <<- EOF
	174.8,-41.73,0.1285714
	174.8,-41.76,0.2285714
	174.8,-41.80,0.3571428
	174.8,-41.85,0.5142857
	EOF
	gmt text -F+jLM+f8p,black <<- EOF
	174.83 -41.73 M@-w@- 3
	174.83 -41.76 M@-w@- 4
	174.83 -41.80 M@-w@- 5
	174.83 -41.85 M@-w@- 6
	EOF
	gmt psscale -Dg173.65/-41.35+w1i/0.1i+h -Cearthquakes.cpt -Baf+l"Depth (km)" --FONT_LABEL=10p --FONT_ANNOT_PRIMARY=10p
	
	#TEXT
	gmt text -F+j+f+a <<- EOF
	174.6 -41.5 CM 20p,Helvetica-Bold,black@60 -40 COOK STRAIT 
	EOF
	
	gmt basemap -Bnwse
	gmt end

#CLEAN UP
rm -f earthquakes.cpt
