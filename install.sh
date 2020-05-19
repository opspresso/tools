#!/bin/bash

# curl -sL opspresso.com/install | bash

REPO="repo.opspresso.com/tools"

# update
curl -sL ${REPO}/base | bash
# [ $? == 1 ] && exit 1

# awscli
curl -sL ${REPO}/awscli | bash

# terraform
curl -sL ${REPO}/terraform | bash

# kubectl
curl -sL ${REPO}/kubectl | bash

# helm
curl -sL ${REPO}/helm | bash

# nodejs
curl -sL ${REPO}/nodejs | bash -s "14"

# # java
# curl -sL ${REPO}/java | bash -s "1.8.0"

# # maven
# curl -sL ${REPO}/maven | bash -s "3.5.4"

# semver
curl -sL ${REPO}/semver | bash -s "0.3.0"

# # aws-iam-authenticator
# curl -sL ${REPO}/aws-iam-authenticator | bash -s "v0.3.0"

# clean
curl -sL ${REPO}/clean | bash
