#!/bin/bash

SHELL_DIR=$(dirname $0)

################################################################################

_prepare() {
    # target
    mkdir -p ${SHELL_DIR}/target

    # 755
    find ./** | grep [.]sh | xargs chmod 755
}

_build() {
    _prepare

    LIST=/tmp/list
    ls ${SHELL_DIR}/bin | sort > ${LIST}

    while read FILENAME; do
        TARGET=$(echo "${FILENAME}" | cut -d'.' -f1)
        cp ${SHELL_DIR}/bin/${FILENAME} ${SHELL_DIR}/target/${TARGET}
    done < ${LIST}
}

_build
