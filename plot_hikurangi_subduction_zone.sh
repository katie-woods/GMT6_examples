#!/bin/bash

#Bash GMT6 script to plot Hikurangi subduction zone. Katie Woods 2 Aug 2022


#FILE PATHS
bathy_grd='files/nzbathy_2016.nc' #NIWA 2016 topo
topo_cpt='colour_palettes/europe_3.cpt'
bathy_cpt='colour_palettes/dense.cpt'
community_fault_model='files/community_fault_model.txt' #Seebeck et al. (2022)
front='files/hikurangi_deformation_front_xy.csv' #Barnes et al. (2010, 2018, 2020), Collot et al. (2001), Crutchley et al. (2020)
pre2014_SSE='files/filter_SSE2002_2014.grd' #Wallace (2020)
onshore_sites='data_examples/stations_gnss.txt' #GeoNet station locations
hiku_cwilliams='files/grid_exclude_wgs84.grd' #updated version of Williams et al. (2013) from Charles Williams on 6 Dec 2018
topo_bathy='colour_palettes/topo_bathy.cpt' #created by merging together th topo.cpt and bathy.cpt files generated in this script

#MAP SETTINGS
proj='-JM6i'
reg='-Rd172/180/-42/-36.5'

#MAKE COLOUR PALETTES
gmt makecpt -C$topo_cpt -T0/2000/200 > topo.cpt
gmt makecpt -C$bathy_cpt -T-4500/0/500 -I > bathy.cpt 
gmt grdgradient $bathy_grd -GtopoI.grd -A90 -N4
gmt grdgradient $bathy_grd -GbathyI.grd -A0 -N4

#FIGURE
gmt begin figures/hikurangi_subduction_zone pdf
	
	#SET DEFAULTS
	gmt set MAP_FRAME_PEN=0.7p,black MAP_FRAME_TYPE=plain FONT_ANNOT_PRIMARY=13p,black
	
	#CREATE BASEMAP WITH BATHYMETRY AND TOPOGRAPHY
	gmt basemap $reg $proj -BnWSe -Ba2f1 
	gmt grdimage $bathy_grd -IbathyI.grd -Cbathy.cpt
	gmt coast -Gc
	gmt grdimage $bathy_grd -ItopoI.grd -Ctopo.cpt
	gmt coast -Q
	
	#COASTLINE, fading bathy/topo and filling lakes white
	gmt coast -W0.7p,gray39 -Gwhite@80 -Swhite@80 -Lg173.5/-38.3+w50+c173.5/-38.3 -Df -Cl/white
	
	#COMMUNITY FAULT MODEL
	gmt plot $community_fault_model -W1p,black@70
	
	#GNSS STATION LOCATIONS
	awk '{print $1,$2}' $onshore_sites | gmt plot -St0.15 -Gblack 
	
	#2002-2014 SSE OUTLINE
	gmt grdcontour $pre2014_SSE -C+100 -S4 -W1p,darkred@20 -Ncolour_palettes/contour2.cpt
	
	#SUBDUCTION INTERFACE
	gmt grdcontour $hiku_cwilliams -A10+u" km" -L-110/-3 -W1p,black@35,2_2:4p
	
	#HIKURANGI DEFORMATION FRONT
	gmt plot $front -Sf0.5i/0.15+l+t -W1.5p,white -Gwhite
	
	#TEXT
	gmt text -F+j+f <<- EOF
	175.9 -38.10 CM 13p,Helvetica-Bold,black=~3p,white@30 North Island
	173.1 -41.70 CM 13p,Helvetica-Bold,black=~3p,white@30 South Island
	173.5 -37.50 CM 10p,Helvetica-Bold,blue=~3p,white@30 AUSTRALIAN
	173.5 -37.70 CM 10p,Helvetica-Bold,blue=~3p,white@30 PLATE
	179.3 -41.20 CM 10p,Helvetica-Bold,blue=~3p,white@30 PACIFIC
	179.3 -41.40 CM 10p,Helvetica-Bold,blue=~3p,white@30 PLATE
	177.8 -39.50 CM 8p,Helvetica,darkred=~3p,white@30 East coast
	177.8 -39.65 CM 8p,Helvetica,darkred=~3p,white@30 SSEs
	174.3 -40.85 CM 8p,Helvetica,darkred=~3p,white@30 Kapiti
	174.3 -41.00 CM 8p,Helvetica,darkred=~3p,white@30 SSEs
	175.9 -39.80 CM 8p,Helvetica,darkred=~3p,white@30 Manawatu
	175.9 -39.95 CM 8p,Helvetica,darkred=~3p,white@30 SSEs
	EOF
	
	#COLOUR SCALE
	gmt psscale -Dg172.5/-40.2+w1i/0.1i -C$topo_bathy -W0.001 -Baf+l"Elevation (km)" --FONT_LABEL=10p --FONT_ANNOT_PRIMARY=10p

	
	gmt basemap -Bnwse
	gmt end

#CLEAN UP
rm -f topo.cpt bathy.cpt bathyI.grd topoI.grd
