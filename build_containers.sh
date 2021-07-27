#!/usr/bin/env bash
SCRIPT_ROOT=$(dirname "${BASH_SOURCE[0]}")

for ARG in "$@"
do
  shift
  case $ARG in
    "--image")
      DOCKER_IMAGE=$2
      shift 2
      ;;
    *)
      set -- "$@" "$ARG"
      ;;
  esac
done

DOCKER_IMAGE=""

while getopts "i" OPTION
do
  case "$OPTION" in
    "i")
      DOCKER_IMAGE=$2
      shift 2
    ;;
  esac
done

if [ -n "${DOCKER_IMAGE}" ]
then 
  echo "Using image: \"${DOCKER_IMAGE}\""
else
  echo "Specify a docker image to use with [--image|-i]"
  exit -1;
fi

pushd ${SCRIPT_ROOT}

DOCKER_TAGS=$(ls -1 Dockerfile-* | cut -d "-" -f 2 -f 3 -f 4 -f 5)

for DOCKER_TAG in ${DOCKER_TAGS[@]}
do
  DOCKER_FILE="Dockerfile-${DOCKER_TAG}"

  echo "Building: ${DOCKER_TAG} from ${DOCKER_FILE} in ${SCRIPT_ROOT}"
  docker image rm ${DOCKER_IMAGE}:${DOCKER_TAG} -f || echo ""
  docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} . -f ${SCRIPT_ROOT}/${DOCKER_FILE}
  echo "System: $(docker run ${DOCKER_IMAGE}:${DOCKER_TAG} bash -c "cat /etc/os-release && uname -a")"
  echo "GCC Version: $(docker run ${DOCKER_IMAGE}:${DOCKER_TAG} gcc --version)"
  echo ""
  echo ""
done
