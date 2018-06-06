#!/bin/bash -e
# *********************************************************************
#              __  __  ___  _  _  ___   ___ _    ___
#             |  \/  |/ _ \| \| |/ _ \ / __| |  | __|
#             | |\/| | (_) | .` | (_) | (__| |__| _|
#             |_|  |_|\___/|_|\_|\___/ \___|____|___|
#
#  -------------------------------------------------------------------
#           MONOCLE PROXY DEPLOY SCRIPT :: MAC OSX (x64)
#         COPYRIGHT SHADEBLUE, LLC @ 2018, ALL RIGHTS RESERVED
#  -------------------------------------------------------------------
#
# *********************************************************************

# --------------------------------------
# DEFINE ENVIRONMENT VARIABLES
# --------------------------------------
export OS="osx"
export PLATFORM="x64"

# --------------------------------------
# DETERMINE DISTRIBUTION DIRECTORY
# --------------------------------------
#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR=$(readlink -f $0)
PROJECT_DIRECTORY=`dirname $DIR`
DIST_DIRECTORY=$PROJECT_DIRECTORY/dist

# --------------------------------------
# DETERMINE BUILD VERSION
# --------------------------------------
VERSION=`cat ${PROJECT_DIRECTORY}/VERSION`

# --------------------------------------
# DEPLOY BINARY ARTIFACTS TO MAVEN REPO
# --------------------------------------
curl -v \
     -X POST 'https://repo.shadeblue.com/service/rest/beta/components?repository=maven-releases' \
     -u ${SHADEBLUE_M2_REPO_USERNAME}:${SHADEBLUE_M2_REPO_PASSWORD}                              \
     -F maven2.generate-pom=true                                                                 \
     -F maven2.groupId=com.monoclecam                                                            \
     -F maven2.artifactId=monocle-proxy-${OS}-${PLATFORM}                                        \
     -F maven2.version=${VERSION}                                                                \
     -F maven2.packaging=tar.gz                                                                  \
     -F maven2.asset1=@$DIST_DIRECTORY/monocle-proxy-${OS}-${PLATFORM}.tar.gz                    \
     -F maven2.asset1.extension=tar.gz
