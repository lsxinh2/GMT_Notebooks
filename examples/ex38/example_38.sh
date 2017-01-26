#!/bin/bash
#               GMT EXAMPLE 38
#               $Id: example_38.sh 17012 2016-08-26 21:00:21Z pwessel $
#
# Purpose:      Illustrate histogram equalization on topography grids
# GMT modules:  psscale, pstext, makecpt, grdhisteq, grdimage, grdgradient
# Unix progs:   rm
#
ps=example_38.ps

gmt makecpt -Crainbow -T0/1700 > t.cpt
gmt makecpt -Crainbow -T0/15/1 > c.cpt
gmt grdgradient topo.nc -Nt1 -fg -A45 -Gitopo.nc
gmt grdhisteq topo.nc -Gout.nc -C16
gmt grdimage topo.nc -Iitopo.nc -Ct.cpt -JM3i -Y5i -K -P -B5 -BWSne > $ps
echo "315 -10 Original" | gmt pstext -Rtopo.nc -J -O -K -F+jTR+f14p -T -Gwhite -W1p -Dj0.1i >> $ps
gmt grdimage out.nc -Cc.cpt -J -X3.5i -K -O -B5 -BWSne >> $ps
echo "315 -10 Equalized" | gmt pstext -R -J -O -K -F+jTR+f14p -T -Gwhite -W1p -Dj0.1i >> $ps
gmt psscale -Dx0i/-0.4i+jTC+w5i/0.15i+h+e+n -O -K -Ct.cpt -Ba500 -By+lm >> $ps
gmt grdhisteq topo.nc -Gout.nc -N
gmt makecpt -Crainbow -T-3/3 > c.cpt
gmt grdimage out.nc -Cc.cpt -J -X-3.5i -Y-3.3i -K -O -B5 -BWSne >> $ps
echo "315 -10 Normalized" | gmt pstext -R -J -O -K -F+jTR+f14p -T -Gwhite -W1p -Dj0.1i >> $ps
gmt grdhisteq topo.nc -Gout.nc -N
gmt grdimage out.nc -Cc.cpt -J -X3.5i -K -O -B5 -BWSne >> $ps
echo "315 -10 Quadratic" | gmt pstext -R -J -O -K -F+jTR+f14p -T -Gwhite -W1p -Dj0.1i >> $ps
gmt psscale -Dx0i/-0.4i+w5i/0.15i+h+jTC+e+n -O -Cc.cpt -Bx1 -By+lz >> $ps
rm -f itopo.nc out.nc ?.cpt
