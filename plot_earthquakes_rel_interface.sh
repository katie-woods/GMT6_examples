#!/bin/bash

#Bash GMT6 script to plot earthquakes colour by their depth relative to the
#Hikurangi subduction interface. Katie Woods 2 Aug 2022


#FILE PATHS
community_fault_model='files/community_fault_model.txt' #Seebeck et al. (2022)
front='files/hikurangi_deformation_front_xy.csv' #Barnes et al. (2010, 2018, 2020), Collot et al. (2001), Crutchley et al. (2020)
catalog='data_examples/eqs2012_to_2020.txt' #GeoNet earthquakes
hiku_cwilliams='files/grid_exclude_wgs84.grd' #updated version of Williams et al. (2013) from Charles Williams on 6 Dec 2018

#MAP SETTINGS
proj='-JM6i'
reg='-Rd172/179.2/-42/-38'

#FIGURE
gmt begin figures/earthquakes_rel_interface pdf
	
	#SET DEFAULTS
	gmt set MAP_FRAME_PEN=0.7p,black MAP_FRAME_TYPE=plain FONT_ANNOT_PRIMARY=13p,black
	
	#COASTLINE
	gmt coast $reg $proj -BSWne -Baf -W0.7p,black@50 -Ggray89 -Sgray89 -Lg173.5/-38.3+w50+c173.5/-38.3 -Df
	
	#COMMUNITY FAULT MODEL
	gmt plot $community_fault_model -W0.7p,black@50

	#HIKURANGI DEFORMATION FRONT
	gmt plot $front -Sf0.5i/0.15+l+t -W1.5p,black -Gblack
	
	#EARTHQUAKES COLOURED RELATIVE TO SUBDUCTION INTERFACE DEPTH, SIZED BASED ON MAGNTIUDE (Mw/40 for symbol size)
	t1=2013.0 #decimal years for use with TDEFNODE inversion output
	t2=2014.5
	# extract earthquakes in time range
	awk -v t1=$t1 -v t2=$t2 '{if ($1 >= t1 && $1 < t2) print $3,$4,$6,$5}' $catalog > track.xyz
	gmt grdtrack track.xyz -G$hiku_cwilliams > track.xyzi
	awk '{print $1,$2,$3,$4,$3-(-$5)}' track.xyzi > trackprofile.xyzd
	#find earthquakes >2 km below subduction interface
	awk '{if ($5>=2) print $1,$2,$4/40}' trackprofile.xyzd >./relocations.xym #below
	gmt plot relocations.xym -Sc -W0.7p,darkorange2@50
	#find earthquakes within <2 km depth of subduction interface	
	awk '{if ($5<2 && $5>-2) print $1,$2,$4/40}' trackprofile.xyzd >./relocations.xym #interface
	gmt plot relocations.xym -Sc -W0.7p,deepskyblue2@50
	#find earthquakes >2 km above subduction interface
	awk '{if ($5<=-2) print $1,$2,$4/40}' trackprofile.xyzd >./relocations.xym #above
	gmt plot relocations.xym -Sc -W0.7p,darkred@50

	#FOCAL MECHANISM
	echo 174.3287 -41.5957 21 233 75 162 6.6 0 0 | gmt psmeca -Sa0.25 -Gblack -Ewhite
	echo 174.1522 -41.7340 15 238 70 171 6.6 0 0 | gmt psmeca -Sa0.25 -Gblack -Ewhite

	gmt coast -W0.7p,black@50

	#SUBDUCTION INTERFACE
	gmt grdcontour $hiku_cwilliams -A10+u" km" -L-110/-3 -W1p,black@35,2_2:4p
	
	#LEGEND BOX
	gmt plot -Gwhite@50 <<-EOF
	172.1 -38.55 
	172.1 -39.05
	174.3 -39.05
	174.3 -38.55
	172.1 -38.55
	EOF
	
	#TEXT
	gmt text -F+j+f <<- EOF
	175.5 -38.25 CM 13p,Helvetica-Bold,black=~3p,white@30 North Island
	173.0 -41.70 CM 13p,Helvetica-Bold,black=~3p,white@30 South Island
	172.15 -38.65 LM 8p,Helvetica,darkorange2 >2 km below subduction interface
	172.15 -38.80 LM 8p,Helvetica,deepskyblue2 Within 2 km of subduction interface
	172.15 -38.95 LM 8p,Helvetica,darkred >2 km above subduction interface
	
	EOF
	
	gmt basemap -Bnwse
	gmt end

#CLEAN UP
rm -f track.xyz trackprofile.xyzd track.xyzi relocations.xym
