#!/bin/bash -e
# *********************************************************************
#              __  __  ___  _  _  ___   ___ _    ___
#             |  \/  |/ _ \| \| |/ _ \ / __| |  | __|
#             | |\/| | (_) | .` | (_) | (__| |__| _|
#             |_|  |_|\___/|_|\_|\___/ \___|____|___|
#
#  -------------------------------------------------------------------
#           MONOCLE PROXY BUILD SCRIPT :: LINUX (x86)
#         COPYRIGHT SHADEBLUE, LLC @ 2018, ALL RIGHTS RESERVED
#  -------------------------------------------------------------------
#
# *********************************************************************

# --------------------------------------
# DEFINE BUILD ENVIRONMENT VARIABLES
# --------------------------------------
export LIVE555_BUILD_PLATFORM="linux"
export OS="linux"
export PLATFORM="x86"
export ARCH="x86"

# --------------------------------------
# DEFINE COMPILER ENVIRONMENT VARIABLES
# --------------------------------------
# configure compilers and linkers for 32-bits
# (using multilib on an x64 linux image)
export CFLAGS="-m32"
export CXXFLAGS="-m32"
export LDFLAGS="-m32"

# --------------------------------------
# EXECUTE COMMON BUILD SCRIPT
# --------------------------------------
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
$SCRIPTPATH/build-common.sh