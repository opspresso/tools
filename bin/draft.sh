#!/bin/bash

NAME=${1:-draft}

BUCKET="repo.opspresso.com"

OS_NAME="$(uname | awk '{print tolower($0)}')"

_prepare() {
    CONFIG=~/.config/opspresso/latest
    mkdir -p ${CONFIG} && touch ${CONFIG}/${NAME}

    TMP=/tmp/opspresso/tools
    mkdir -p ${TMP}

    _brew
}

_brew() {
    if [ "${OS_NAME}" == "darwin" ]; then
        command -v brew > /dev/null || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
}

_compare() {
    NOW=$(cat ${CONFIG}/${NAME} | xargs)
    NEW=$(curl -sL ${BUCKET}/latest/${NAME} | xargs)

    if [ "${NEW}" != "" ] && [ "${NEW}" != "${NOW}" ]; then
        printf '%-10s %-10s\n' "${NOW}" "${NEW}"

        VERSION="${NEW}"

        printf "${VERSION}" > ${CONFIG}/${NAME}
    fi
}

echo "================================================================================"
echo "install ${NAME}..."

_prepare
_compare

if [ "${VERSION}" != "" ]; then
    # if [ "${OS_NAME}" == "darwin" ]; then
    #     command -v draft > /dev/null || brew install draft
    # else
        URL="https://azuredraft.blob.core.windows.net/draft/draft-${VERSION}-${OS_NAME}-amd64.tar.gz"
        curl -L ${URL} | tar xz
        sudo mv ${OS_NAME}-amd64/${NAME} /usr/local/bin/${NAME} && rm -rf ${OS_NAME}-amd64
    # fi
fi

draft version --short | xargs | cut -d'+' -f1
