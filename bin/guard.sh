#!/bin/bash

NAME="guard"

VERSION=${1}

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

    if [ "${NEW}" != "" ] && [ "${NEW}" != "${NOW}" ] && [ "${VERSION}" == "" ]; then
        printf '%-10s %-10s\n' "${NOW:-new}" "${NEW}"

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
    #     command -v guard > /dev/null || brew install guard
    # else
        URL="https://github.com/appscode/guard/releases/download/${VERSION}/guard-${OS_NAME}-amd64"
        curl -L -o ${TMP}/${NAME} ${URL}
        chmod +x ${TMP}/${NAME} && sudo mv ${TMP}/${NAME} /usr/local/bin/${NAME}
    # fi
fi

guard version 2>&1 | grep 'Version ' | xargs | awk '{print $3}'
