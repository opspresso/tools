#!/bin/bash

SHELL_DIR=$(dirname $0)

USERNAME=${CIRCLE_PROJECT_USERNAME}
REPONAME=${CIRCLE_PROJECT_REPONAME}

################################################################################

# command -v tput > /dev/null && TPUT=true
TPUT=

_echo() {
    if [ "${TPUT}" != "" ] && [ "$2" != "" ]; then
        echo -e "$(tput setaf $2)$1$(tput sgr0)"
    else
        echo -e "$1"
    fi
}

_result() {
    echo
    _echo "# $@" 4
}

_command() {
    echo
    _echo "$ $@" 3
}

_success() {
    echo
    _echo "+ $@" 2
    exit 0
}

_error() {
    echo
    _echo "- $@" 1
    exit 1
}

_prepare() {
    # target
    mkdir -p ${SHELL_DIR}/target

    # 755
    find ./** | grep [.]sh | xargs chmod 755
}

_s3_sync() {
    _command "aws s3 sync ${1} s3://${2}/ --acl public-read"
    aws s3 sync ${1} s3://${2}/ --acl public-read
}

_cf_reset() {
    CFID=$(aws cloudfront list-distributions --query "DistributionList.Items[].{Id:Id, DomainName: DomainName, OriginDomainName: Origins.Items[0].DomainName}[?contains(OriginDomainName, '${1}')] | [0].Id" | cut -d'"' -f2)
    if [ "${CFID}" != "" ]; then
        aws cloudfront create-invalidation --distribution-id ${CFID} --paths "/*"
    fi
}

build() {
    _prepare

    LIST=/tmp/list
    ls ${SHELL_DIR}/bin | sort > ${LIST}

    while read VAL; do
        TARGET=$(echo "${VAL}" | cut -d'.' -f1)
        cp ${SHELL_DIR}/bin/${VAL} ${SHELL_DIR}/target/${TARGET}
    done < ${LIST}

    _s3_sync "${SHELL_DIR}/target/" "www.opspresso.com/tools"
    _cf_reset "www.opspresso.com"

    _s3_sync "${SHELL_DIR}/target/" "repo.opspresso.com/tools"
    _cf_reset "repo.opspresso.com"
}

build
