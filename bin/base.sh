#!/bin/bash

OS_NAME="$(uname | awk '{print tolower($0)}')"
OS_FULL="$(uname -a)"

if [ "${OS_NAME}" == "linux" ]; then
    if [ $(echo "${OS_FULL}" | grep -c "amzn1") -gt 0 ]; then
        OS_TYPE="yum"
    elif [ $(echo "${OS_FULL}" | grep -c "amzn2") -gt 0 ]; then
        OS_TYPE="yum"
    elif [ $(echo "${OS_FULL}" | grep -c "el6") -gt 0 ]; then
        OS_TYPE="yum"
    elif [ $(echo "${OS_FULL}" | grep -c "el7") -gt 0 ]; then
        OS_TYPE="yum"
    elif [ $(echo "${OS_FULL}" | grep -c "Ubuntu") -gt 0 ]; then
        OS_TYPE="apt"
    elif [ $(echo "${OS_FULL}" | grep -c "coreos") -gt 0 ]; then
        OS_TYPE="apt"
    fi
elif [ "${OS_NAME}" == "darwin" ]; then
    OS_TYPE="brew"
fi

echo "================================================================================"
echo "${OS_NAME} [${OS_TYPE}]"

if [ "${OS_TYPE}" == "" ]; then
    echo "Not supported OS. [${OS_NAME}]"
    exit 1
fi

# brew for mac
if [ "${OS_TYPE}" == "brew" ]; then
    command -v brew > /dev/null || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# for ubuntu
if [ "${OS_TYPE}" == "apt" ]; then
    export LC_ALL=C
fi

# update
echo "================================================================================"
echo "update..."

if [ "${OS_TYPE}" == "apt" ]; then
    sudo apt update && sudo apt upgrade -y
    command -v jq > /dev/null || sudo apt install -y jq
    command -v git > /dev/null || sudo apt install -y git
    command -v tmux > /dev/null || sudo apt install -y tmux
    command -v pip > /dev/null || sudo apt install -y python-pip
    command -v ab > /dev/null || sudo apt install -y apache2-utils
elif [ "${OS_TYPE}" == "yum" ]; then
    sudo yum update -y
    command -v jq > /dev/null || sudo yum install -y jq
    command -v git > /dev/null || sudo yum install -y git
    command -v tmux > /dev/null || sudo yum install -y tmux
    command -v pip > /dev/null || sudo yum install -y python-pip
    command -v ab > /dev/null || sudo yum install -y httpd-tools
elif [ "${OS_TYPE}" == "brew" ]; then
    brew update && brew upgrade
    command -v jq > /dev/null || brew install jq
    command -v git > /dev/null || brew install git
    command -v tmux > /dev/null || brew install tmux
    # getopt
    GETOPT=$(getopt 2>&1 | head -1 | xargs)
    if [ "${GETOPT}" == "--" ]; then
        brew install gnu-getopt
        brew link --force gnu-getopt
    fi
fi
