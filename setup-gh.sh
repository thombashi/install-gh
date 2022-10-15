#!/bin/sh

set -eu

SERVER="https://github.com"
REPO="cli/cli"
FALLBACK_GH_TAG="v2.15.0"

fetch_latest_tag_name() {
    RESULT_TAG_NAME=$(curl -fs https://api.github.com/repos/${REPO}/releases/latest | jq -r '.tag_name')
    # the curl call will be failed with empty return value if the GitHub API rate limit exceeded

    echo "${RESULT_TAG_NAME}"
}

check_tag_name() {
    if echo "$1" | \grep -qE "^v([0-9]+\.){2}[0-9]+$|^latest$"; then
        return 0
    fi

    echo "unexpected tag name found: $1" 1>&2
    return 2
}

if [ $(id -u) != 0 ]; then
    echo "please run as root" 1>&2
    exit 1
fi

if [ $# -ge 1 ]; then
    TAG_NAME=$1
else
    TAG_NAME=
fi

if [ -z "${TAG_NAME}" ] || [ "${TAG_NAME}" = "latest" ]; then
    TAG_NAME=$(fetch_latest_tag_name)
fi

if [ "$TAG_NAME" = "" ]; then
    # fall back to the default tag name
    TAG_NAME=${FALLBACK_GH_TAG}
fi

check_tag_name ${TAG_NAME}

GH_VERSION=$(echo ${TAG_NAME} | sed 's/^v//')

RELEASE_URL="${SERVER}/${REPO}/releases/download/${TAG_NAME}"
OS="linux"
ARCH=$(dpkg --print-architecture)
GH_BIN_FILE_PATH="gh_${GH_VERSION}_${OS}_${ARCH}/bin/gh"
TARBALL_FILENAME="gh_${GH_VERSION}_${OS}_${ARCH}.tar.gz"
CHECKSUMS_FILENAME="gh_${GH_VERSION}_checksums.txt"
INSTALL_DIR_PATH="/usr/local/bin"
CACHE_DIR_PATH="/var/cache/gh-installer"
CACHE_FILE_PATH="${CACHE_DIR_PATH}/${TARBALL_FILENAME}"

TMP_DIR=$(mktemp -d)
cd "${TMP_DIR}"
trap 'rm -rf ${TMP_DIR}' 0 1 2 3 15

if [ -f "${CACHE_FILE_PATH}" ]; then
    if gh version | \grep -qF "gh version ${GH_VERSION}"; then
        echo "gh ${GH_VERSION} already installed"
        exit 0
    fi

    echo "found local cache: ${TARBALL_FILENAME}"
    cp -a "${CACHE_FILE_PATH}" .
else
    # cache file not found: fetch the tarball file from the upstream
    curl -fL --progress-bar "${RELEASE_URL}/${TARBALL_FILENAME}" -o "${TARBALL_FILENAME}"
fi

echo "installing gh ${GH_VERSION} ..."
curl -fsSL "${RELEASE_URL}/${CHECKSUMS_FILENAME}" -o "${CHECKSUMS_FILENAME}"
\grep "$TARBALL_FILENAME" "${CHECKSUMS_FILENAME}" | sha256sum -c -

tar xzf "$TARBALL_FILENAME" "$GH_BIN_FILE_PATH"
$GH_BIN_FILE_PATH version
mv "$GH_BIN_FILE_PATH" "${INSTALL_DIR_PATH}/gh"

mkdir -p "${CACHE_DIR_PATH}"
cp -a "${TARBALL_FILENAME}" "${CACHE_FILE_PATH}"
