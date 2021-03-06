#!/bin/bash

NAME="semver"

VERSION=${1:-3.0.0}

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
    # if [ "${OS_NAME}" == "darwin" ]; then
    #     command -v semver > /dev/null || brew install semver
    # else
        URL="https://github.com/fsaintjacques/semver-tool/archive/${VERSION}.zip"
        curl -sLO ${URL}
        unzip ${VERSION}.zip
        chmod +x semver-tool-${VERSION}/src/${NAME}
        sudo mv semver-tool-${VERSION}/src/${NAME} /usr/local/bin/${NAME}
        rm -rf ${VERSION}.zip semver-tool-${VERSION}
    # fi

    printf "${VERSION}" > ${CONFIG}/${NAME}
fi

semver --version
