#!/bin/bash -e
# *********************************************************************
#              __  __  ___  _  _  ___   ___ _    ___
#             |  \/  |/ _ \| \| |/ _ \ / __| |  | __|
#             | |\/| | (_) | .` | (_) | (__| |__| _|
#             |_|  |_|\___/|_|\_|\___/ \___|____|___|
#
#  -------------------------------------------------------------------
#     MONOCLE PROXY BUILD SCRIPT :: RaspberryPi  (32-bit Hardfloat)
#         COPYRIGHT SHADEBLUE, LLC @ 2018, ALL RIGHTS RESERVED
#  -------------------------------------------------------------------
#
# *********************************************************************

# --------------------------------------
# DEFINE BUILD ENVIRONMENT VARIABLES
# --------------------------------------
export LIVE555_BUILD_PLATFORM="armlinux"
export OS="linux"
export PLATFORM="rpi"
export ARCH="arm"

# --------------------------------------
# DEFINE CROSS-COMPILER PREFIX
# --------------------------------------
MACHINE_TYPE=`uname -m`
if [ "${MACHINE_TYPE}" = "armv6l" ]; then
  export CROSS_COMPILE=""
elif [ "${MACHINE_TYPE}" = "armv7l" ]; then
  export CROSS_COMPILE=""
else
  export CROSS_COMPILE=$RPI_CROSS_COMPILE
fi

# --------------------------------------
# EXECUTE COMMON BUILD SCRIPT
# --------------------------------------
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
$SCRIPTPATH/build-common.sh