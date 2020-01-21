#!/bin/bash -e
# *********************************************************************
#              __  __  ___  _  _  ___   ___ _    ___
#             |  \/  |/ _ \| \| |/ _ \ / __| |  | __|
#             | |\/| | (_) | .` | (_) | (__| |__| _|
#             |_|  |_|\___/|_|\_|\___/ \___|____|___|
#
#  -------------------------------------------------------------------
#           MONOCLE PROXY BUILD SCRIPT :: LINUX (x64)
#         COPYRIGHT SHADEBLUE, LLC @ 2018, ALL RIGHTS RESERVED
#  -------------------------------------------------------------------
#
# *********************************************************************

# --------------------------------------
# DEFINE BUILD ENVIRONMENT VARIABLES
# --------------------------------------
export LIVE555_BUILD_PLATFORM="linux"
export OS="alpine"
export PLATFORM="x86"
export ARCH="x86"

# --------------------------------------
# EXECUTE COMMON BUILD SCRIPT
# --------------------------------------
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
$SCRIPTPATH/build-common.sh