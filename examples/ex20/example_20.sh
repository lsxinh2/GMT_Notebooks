#!/bin/bash
#		GMT EXAMPLE 20
#		$Id: example_20.sh 16652 2016-06-28 21:02:26Z pwessel $
#
# Purpose:	Extend GMT to plot custom symbols
# GMT modules:	pscoast, psxy
# Unix progs:	rm
#
# Plot a world-map with volcano symbols of different sizes
# on top given locations and sizes in hotspots.d
ps=example_20.ps

cat > hotspots.d << END
55.5	-21.0	0.25
63.0	-49.0	0.25
-12.0	-37.0	0.25
-28.5	29.34	0.25
48.4	-53.4	0.25
155.5	-40.4	0.25
-155.5	19.6	0.5
-138.1	-50.9	0.25
-153.5	-21.0	0.25
-116.7	-26.3	0.25
-16.5	64.4	0.25
END

gmt pscoast -Rg -JR9i -Bx60 -By30 -B+t"Hotspot Islands and Cities" -Gdarkgreen -Slightblue \
	-Dc -A5000 -K > $ps

gmt psxy -R -J hotspots.d -Skvolcano -O -K -Wthinnest -Gred >> $ps

# Overlay a few bullseyes at NY, Cairo, and Perth

cat > cities.d << END
286	40.45	0.8
31.15	30.03	0.8
115.49	-31.58	0.8
END

gmt psxy -R -J cities.d -Skbullseye -O >> $ps

rm -f hotspots.d cities.d
