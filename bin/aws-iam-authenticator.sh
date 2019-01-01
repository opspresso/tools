#!/bin/bash

NAME="aws-iam-authenticator"

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

    if [ "${VERSION}" != "" ]; then
        NEW="${VERSION}"
    else
        NEW=$(curl -sL ${BUCKET}/latest/${NAME} | xargs)
    fi

    if [ "${NEW}" != "" ] && [ "${NEW}" != "${NOW}" ]; then
        printf '%-10s %-10s\n' "${NOW:-new}" "${NEW}"

        VERSION="${NEW}"
    else
        VERSION=""
    fi

    NOW="${NEW}"
}

echo "================================================================================"
echo "install ${NAME}..."

_prepare
_compare

if [ "${VERSION}" != "" ]; then
    URL="https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${VERSION}/heptio-authenticator-aws_${VERSION}_${OS_NAME}_amd64"
    curl -L -o ${TMP}/${NAME} ${URL}
    chmod +x ${TMP}/${NAME} && sudo mv ${TMP}/${NAME} /usr/local/bin/${NAME}

    printf "${VERSION}" > ${CONFIG}/${NAME}
fi

echo "${NOW}"