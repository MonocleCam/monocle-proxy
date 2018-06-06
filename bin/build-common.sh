#!/bin/bash -e
# *********************************************************************
#              __  __  ___  _  _  ___   ___ _    ___
#             |  \/  |/ _ \| \| |/ _ \ / __| |  | __|
#             | |\/| | (_) | .` | (_) | (__| |__| _|
#             |_|  |_|\___/|_|\_|\___/ \___|____|___|
#
#  -------------------------------------------------------------------
#         MONOCLE PROXY BUILD SCRIPT :: Common Build Script
#         COPYRIGHT SHADEBLUE, LLC @ 2018, ALL RIGHTS RESERVED
#  -------------------------------------------------------------------
#
# *********************************************************************

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# NOTE:   THIS BUILD SCRIPT SHOUlD NOT BE CALLED DIRECTLY, BUT RATHER
#         INVOKED FROM ONE OF THE PLATFORM SPECIFIC BUILD SCRIPTS
#
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# Works on both linux and Mac OS X.
function read-link() {
    local path=$1
    if [ -d $path ] ; then
        local abspath=$(cd $path; pwd)
    else
        local prefix=$(cd $(dirname -- $path) ; pwd)
        local suffix=$(basename $path)
        local abspath="$prefix/$suffix"
    fi
    echo $abspath
}

SCRIPT=$(read-link $0)
SCRIPTS_DIRECTORY=`dirname $SCRIPT`
PROJECT_DIRECTORY=$(dirname "$SCRIPTS_DIRECTORY")
TARGET_DIRECTORY="$PROJECT_DIRECTORY/target"
SOURCE_DIRECTORY="$PROJECT_DIRECTORY/src"
DISTRIBUTION_DIRECTORY="$PROJECT_DIRECTORY/dist"

echo "********************************************************************************************"
echo "BUILD FOR OS       : $OS"
echo "BUILD FOR PLATFORM : $PLATFORM"
echo "BUILD FOR ARCH     : $ARCH"
echo "LIVE555 PLATFORM   : $LIVE555_BUILD_PLATFORM"
echo "CROSS COMPILER     : $CROSS_COMPILE"
echo "********************************************************************************************"
echo "PROJECT DIR        : $PROJECT_DIRECTORY"
echo "SCRIPTS DIR        : $SCRIPTS_DIRECTORY"
echo "TARGET DIR         : $TARGET_DIRECTORY"
echo "SOURCE  DIR        : $SOURCE_DIRECTORY"
echo "DIST DIR           : $DISTRIBUTION_DIRECTORY"
echo "********************************************************************************************"

# CREATE DIRECTORIES
mkdir -p $DISTRIBUTION_DIRECTORY
mkdir -p $TARGET_DIRECTORY

# COPY SOURCE FILE TO WORKING TARGET DIRECTORY
cp -R $SOURCE_DIRECTORY/* $TARGET_DIRECTORY
cd $TARGET_DIRECTORY

# GENERATE MAKE FILES FOR THIS TARGET PLATFORM
chmod +x genMakefiles
./genMakefiles $LIVE555_BUILD_PLATFORM

# MAKE LIVE555 LIBRARIES, UTILITIES AND MONOCLE-PROXY
make clean all

# COMPRESS LIVE-555 PROXY SERVER EXECUTABLE FOR DISTRIBUTION
cd $TARGET_DIRECTORY/proxyServer
tar -zcvf live555ProxyServer.tar.gz live555ProxyServer
cp live555ProxyServer.tar.gz $DISTRIBUTION_DIRECTORY/live555ProxyServer-$OS-$PLATFORM.tar.gz

# COMPRESS LIVE-555 OPEN RTSP UTILITY EXECUTABLE FOR DISTRIBUTION
cd $TARGET_DIRECTORY/testProgs
tar -zcvf openRTSP.tar.gz openRTSP
cp openRTSP.tar.gz $DISTRIBUTION_DIRECTORY/openRTSP-$OS-$PLATFORM.tar.gz

# COMPRESS MONOCLE-PROXY EXECUTABLE FOR DISTRIBUTION
cd $TARGET_DIRECTORY/monocle-proxy
tar -zcvf monocle-proxy.tar.gz monocle-proxy
cp monocle-proxy.tar.gz $DISTRIBUTION_DIRECTORY/monocle-proxy-$OS-$PLATFORM.tar.gz

echo "****************************************************************************"
echo "DISTRIBUTION FILES"
echo "****************************************************************************"
tree $DISTRIBUTION_DIRECTORY
