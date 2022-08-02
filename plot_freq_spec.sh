#!/bin/bash

#Bash GMT6 script to plot frequency spectra. Katie Woods 2 Aug 2022

#FILE PATHS
data='data_examples/GNS18-3_deep_spectra.txt'

#MAP SETTINGS
proj='-JX1.7il/1.5il'
reg='-R2/300/10e-4/10e3'

gmt begin figures/freq_spec pdf
	
	#DEFAULTS
	gmt set MAP_GRID_PEN=gray79 FONT_ANNOT_PRIMARY=9p
	
	#BASEMAP
	gmt psbasemap $reg $proj -BSWen -Bxg3a1f3  -Bya-2f1g1p
	
	#FREQ SPEC, data colours are defined on header lines of $data
	gmt plot $data -W0.7p
	
	#LEGEND
	gmt plot -W0.7p,black <<- EOF
	8 0.2
	11 0.2
	EOF
	gmt plot -W0.7p,purple <<- EOF
	8 0.03
	11 0.03
	EOF
	gmt plot -W0.7p,gray64 <<- EOF
	8 0.005
	11 0.005
	EOF
	gmt text -F+f9p+jLM <<- EOF
	13 0.2 Observation
	13 0.03 Deep Reference
	13 0.005 Obs - Reference
	EOF
	
	#LABELS
	gmt text -F+f+j+a -N <<-EOF
	25 0.00003 9p CM 0 Period (days)
	0.5 5 9p CM 90 Power (hPa@+2@+)
	2 0.00015 9p CM 0 2
	300 0.00015 9p CM 0 300
	2.3 3500 13p,Helvetica-Bold LM 0 a
	2.5 60000 11p,Helvetica-Bold LM 0 GNS18-3
	EOF
gmt end
