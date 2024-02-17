#!/usr/bin/env sh

set -x

###############################################################################
# Files                                                                       #
###############################################################################

# sort directories before files
gsettings set org.gtk.Settings.FileChooser sort-directories-first true
