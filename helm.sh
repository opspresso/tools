#!/bin/bash

NAME="helm"

VERSION=${1}

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
    touch ${CONFIG}/${NAME}
    NOW=$(cat ${CONFIG}/${NAME} | xargs)

    if [ "${VERSION}" != "" ]; then
        NEW="${VERSION}"
    else
        STATUS=$(curl -sLI opspresso.github.io/${NAME}/LATEST | grep "HTTP" | grep "200" | wc -l | xargs)

        if [ "${STATUS}" != "0" ]; then
            NEW=$(curl -sL opspresso.github.io/${NAME}/LATEST | xargs)
        else
            NEW="latest"
        fi
    fi

    if [ "${NEW}" != "" ] && [ "${NEW}" != "${NOW}" ]; then
        echo "${NOW:-new} >> ${NEW}"

        VERSION="${NEW}"
    else
        VERSION=""
    fi
}

echo "================================================================================"
echo "# ${NAME} ${VERSION}..."

_prepare
_compare

if [ "${VERSION}" != "" ]; then
    if [ "${OS_NAME}" == "darwin" ]; then
        command -v helm > /dev/null || brew install helm
    else
        URL="https://storage.googleapis.com/kubernetes-helm/helm-${VERSION}-${OS_NAME}-amd64.tar.gz"
        curl -L ${URL} | tar xz
        sudo mv ${OS_NAME}-amd64/${NAME} /usr/local/bin/${NAME} && rm -rf ${OS_NAME}-amd64
    fi

    printf "${VERSION}" > ${CONFIG}/${NAME}
fi

helm version --client --short
