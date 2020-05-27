#!/bin/bash

# curl -sL opspresso.github.io/tools/install.sh | bash

REPO="opspresso.github.io/tools"

# update
curl -sL ${REPO}/base.sh | bash
# [ $? == 1 ] && exit 1

# awscli
curl -sL ${REPO}/awscli.sh | bash

# terraform
curl -sL ${REPO}/terraform.sh | bash

# kubectl
curl -sL ${REPO}/kubectl.sh | bash

# istioctl
curl -sL ${REPO}/istioctl.sh | bash

# helm
curl -sL ${REPO}/helm.sh | bash

# nodejs
curl -sL ${REPO}/nodejs.sh | bash

# # java
# curl -sL ${REPO}/java.sh | bash -s "1.8.0"

# # maven
# curl -sL ${REPO}/maven.sh | bash -s "3.5.4"

# # semver
# curl -sL ${REPO}/semver.sh | bash

# # aws-iam-authenticator
# curl -sL ${REPO}/aws-iam-authenticator.sh | bash -s "v0.3.0"

# clean
curl -sL ${REPO}/clean.sh | bash
