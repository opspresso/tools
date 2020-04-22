#!/bin/bash

SHELL_DIR=$(dirname $0)

################################################################################

_prepare() {
    # target
    mkdir -p ${SHELL_DIR}/target/tools

    # 755
    find ./** | grep [.]sh | xargs chmod 755
}

_build() {
    _prepare

    # opspresso.com/install
    cp ${SHELL_DIR}/install.sh ${SHELL_DIR}/target/install

    LIST=/tmp/list
    ls ${SHELL_DIR}/bin | sort > ${LIST}

    # opspresso.com/tools
    while read FILENAME; do
        TARGET=$(echo "${FILENAME}" | cut -d'.' -f1)
        cp ${SHELL_DIR}/bin/${FILENAME} ${SHELL_DIR}/target/tools/${TARGET}
    done < ${LIST}
}

_build
