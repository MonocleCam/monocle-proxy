#!/bin/bash -e
# *********************************************************************
#              __  __  ___  _  _  ___   ___ _    ___
#             |  \/  |/ _ \| \| |/ _ \ / __| |  | __|
#             | |\/| | (_) | .` | (_) | (__| |__| _|
#             |_|  |_|\___/|_|\_|\___/ \___|____|___|
#
#  -------------------------------------------------------------------
#         MONOCLE PROXY BUILD SCRIPT :: DOCKER CI IMAGES
#         COPYRIGHT SHADEBLUE, LLC @ 2018, ALL RIGHTS RESERVED
#  -------------------------------------------------------------------
#
# *********************************************************************
SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIRECTORY=$(dirname "${SCRIPTPATH}")
DOCKER_COMPOSE_FILE="${PROJECT_DIRECTORY}/docker/docker-compose.yml"

# --------------------------------------
# EXECUTE DOCKER-COMPILE BUILD
# --------------------------------------
docker-compose --file ${DOCKER_COMPOSE_FILE} build
docker-compose --file ${DOCKER_COMPOSE_FILE} push
