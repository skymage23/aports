#!/usr/bin/env bash
VERSION_DIR=".version_numbers"
ISO_DIR="/home/cnugent/iso"
EXPORT_DIR="/mnt/iso-export"

function usage {
   echo "${0} (OPTIONS) PROFILE"
   echo "Options:"
   echo "-a | --architecture:   Sets the CPU architecture for the ISO. Defaults to \"x86_64\""
   echo "-b | --block_append:   Blocks version number appending. Use this if you do not want the version to change."
   echo "-f | --force:          Forces the generation of the ISO even if it already exists."
   echo "-e | --export:         Copies the ISO file (generated or already existing) to the export directory."
   echo "-h | --help:           Display this help message."
}


if [[ ! -d ${VERSION_DIR} ]]; then
    mkdir ${VERSION_DIR}
fi

if [[ $# -gt 3 ]]; then
    >&2 echo "Too many arguments."
    usage
    exit 1
fi

PROFILE="vbridge_dev_env"
BLOCK_APPEND=0
FORCE=0
ARCH="x86_64" #Maybe add something here to set the default to the host arch?
EXPORT=0
for var in $@; do
    case $var in
	-a | --architecture )
		shift
		ARCH=${1}
		shift
		;;
        -b | --block_append )
                    BLOCK_APPEND=1
    	    ;;

	-f | --force )
                    FORCE=1
		    ;;
        -h | --help )
                    usage
		    exit 0
		;;
	-e | --export )
                    EXPORT=1
		;;
        *)
    	    PROFILE=$var
    	    ;;
    esac
done


#BLOCK_APPEND is ignored if this is the first version.
VERSIONING_FILE="${VERSION_DIR}/${PROFILE}-${ARCH}-version.txt"
CURRENT_VERSION=0

#Making this program "stupid" for now.
if [[  -e "${VERSIONING_FILE}" ]]; then
    #No sanity checking. User beware.
    read -r CURRENT_VERSION < "${VERSIONING_FILE}"
else
   #Create the file and set the version to 0.
   echo 0 > "${VERSIONING_FILE}"
fi

if [[ ${CURRENT_VERSION} -eq 0 ]] || [[ ${BLOCK_APPEND} -eq 0 ]]; then
    CURRENT_VERSION=$((CURRENT_VERSION + 1))
    echo "${CURRENT_VERSION}" > "${VERSIONING_FILE}"
fi


#Alpine iso naming convention:
#alpine-<PROFILE>-<TAG>-<ARCH>.iso
TAG="v${CURRENT_VERSION}"
ISO_FILENAME="alpine-${PROFILE}-${TAG}-${ARCH}.iso"
ISO_PATH="${ISO_DIR}/${ISO_FILENAME}"
if [[ ! -e "${ISO_PATH}" ]] || [[ ${FORCE} -eq 1 ]]; then
    ./mkimage.sh --profile "${PROFILE}" \
    --arch "${ARCH}" \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    --outdir ${ISO_DIR} \
    --tag "${TAG}"
fi

if [[ -f  "${ISO_PATH}" ]] && [[ ${EXPORT} -eq 1 ]]; then
    cp "${ISO_PATH}" "${EXPORT_DIR}"
fi
