#!/bin/bash -e
# *********************************************************************
#              __  __  ___  _  _  ___   ___ _    ___
#             |  \/  |/ _ \| \| |/ _ \ / __| |  | __|
#             | |\/| | (_) | .` | (_) | (__| |__| _|
#             |_|  |_|\___/|_|\_|\___/ \___|____|___|
#
#  -------------------------------------------------------------------
#         MONOCLE PROXY BUILD SCRIPT :: ARMv8 (aarch64) 64-bit
#         COPYRIGHT SHADEBLUE, LLC @ 2018, ALL RIGHTS RESERVED
#  -------------------------------------------------------------------
#
# *********************************************************************

# --------------------------------------
# DEFINE BUILD ENVIRONMENT VARIABLES
# --------------------------------------
export LIVE555_BUILD_PLATFORM="armlinux"
export OS="linux"
export PLATFORM="arm64"
export ARCH="arm64"

# --------------------------------------
# DEFINE CROSS-COMPILER PREFIX
# --------------------------------------
export CROSS_COMPILE="aarch64-linux-gnu-"

# --------------------------------------
# EXECUTE COMMON BUILD SCRIPT
# --------------------------------------
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
$SCRIPTPATH/build-common.sh