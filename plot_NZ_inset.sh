#!/bin/bash

#Bash GMT6 script to plot NZ inset map. Katie Woods 2 Aug 2022

#FILE PATHS
tectonics=files/PB2002_boundaries.gmt

#MAP SETTINGS
proj='-JM2.2i'
reg='-R130/200/-55/-10'

# PLOT FIGURE (can choose pdf png eps, etc)
gmt begin figures/NZ_inset pdf
	
	#DEFAULTS
	gmt set MAP_FRAME_PEN=0.7p,black MAP_FRAME_TYPE=plain

	#COASTLINE
	gmt coast $proj $reg -Wblack -Swhite -Ggray69 -Dl -Bnswe

	#FAULTS
	gmt plot $tectonics -W0.9p,blue

	#STUDY AREA BOX
	gmt plot -W0.9p,red <<- EOF
	170.0 -43
	180.0 -43
	180.0 -36
	170.0 -36
	170.0 -43
	EOF
	
	#TEXT
	gmt text -F+f+a+j <<- EOF
	189 -20 5.5p,Helvetica,blue 78 CM Tonga
	186 -30 5.5p,Helvetica,blue 75 CM Kermadec
	182 -40 5.5p,Helvetica,blue 70 CM Hikurangi
	166 -29 8p,Helvetica-Bold,black 0 CM AUSTRALIAN
	166 -32 8p,Helvetica-Bold,black 0 CM PLATE
	186 -49 8p,Helvetica-Bold,black 0 CM PACIFIC
	186 -51.3 8p,Helvetica-Bold,black 0 CM PLATE
	EOF
	
gmt end
