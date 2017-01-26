#!/bin/bash
#		GMT EXAMPLE 23
#		$Id: example_23.sh 16652 2016-06-28 21:02:26Z pwessel $
#
# Purpose:	Plot distances from Rome and draw shortest paths
# GMT modules:	grdmath, grdcontour, pscoast, psxy, pstext, grdtrack
# Unix progs:	echo, cat, awk
#
ps=example_23.ps

# Position and name of central point:

lon=12.50
lat=41.99
name="Rome"

# Calculate distances (km) to all points on a global 1x1 grid

gmt grdmath -Rg -I1 $lon $lat SDIST = dist.nc

# Location info for 5 other cities + label justification

cat << END > cities.d
105.87	21.02	HANOI		LM
282.95	-12.1	LIMA		LM
178.42	-18.13	SUVA		LM
237.67	47.58	SEATTLE		RM
28.20	-25.75	PRETORIA	LM
END

gmt pscoast -Rg -JH90/9i -Glightgreen -Sblue -A1000 -Dc -Bg30 \
	-B+t"Distances from $name to the World" -K -Wthinnest > $ps

gmt grdcontour dist.nc -A1000+v+u" km"+fwhite -Glz-/z+ -S8 -C500 -O -K -J \
	-Wathin,white -Wcthinnest,white,- >> $ps

# For each of the cities, plot great circle arc to Rome with gmt psxy

while read clon clat city; do
	(echo $lon $lat; echo $clon $clat) | gmt psxy -R -J -O -K -Wthickest,red >> $ps
done < cities.d

# Plot red squares at cities and plot names:
gmt psxy -R -J -O -K -Ss0.2 -Gred -Wthinnest cities.d >> $ps
$AWK '{print $1, $2, $4, $3}' cities.d | gmt pstext -R -J -O -K -Dj0.15/0 \
	-F+f12p,Courier-Bold,red+j -N >> $ps
# Place a yellow star at Rome
echo "$lon $lat" | gmt psxy -R -J -O -K -Sa0.2i -Gyellow -Wthin >> $ps

# Sample the distance grid at the cities and use the distance in km for labels

gmt grdtrack -Gdist.nc cities.d \
	| $AWK '{printf "%s %s %d\n", $1, $2, int($NF+0.5)}' \
	| gmt pstext -R -J -O -D0/-0.2i -N -Gwhite -W -C0.02i -F+f12p,Helvetica-Bold+jCT >> $ps

# Clean up after ourselves:

rm -f cities.d dist.nc
