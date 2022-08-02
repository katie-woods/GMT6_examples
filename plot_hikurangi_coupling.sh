#!/bin/bash

#Bash GMT6 script to plot Hikurangi geodetic coupling model. Katie Woods 2 Aug 2022

#FILE PATHS
interseismic='files/hikurangi_flt_atr.gmt' #Wallace et al. (2012)
oldnodes='files/ansell_bannister_1996_geometry.txt' #Ansell and Bannister (1996)
pre2014_SSE='files/filter_SSE2002_2014.grd' #Wallace (2020)
intersse='files/isse_flt_atr.gmt' #Wallace et al. (2012)
wair_SSE='files/c10a_info.out'
coup_pal='colour_palettes/rwb.cpt'

#MAKE COLOUR PALETTE
gmt makecpt -C$coup_pal -T0/1/0.1 -A20 > coup.cpt 

#COMMANDS TO PLOT COASTLINE, INTERFACE, SSE CONTOURS, COUPLING MODEL (same for both subplots)
plot_coast=`echo gmt coast -Lg173.2/-39.9+w100+c173/-38.9 -W0.7p,gray39 -Ggray89 -Sgray89 --FONT_ANNOT_PRIMARY=8p`
plot_nodes=`echo gmt plot $oldnodes -W0.7p,midnightblue@45,3_1:2p`
plot_SSE_cont=`echo gmt grdcontour $pre2014_SSE -C+100 -S4 -W1p,black@50`
plot_wairarapa_SSE=`echo gmt contour -W0.7p,black,- -C10`
plot_coupling=`echo gmt plot -W0.7p,white@100 -L -Ccoup.cpt`

#MAP SETTINGS
reg='-Rd172/180/-42.5/-37'
proj='-JM3i'

#PLOT FIGURE
gmt begin figures/hikurangi_coupling_model pdf
	gmt set MAP_FRAME_PEN 0.7p,black MAP_FRAME_TYPE plain FONT_ANNOT_PRIMARY 10p,black FONT_ANNOT_SECONDARY 8p,black FONT_LABEL 8p,black
	
	###########################
	#INTERSEISMIC COUPLING PLOT
	#BASEMAP
	gmt basemap $reg $proj -BNsWe -Ba2f1 
	$plot_coast
	
	#COUPLING
	awk '{ if ($1 ==">") print $1,$2$5; else print $1,$2 }' $interseismic | $plot_coupling
	
	gmt coast -Df -W0.7p,gray59
	
	#SSE OUTLINE AND INTERFACE
	$plot_SSE_cont
	$plot_nodes	
    cat $wair_SSE | cut -c15-140 | awk '{if ($1 > 100) print $1,$2,$12}' | $plot_wairarapa_SSE
	
	#TEXT
	gmt text -F+j+a+f <<-EOF
	174.25 -40.27 CM 0 7p,Helvetica,black=~2p,white Kapiti
	174.25 -40.47 CM 0 7p,Helvetica,black=~2p,white  SSEs
	175.65 -39.32 CM 0 7p,Helvetica,black=~2p,white  Manawatu
	175.65 -39.51 CM 0 7p,Helvetica,black=~2p,white  SSEs
	177.10 -38.85 CM 0 7p,Helvetica,black=~2p,white  East
	177.10 -39.07 CM 0 7p,Helvetica,black=~2p,white  Coast
	177.10 -39.30 CM 0 7p,Helvetica,black=~2p,white   SSEs
	173.90 -38.50 CM 0 8p,Helvetica-Bold,black Interseismic coupling
	178.50 -41.33 CM 0 7p,Helvetica,black Coupling coefficient
	173.40 -40.97 RM 35 5p,Helvetica,black 70 km
	173.40 -41.28 RM 35 5p,Helvetica,black 50 km
	173.40 -41.65 RM 35 5p,Helvetica,black 35 km
	173.50 -41.85 RM 35 5p,Helvetica,black 27 km
	174.05 -41.85 RM 35 5p,Helvetica,black 20 km
	174.48 -41.78 RM 35 5p,Helvetica,black 15 km
	174.70 -41.80 RM 35 5p,Helvetica,black 12 km
	174.95 -41.80 RM 35 5p,Helvetica,black 9 km
	175.18 -41.85 RM 35 5p,Helvetica,black 6 km
	175.88 -41.85 RM 30 5p,Helvetica,black 3 km
	EOF
	
	#SCALE
	gmt psscale -Ba1f0.1 -Ccoup.cpt -Dg177.6/-41.8+w0.7i/0.14i+h --FONT_ANNOT_PRIMARY=8p
	gmt basemap -Bnswe

	###########################
	#INTER-SSE COUPLING PLOT
	#BASEMAP
	gmt basemap $reg $proj -BsNwE -Ba2f1 -X3.4i
	$plot_coast
	
	#COUPLING
	awk '{ if ($1 ==">") print $1,$2$5; else print $1,$2 }' $intersse | $plot_coupling
	gmt coast -Df -W0.7p,gray59
	
	#SSE OUTLINE AND INTERFACE
	$plot_SSE_cont
	$plot_nodes	
    cat $wair_SSE | cut -c15-140 | awk '{if ($1 > 100) print $1,$2,$12}' | $plot_wairarapa_SSE
	
	#TEXT
	gmt text -F+j+a+f <<-EOF
	174.25 -40.27 CM 0 7p,Helvetica,black=~2p,white Kapiti
	174.25 -40.47 CM 0 7p,Helvetica,black=~2p,white  SSEs
	175.65 -39.32 CM 0 7p,Helvetica,black=~2p,white  Manawatu
	175.65 -39.51 CM 0 7p,Helvetica,black=~2p,white  SSEs
	177.10 -38.85 CM 0 7p,Helvetica,black=~2p,white  East
	177.10 -39.07 CM 0 7p,Helvetica,black=~2p,white  Coast
	177.10 -39.30 CM 0 7p,Helvetica,black=~2p,white   SSEs
	173.90 -38.50 CM 0 8p,Helvetica-Bold,black Inter-SSE coupling
	178.50 -41.33 CM 0 7p,Helvetica,black Coupling coefficient
	173.40 -40.97 RM 35 5p,Helvetica,black 70 km
	173.40 -41.28 RM 35 5p,Helvetica,black 50 km
	173.40 -41.65 RM 35 5p,Helvetica,black 35 km
	173.50 -41.85 RM 35 5p,Helvetica,black 27 km
	174.05 -41.85 RM 35 5p,Helvetica,black 20 km
	174.48 -41.78 RM 35 5p,Helvetica,black 15 km
	174.70 -41.80 RM 35 5p,Helvetica,black 12 km
	174.95 -41.80 RM 35 5p,Helvetica,black 9 km
	175.18 -41.85 RM 35 5p,Helvetica,black 6 km
	175.88 -41.85 RM 30 5p,Helvetica,black 3 km
	EOF
	
	#SCALE
	gmt psscale -Ba1f0.1 -Ccoup.cpt -Dg177.6/-41.8+w0.7i/0.14i+h --FONT_ANNOT_PRIMARY=8p
	gmt basemap -Bnswe

gmt end


#################
#CLEAN UP
rm coup.cpt
