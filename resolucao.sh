#!/bin/sh

###-> Type into your terminal:

# $ sudo cvt 1366 768 

###-> It will output something similar to.

# $ 1366x768 59.88 Hz (CVT) hsync: 47.79 kHz; pclk: 85.25 MHz
#   Modeline "1366x768_60.00"   85.25  1368 1440 1576 1784  768 771 781 798 -hsync +vsync

###-> Yours may be different then What I have so copy the text from the terminal everything after Modeline
###-> The next step you will need to use everything after the Modeline. e.g.:

# $ sudo xrandr --newmode "1366x768_60.00"   74.50  1280 1344 1472 1664  720 723 728 748 -hsync +vsync

###-> The finale step is to add the new resolution to the VGA1 as so 

# $ sudo xrandr --addmode VGA-1 1366x768_60.00

###-> That should give you the resolution you want for the T.V.
###-> To keep the settings after restart use the answer here with your settings and you won't have to redo them

sudo xrandr --newmode "1368x768_60.00"   85.25  1368 1440 1576 1784  768 771 781 798 -hsync +vsync
sudo xrandr --addmode VGA-0 1368x768_60.00

