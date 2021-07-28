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

DOCKER_IMAGE="sabdelkader/aosp"
DEFAULT_DOCKER_TAG="latest"
DEFAULT_DOCKER_FILE=1
BUILD_ALL=0

while getopts "ia" OPTION
do
  case "$OPTION" in
    "i")
      DOCKER_IMAGE=$2
      shift 1
      ;;
    "a")
      BUILD_ALL=1
      DEFAULT_DOCKER_FILE=0
      shift 1
      ;;
  esac
done

pushd ${SCRIPT_ROOT}

# Build the default container, unless otherwise instructed
if [ "$BUILD_ALL" -eq "0" ]
then
  DOCKER_TAGS=( ${DEFAULT_DOCKER_TAG} )

  echo "Using image: \"${DOCKER_IMAGE}:${DEFAULT_DOCKER_TAG}\""
else
  DOCKER_TAGS=$(ls -1 Dockerfile-* | cut -d "-" -f 2,3,4,5)
fi

for DOCKER_TAG in ${DOCKER_TAGS[@]}
do
  if [ "$DEFAULT_DOCKER_FILE" -eq "0" ]
  then
    DOCKER_FILE="Dockerfile-${DOCKER_TAG}"
  else
    DOCKER_FILE="Dockerfile"
  fi

  echo "Building: ${DOCKER_TAG} from ${DOCKER_FILE} in ${SCRIPT_ROOT}"
  docker image rm ${DOCKER_IMAGE}:${DOCKER_TAG} -f &> /dev/null || echo ""
  docker build --build-arg "DOCKER_USER=builder" --build-arg "DOCKER_USER_HOME=/home/builder" --build-arg "DOCKER_USER_ID=$(id -u $(whoami))" --build-arg "DOCKER_GROUP_ID=$(id -g $(whoami))" -t ${DOCKER_IMAGE}:${DOCKER_TAG} . -f ${SCRIPT_ROOT}/${DOCKER_FILE}
  echo "System: $(docker run ${DOCKER_IMAGE}:${DOCKER_TAG} bash -c "cat /etc/os-release && uname -a")"
  echo ""
  echo "GCC Version: "
  docker run ${DOCKER_IMAGE}:${DOCKER_TAG} bash -c "gcc --version"
  echo ""
  echo "Java Compiler Version: "
  docker run ${DOCKER_IMAGE}:${DOCKER_TAG} bash -c "javac -version"
  echo ""
done
